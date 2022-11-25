//
//  SettingsVC.swift
//  AR Soccer Manager
//
//  Created by Haonan Zhang on 2022-10-02.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore
import AVFoundation

class SettingsVC: UIViewController {
    let db=Firestore.firestore()
    let user = Auth.auth().currentUser

    @IBOutlet weak var signOutBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var supportBtn: UIButton!
    @IBOutlet weak var creditsBtn: UIButton!
    @IBOutlet weak var musicBtn: UISwitch!
    
    
    @IBAction func musicBtn(_ sender: Any) {
        if ((sender as AnyObject).isOn == true) {
                MusicPlayer.shared.startBackgroundMusic()
            }else{
                MusicPlayer.shared.stopBackgroundMusic()
                }
    }
    @IBAction func supportBtn(_ sender: Any) {
        let alert = UIAlertController(title: "Support contacts", message:   "Please contact zhahaon@sheridancollege.ca for help", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func creditsBtn(_ sender: Any) {
        let alert = UIAlertController(title: "Developers Info", message: "This app is built by Haonan Zhang, Diamond Winter-Hogan and Samuel Gerges.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func deleteBtn(_ sender: Any) {
        let userId = user!.uid
        let alert = UIAlertController(title: "DELETE ACCOUNT", message: "Are you sure to delete your acoout?", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "YES", style: UIAlertAction.Style.default, handler:{(_) in
            
            self.db.collection("users").document(userId).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("User document successfully removed!")
                }
            }
            self.user!.delete();
       
            
            print("User deleted")
            
            let alert2 = UIAlertController(title: "Deleted Successful", message: "Your account has been successfully deleted", preferredStyle: UIAlertController.Style.alert)
            alert2.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{(_) in
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                vc.modalPresentationStyle = .fullScreen
                self.present(vc,animated: true,completion: nil)
            }))
            self.present(alert2, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "CANCEL", style: UIAlertAction.Style.default, handler: nil))
 
        self.present(alert, animated: true, completion: nil)
        
    }
    
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
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    
    
    
}

class MusicPlayer{
    var audioPlayer: AVAudioPlayer?
    static let shared = MusicPlayer()
    
    func startBackgroundMusic() {
        if let bundle = Bundle.main.path(forResource: "music", ofType: "mp3") {
                let backgroundMusic = NSURL(fileURLWithPath: bundle)
            do {
                    audioPlayer = try AVAudioPlayer(contentsOf:backgroundMusic as URL)
                    guard let audioPlayer = audioPlayer else { return }
                    audioPlayer.numberOfLoops = -1
                    //audioPlayer.prepareToPlay()
                    audioPlayer.play()
                    print("Background music starts")
                } catch {
                    print(error)
                }
            }
        }
    
    func stopBackgroundMusic() {
        guard let audioPlayer = audioPlayer else { return }
        audioPlayer.stop()
        print("Background music stops")
    }
    
}
