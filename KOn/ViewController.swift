//
//  ViewController.swift
//  KOnn
//
//  Created by 荒川陸 on 2021/12/12.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        highScore = UserDefaults.standard.integer(forKey: "highScore")
        highLabel.text = "High: \(highScore)"
        for (index,button) in buttons.enumerated() {
            button.tag = index
        }
    }
    let hit = SimpleSound(named: "hit")
    let tih = SimpleSound(named: "tih")
    @IBOutlet weak var highLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet var buttons: [UIButton]!
    var btndsApearTimer: [Int:Timer] = [:]
    var btnKonState: [Bool] = [Bool](repeating: false, count: 20)
    @IBOutlet weak var levelLabel: UILabel!
    let normal = UIImage(named: "normal")
    let silver = UIImage(named: "silver")
    let gold = UIImage(named: "gold")
    let neko = UIImage(named: "neko")
    let down = UIImage(named: "down")
    var score = 0
    var highScore = 0
    var level = 1
    var amountUpto = 3
    var intervalSec: TimeInterval = 1
    
    var stopWatch: Timer?
    
    var clock: Timer?
    @objc func update() {
        var amount = amountUpto
        while amount != 0 {
            var index = Int.random(in: 0...19)
            while btnKonState[index] {
                index = Int.random(in: 0...19)
            }
            let grade = Int.random(in: 0...8)
            var disAppearInterval:Double = 5
            if grade == 0 {
                buttons[index].setImage(gold, for: .normal)
                disAppearInterval = 3
            } else if grade == 1 {
                buttons[index].setImage(silver, for: .normal)
                disAppearInterval = 4
            } else if grade == 2 {
                buttons[index].setImage(neko, for: .normal)
            } else {
                buttons[index].setImage(normal, for: .normal)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + disAppearInterval, execute: {[self] in
                buttons[index].setImage(down, for: .normal)
            })
            amount -= 1
        }
    }
    var time = 0
    @IBOutlet weak var timeLabel: UILabel!
    @objc func watch() {
        time += 1
        timeLabel.text = "\("0\(Int(time/60))".suffix(2)):\("0\(time%60)".suffix(2))"
    }
    @IBAction func levelStepper(_ sender: UIStepper) {
        level = Int(sender.value)
        levelLabel.text = "Lv.\(level)"
        amountUpto = level % 3 + Int(level / 3) + 2
        intervalSec = pow(0.5, Double(Int(level / 2)))
    }
    @IBOutlet weak var levelSetpperOutlet: UIStepper!
    var isPlaying = false
    @IBAction func startButton(_ sender: UIButton) {
        if !isPlaying {
            clock = Timer.scheduledTimer(timeInterval: intervalSec, target: self, selector: #selector(update), userInfo: nil, repeats: true)
            stopWatch = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(watch), userInfo: nil, repeats: true)
            sender.setTitle("STOP", for: .normal)
            sender.tintColor = .systemRed
            levelSetpperOutlet.isEnabled = false
            isPlaying = true
        } else {
            isPlaying = false
            clock!.invalidate()
            stopWatch!.invalidate()
            timeLabel.text = "00:00"
            scoreLabel.text = "0"
            time = 0
            highScore = max(highScore,score)
            levelSetpperOutlet.isEnabled = true
            highLabel.text = "High: \(highScore)"
            UserDefaults.standard.set(highScore, forKey: "highScore")
            sender.setTitle("START", for: .normal)
            sender.tintColor = .systemBlue
            btnKonState = [Bool](repeating: false, count: 20)
            for button in buttons {
                button.setImage(down, for: .normal)
            }
        }
    }
    @IBAction func knockBtn(_ sender: UIButton) {
        if isPlaying {
            btndsApearTimer[sender.tag]?.invalidate()
            if sender.image(for: .normal) == gold {
                hit.play()
                score += 5
            } else if sender.image(for: .normal) == silver {
                hit.play()
                score += 3
            } else if sender.image(for: .normal) == normal {
                hit.play()
                score += 1
            } else if sender.image(for: .normal) == neko {
                tih.play()
                score -= 3
            }
            sender.setImage(down, for: .normal)
            scoreLabel.text = String(score)
            highScore = max(highScore,score)
            highLabel.text = "High: \(highScore)"
            UserDefaults.standard.set(highScore, forKey: "highScore")
        }
    }
}

final class Action: NSObject {

    private let _action: () -> ()

    init(action: @escaping () -> ()) {
        _action = action
        super.init()
    }

    @objc func action() {
        _action()
    }

}
