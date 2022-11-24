//
//  ProfileVC.swift
//  AR Soccer Manager
//
//  Created by Haonan Zhang on 2022-10-02.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseCore
import FirebaseFirestore


class ProfileVC: UIViewController {
  
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var gamePlayed: UILabel!
    @IBOutlet weak var wins: UILabel!
    @IBOutlet weak var totScore: UILabel!
    @IBOutlet weak var avgScore: UILabel!
    @IBOutlet weak var totShots: UILabel!
    @IBOutlet weak var avgShots: UILabel!
    @IBOutlet weak var totPasses: UILabel!
    @IBOutlet weak var avgPasses: UILabel!
    @IBOutlet weak var level: UILabel!
    @IBOutlet weak var exp: UILabel!
    
//
//    var txtTotScore="0",txtTotShots="0",txtTotPasses=0, txtWins=0,txtGamePlayed=0,txtAvgScore=0.0,txtAvgShots=0.0,txtAvgPasses=0
//
    let user = Auth.auth().currentUser
    let db=Firestore.firestore()
    
    var allData=[String:Any]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getUserData()
        if Auth.auth().currentUser != nil {
            self.username.text=user!.displayName!
        }
        
      

        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
      


    }

    
    func getUserData(){
        let userId = user!.uid
        let docRef = db.collection("users").document(userId)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                self.allData=document.data()!
                print("Document data: \(self.allData)")
            } else {
                print("Document does not exist")
            }
            let txtExp="\(self.allData["level"] ?? "1")"
            let txtLevel="\(self.allData["exp"] ?? "0")"
            self.level.text="Level \(txtExp)"
            self.exp.text="\(txtLevel)/200"
            
            self.totScore.text="\(self.allData["totScore"] ?? "0")"
            self.totShots.text="\(self.allData["totShots"] ?? "0")"
            self.totPasses.text="\(self.allData["totPasses"] ?? "0")"
            self.gamePlayed.text="\(self.allData["gamePlayed"] ?? "0")"
            self.wins.text="\(self.allData["wins"] ?? "0")"
            
            let txtAvgScore="\(self.allData["avgScore"] ?? "0")"
            
            
            self.avgScore.text=txtAvgScore
            self.avgShots.text="\(self.allData["avgShots"] ?? "0")"
            self.avgPasses.text="\(self.allData["avgPasses"] ?? "0")"
            }
       }
    

    
}
