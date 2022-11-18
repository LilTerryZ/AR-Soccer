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
    @IBOutlet weak var username: UITextField!
    
    @IBAction func signUpBtn(_ sender: Any) {
        self.Register()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Homebcg.jpg")!)
        passwd.isSecureTextEntry = true
        repasswd.isSecureTextEntry = true
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
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        if (self.email.text != "" && self.passwd.text != "" && self.repasswd.text != "" && self.username.text != ""){
            if(vc.isValidEmailAddr(strToValidate: self.email.text!)==true){
                if(self.passwd.text!.count>5){
                    if self.passwd.text == self.repasswd.text{
                      
                            Auth.auth().createUser(withEmail: self.email.text!, password: self.passwd.text! ) { (res, err) in
                                
                                if err != nil{
                                    
                                    let alert = UIAlertController(title: "Error", message: "Please fill all the credential property", preferredStyle: UIAlertController.Style.alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                                    self.present(alert, animated: true, completion: nil)
                                    
                                    return
                                }
                                
                                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                                changeRequest?.displayName = self.username.text
                                changeRequest?.commitChanges { err in
//                                if error == nil {
//                                   self.saveProfile(username: username) { success in
//                                       if success {
//                                           print("Success upload of profile image")
//                                           self.dismiss(animated: true, completion: nil)
//                                       }
//                                   }
//                                   self.dismiss(animated: true, completion: nil)
//                               } else {
//                                   guard let message = error?.localizedDescription else { return }
//                                   self.userAlert(message: message)
//                               }
                                
                                
                                
                                if err != nil{
                                    
                                    let alert = UIAlertController(title: "Error", message: "Save username fail", preferredStyle: UIAlertController.Style.alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                                    self.present(alert, animated: true, completion: nil)
                                    
                                    return
                                }
                                
                            }
                            
                            print("success")
                            
                            UserDefaults.standard.set(true, forKey: "status")
                            NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                            
                            
                            vc.txtEmail = self.email.text!
                            vc.modalPresentationStyle = .fullScreen
                            self.present(vc,animated: true,completion: nil)
                        }
              
                }
                else{
                    
                    let alert = UIAlertController(title: "Password mismatch", message: "Two passwords don't match", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }else{
                let alert = UIAlertController(title: "Password length Error", message: "The minimal password length is 6", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            }else{
                let alert = UIAlertController(title: "Email format Error", message: "The email format is incorrect", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }else{
            
            let alert = UIAlertController(title: "Sign up Error", message: "Please fill all required fields", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        
        }
   
      
    }
    
    
}
