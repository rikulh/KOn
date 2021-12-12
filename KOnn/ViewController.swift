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
    }
    
    @IBOutlet var buttons: [UIImageView]!
    let normal = UIImage(named: "normal")
    let silver = UIImage(named: "silver")
    let gold = UIImage(named: "gold")
    let neko = UIImage(named: "neko")
    let down = UIImage(named: "down")
    @objc func update() {
        var amount = Int.random(in: 0...3)
        while amount != 0 {
            let index = Int.random(in: 0...20)
            let grade = Int.random(in: 0...8)
            if grade == 0 {
                buttons[index].image = gold
            } else if grade == 1 {
                buttons[index].image = silver
            } else if grade == 2 {
                buttons[index].image = neko
            } else {
                buttons[index].image = normal
            }
        }
    }


}

