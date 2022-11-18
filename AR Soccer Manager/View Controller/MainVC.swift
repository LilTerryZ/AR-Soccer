//
//  MainVC.swift
//  AR Soccer Manager
//
//  Created by Samuel Gerges on 2022-11-16.
//

import Foundation
import UIKit
import FirebaseAuth

class MainVC: UIViewController{
    
    
    @IBOutlet weak var txtWelcome: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Homebcg.jpg")!)
        
        let userDefault = UserRepository()
        
        let userId = userDefault.getInfo(itemID: "userId")
        

        let user = Auth.auth().currentUser
        if let user = user {
          var multiFactorString = "MultiFactor: "
          for info in user.multiFactor.enrolledFactors {
            multiFactorString += info.displayName ?? "[DispayName]"
            multiFactorString += " "
          }
        
        }

        if Auth.auth().currentUser != nil {
            self.txtWelcome.text="Welcome back \(user?.displayName ?? "User")"
        }
        
        //print(String(decoding: userId!, as: UTF8.self))
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}
