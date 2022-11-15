//
//  LoginVC.swift
//  AR Soccer Manager
//
//  Created by Haonan Zhang on 2022-11-14.
//
import Foundation
import UIKit
import FirebaseAuth
//import RxSwift
//import RxCocoa


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
    
    let rxbag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Homebcg.jpg")!)
        
//        googleLogin()
//        facebookLogin()
//
//        fbButton.rx.tap.bind{ [weak self] _ in
//            guard let strongSelf = self else {return}
//            RRFBLogin.shared.fbLogin(viewController: strongSelf)
//        }.disposed(by: rxbag)
//
//        googleButton.rx.tap.bind{ [weak self] _ in
//            guard let strongSelf = self else {return}
//            RRGoogleLogin.shared.googleSignIn(viewController: strongSelf)
//        }.disposed(by: rxbag)
//    }


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


extension ViewController{
    
    private func googleLogin() {
        RRGoogleLogin.shared.googleUserDetails.asObservable()
        .subscribe(onNext: { [weak self] (userDetails) in
            guard let strongSelf = self else {return}
            strongSelf.socialLogin(user: userDetails)
        }, onError: { [weak self] (error) in
            guard let strongSelf = self else {return}
            strongSelf.showAlert(title: nil, message: error.localizedDescription)
        }).disposed(by: rxbag)
    }
    
    private func facebookLogin() {
        RRFBLogin.shared.fbUserDetails.asObservable()
        .subscribe(onNext: { [weak self] (userDetails) in
            guard let strongSelf = self else {return}
            strongSelf.socialLogin(user: userDetails)
        }, onError: { [weak self] (error) in
            guard let strongSelf = self else {return}
            strongSelf.showAlert(title: nil, message: error.localizedDescription)
        }).disposed(by: rxbag)
    }
    
    fileprivate func socialLogin(user :SocialUserDetails) {
        //print(user.type)
        print(user.name)
        print(user.email)
    }
    
    func showAlert(title : String?, message : String?, handler: ((UIAlertController) -> Void)? = nil){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            handler?(alertController)
        }))
        self.present(alertController, animated: true, completion: nil)
    }
}

