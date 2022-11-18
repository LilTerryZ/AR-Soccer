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
    
    var txtEmail=""
    var iconClick = true
    
    @IBAction func iconAction(sender: AnyObject) {
        if iconClick {
            passwd.isSecureTextEntry = false
        } else {
            passwd.isSecureTextEntry = true
        }
        iconClick = !iconClick
    }
    
    
    @IBAction func signInBtn(_ sender: Any) {
        self.Verify()
    }
    
    @IBAction func findPasswdBtn(_ sender: Any) {
        self.ResetPassword()
    }
    
//    let rxbag = DisposeBag()
    let userDefault = UserRepository()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Homebcg.jpg")!)
        
        passwd.isSecureTextEntry = true
        
        if(txtEmail != ""){self.email.text=txtEmail}
        
        let userId = userDefault.getInfo(itemID: "userId")
//        print(String(decoding: userId!, as: UTF8.self))
        
        if(userId != nil){
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainVC") as! MainVC
            vc.modalPresentationStyle = .fullScreen
            present(vc,animated: true,completion: nil)
        }
        
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
        
//        handle = Auth.auth().addStateDidChangeListener { auth, user in
//      
//        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        Auth.auth().removeStateDidChangeListener(handle!)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    func isValidEmailAddr(strToValidate: String) -> Bool {
      let emailValidationRegex = "^[\\p{L}0-9!#$%&'*+\\/=?^_`{|}~-][\\p{L}0-9.!#$%&'*+\\/=?^_`{|}~-]{0,63}@[\\p{L}0-9-]+(?:\\.[\\p{L}0-9-]{2,7})*$"  // 1

      let emailValidationPredicate = NSPredicate(format: "SELF MATCHES %@", emailValidationRegex)  // 2

      return emailValidationPredicate.evaluate(with: strToValidate)  // 3
    }
    
    func Verify(){
        if self.email.text != "" && self.passwd.text != ""{
            if(self.isValidEmailAddr(strToValidate: self.email.text!)==true){
                Auth.auth().signIn(withEmail: self.email.text!, password: self.passwd.text!) { (res, err) in
                    if err != nil{
                        let alert = UIAlertController(title: "Login Error", message: "The email or password is incorrect", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        
                        return
                    }
                    
                    print("Login success!")
                    
                    UserDefaults.standard.set(true, forKey: "status")
                    NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                }
                let user = Auth.auth().currentUser
                if let user = user {
                    // The user's ID, unique to the Firebase project.
                    // Do NOT use this value to authenticate with your backend server,
                    // if you have one. Use getTokenWithCompletion:completion: instead.
                    let uid = user.uid
                    let email = user.email
                    let photoURL = user.photoURL
                }
                
                
                
                userDefault.removeInfo(itemID: "userId")
                userDefault.storeInfo(itemID: "userId", data: user?.uid.data(using: .utf8) as! Data)
                
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainVC") as! MainVC
                vc.modalPresentationStyle = .fullScreen
                present(vc,animated: true,completion: nil)
                
            }else{
                let alert = UIAlertController(title: "Login Error", message: "The email format is incorrect", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
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
            
            let alert = UIAlertController(title: "Email is empty", message: "Fill in the Email please", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        
        }
    }
    
    
    
    
}


//extension ViewController{
//
//    private func googleLogin() {
//        GoogleLogin.shared.googleUserDetails.asObservable()
//        .subscribe(onNext: { [weak self] (userDetails) in
//            guard let strongSelf = self else {return}
//            strongSelf.socialLogin(user: userDetails)
//        }, onError: { [weak self] (error) in
//            guard let strongSelf = self else {return}
//            strongSelf.showAlert(title: nil, message: error.localizedDescription)
//        }).disposed(by: rxbag)
//    }
//
//    private func facebookLogin() {
//        FBLogin.shared.fbUserDetails.asObservable()
//        .subscribe(onNext: { [weak self] (userDetails) in
//            guard let strongSelf = self else {return}
//            strongSelf.socialLogin(user: userDetails)
//        }, onError: { [weak self] (error) in
//            guard let strongSelf = self else {return}
//            strongSelf.showAlert(title: nil, message: error.localizedDescription)
//        }).disposed(by: rxbag)
//    }
//
//    fileprivate func socialLogin(user :SocialUserDetails) {
//        //print(user.type)
//        print(user.name)
//        print(user.email)
//    }
//
//    func showAlert(title : String?, message : String?, handler: ((UIAlertController) -> Void)? = nil){
//        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
//            handler?(alertController)
//        }))
//        self.present(alertController, animated: true, completion: nil)
//    }
//}

