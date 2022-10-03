//
//  ProfileVC.swift
//  AR Soccer Manager
//
//  Created by Haonan Zhang on 2022-10-02.
//

import Foundation
import UIKit

class ProfileVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

}
