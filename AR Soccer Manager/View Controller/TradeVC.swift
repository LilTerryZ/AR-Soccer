//
//  TradeVC.swift
//  AR Soccer Manager
//
//  Created by Haonan Zhang on 2022-10-02.
//

import Foundation
import UIKit

class TradeVC: UIViewController {

    @IBOutlet weak var img: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Homebcg.jpg")!)
        self.img.image=UIImage(named: "1.png")
        self.img.frame = CGRect(x: 0, y: 0, width: 96, height: 96)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

}
