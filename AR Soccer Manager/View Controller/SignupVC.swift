//
//  SignupVC.swift
//  AR Soccer Manager
//
//  Created by Haonan Zhang on 2022-11-14.
//

import Foundation
import UIKit
import FirebaseAuth


class SignupVC: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var passwd: UITextField!
    @IBOutlet weak var repasswd: UITextField!
    @IBOutlet weak var signUpBtn: UIButton!
    
    
    @IBAction func signUpBtn(_ sender: Any) {
        self.Register()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Homebcg.jpg")!)
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    func Register(){
        if self.email.text != ""{
            
            if self.passwd.text == self.repasswd.text{
                
                Auth.auth().createUser(withEmail: self.email.text!, password: self.passwd.text!) { (res, err) in
                    
                    if err != nil{
                        
                        let alert = UIAlertController(title: "Sign up Error", message: "Please fill all the credential property", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    
                        return
                    }
                    
                    print("success")
                    
//                    UserDefaults.standard.set(true, forKey: "status")
//                    NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                }
            }
            else{
             
                    let alert = UIAlertController(title: "Password mismatch", message: "Please reenter password", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                
            }
        }
        else{
            
            let alert = UIAlertController(title: "Sign up Error", message: "Please fill all the credential property", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        
        }
        
    }
    
    
}
