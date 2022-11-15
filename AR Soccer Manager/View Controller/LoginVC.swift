//
//  LoginVC.swift
//  AR Soccer Manager
//
//  Created by Haonan Zhang on 2022-11-14.
//
import Foundation
import UIKit
import FirebaseAuth


class LoginVC: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var passwd: UITextField!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var findPasswdBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var logo: UIImageView!
    
    
    @IBAction func signInBtn(_ sender: Any) {
        self.Verify()
    }
    
    @IBAction func findPasswdBtn(_ sender: Any) {
        self.ResetPassword()
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
    
    
    
    func Verify(){
        if self.email.text != "" && self.passwd.text != ""{
            Auth.auth().signIn(withEmail: self.email.text!, password: self.passwd.text!) { (res, err) in
                if err != nil{
                    
                    let alert = UIAlertController(title: "Login Error", message: "The email or password is incorrect", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                
                    return
                }
                
                print("Login success!")
//                UserDefaults.standard.set(true, forKey: "status")
//                NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
            }
        }else{
            
            let alert = UIAlertController(title: "Login Error", message: "Please fill all the credential property", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        
       }
    }
    
    func ResetPassword(){
        if self.email.text != ""{
            
            Auth.auth().sendPasswordReset(withEmail: self.email.text!) { (err) in
                if err != nil{
                    
                    let alert = UIAlertController(title: "Password Reset Sucessfully!", message: "A new password is sent to your email!", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                
                    return
                }
            }
        }
        else{
            
            let alert = UIAlertController(title: "Email Id is empty", message: "Fill in the Email please", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        
        }
    }
    
    
    
    
}
