//
//  ProfileVC.swift
//  AR Soccer Manager
//
//  Created by Haonan Zhang on 2022-10-02.
//

import Foundation
import UIKit
import FirebaseAuth



class ProfileVC: UIViewController {
  
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var gamePlayed: UILabel!
    @IBOutlet weak var wins: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = Auth.auth().currentUser
        if let user = user {
          let uid = user.uid
          let email = user.email
          var multiFactorString = "MultiFactor: "
          for info in user.multiFactor.enrolledFactors {
            multiFactorString += info.displayName ?? "[DispayName]"
            multiFactorString += " "
          }
        
        }
        
        if Auth.auth().currentUser != nil {
            self.username.text=user!.displayName!
        }
        

        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

}
