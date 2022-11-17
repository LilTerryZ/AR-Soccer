//
//  TradeVC.swift
//  AR Soccer Manager
//
//  Created by Haonan Zhang on 2022-11-16.
//

import Foundation
import UIKit

class TradeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Homebcg.jpg")!)

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

}
