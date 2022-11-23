//
//  SettingsVC.swift
//  AR Soccer Manager
//
//  Created by Haonan Zhang on 2022-10-02.
//

import Foundation
import UIKit
import FirebaseAuth

class SettingsVC: UIViewController {

    
    @IBOutlet weak var signOutBtn: UIButton!
    
    
    @IBAction func signnOutBtn(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            vc.modalPresentationStyle = .fullScreen
            present(vc,animated: true,completion: nil)
        }catch let error as NSError{
            print(error.localizedDescription)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Homebcg.jpg")!)
//        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Homebcg.jpg")!)

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

}
