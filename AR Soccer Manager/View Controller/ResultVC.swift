//
//  ResultVC.swift
//  AR Soccer Manager
//
//  Created by Haonan Zhang on 2022-11-04.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import FirebaseDatabase

class ResultVC: UIViewController{

    @IBOutlet weak var userClub: UILabel!
    @IBOutlet weak var userClub2: UILabel!
    @IBOutlet weak var oppositeClub2: UILabel!
    @IBOutlet weak var oppositeClub: UILabel!
    @IBOutlet weak var userScore: UILabel!
    @IBOutlet weak var oppositeScore: UILabel!
    @IBOutlet weak var userShots: UILabel!
    @IBOutlet weak var oppositeShots: UILabel!
    @IBOutlet weak var userPasses: UILabel!
    @IBOutlet weak var oppositePassses: UILabel!
    @IBOutlet weak var userPose: UILabel!
    @IBOutlet weak var oppositePose: UILabel!
    @IBOutlet weak var eventsList: UITableView!
    @IBOutlet weak var exp: UILabel!
    
    var txtUserClub="",txtOppositeClub="",txtUserScore="0",txtOppositeScore="",txtUserShots="0",txtOppositeShots="",txtUserPasses="",txtOppositePassses="",txtUserPose="",txtOppositePose="",totPasses=0.0,totShots=0.0,totScore=0.0, wins=0,txtGamePlayed=0.0,txtAvgScore=0.0,txtAvgShots=0.0,txtAvgPasses=0.0,txtExp=0,txtLevel=1,totExp=0,DbavgScore="",DbavgShots="",DbavgPasses=""
    
    
    var events = ["Game Events:"]
    var allData=[String:Any]()
    let db=Firestore.firestore()
    let user = Auth.auth().currentUser
    let userDefault = UserRepository()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Homebcg.jpg")!)
       
     
        userScore.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.heavy)
        oppositeScore.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.heavy)
        eventsList.delegate=self
        eventsList.dataSource=self
        userClub.text=txtUserClub
        userClub2.text=txtUserClub
        userPose.text=txtUserPose
        
        userPasses.text=txtUserPasses
        userScore.text=txtUserScore
        userShots.text=txtUserShots
        
        oppositePassses.text=txtOppositePassses
        oppositePose.text=txtOppositePose
        oppositeScore.text=txtOppositeScore
        oppositeShots.text=txtOppositeShots
        oppositeClub2.text=txtOppositeClub
        oppositeClub.text=txtOppositeClub
//        eventsList.register(UITableViewCell.self, forCellReuseIdentifier: "eventCell")
//        user!.totScore+=txtUserScore
       
//        let userId = userDefault.getInfo(itemID: "userId")
        self.getUserData()

     
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        
       
    }

    
    func saveUserData(){
        
        let userId = user?.uid
        print("UserID=========\(userId)")
   
        let userData = ["totScore": totScore,
                       "totShots": totShots,
                       "totPasses": totPasses,
                       "wins": wins,
                       "gamePlayed": txtGamePlayed,
                       "avgScore": DbavgScore,
                       "avgShots": DbavgShots,
                        "avgPasses": DbavgPasses,
                        "exp": totExp,
                        "level": txtLevel,
                        "game":[ "game\(String(format: "%.0f", self.txtGamePlayed))":[
                            "userClubName":txtUserClub,
                            "oppoClubName":txtOppositeClub,
                            "userScore":txtUserScore,
                            "oppoScore":txtOppositeScore
                            ]
                        ]
                            ] as [String : Any]

        db.collection("users").document(userId!).setData(userData,merge: true) { err in
            if let err = err {
               print("Error saving user data: \(err)")
           } else {
               print("User data successfully written!")
           }
       }
        
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
            self.txtLevel=Int("\(self.allData["level"] ?? "1")")!
            self.totExp=Int("\(self.allData["exp"] ?? "0")")!
            
            self.totScore=Double("\(self.allData["totScore"] ?? "0")")!
            self.totShots=Double("\(self.allData["totShots"] ?? "0")")!
            self.totPasses=Double("\(self.allData["totPasses"] ?? "0")")!
            self.txtGamePlayed=Double("\(self.allData["gamePlayed"] ?? "0")")!
            self.wins=Int("\(self.allData["wins"] ?? "0")")!
            self.txtAvgScore=Double("\(self.allData["avgScore"] ?? "0")")!
            self.txtAvgShots=Double("\(self.allData["avgShots"] ?? "0")")!
            self.txtAvgPasses=Double("\(self.allData["avgPasses"] ?? "0")")!

            //Calculation
            self.totScore+=Double(self.txtUserScore)!
            self.totShots+=Double(self.txtUserShots)!
            self.totPasses+=Double(self.txtUserPasses)!
            if(self.txtUserScore>self.txtOppositeScore){
                self.wins+=1
            }
            self.txtGamePlayed+=1
           
            self.txtAvgScore=self.totScore/self.txtGamePlayed
            self.DbavgScore = String(format: "%.1f", self.txtAvgScore)
           
            self.txtAvgShots=self.totShots/self.txtGamePlayed
            self.DbavgShots = String(format: "%.1f", self.txtAvgShots)
           
            self.txtAvgPasses=(self.totPasses/self.txtGamePlayed)
            self.DbavgPasses = String(format: "%.1f", self.txtAvgPasses)

            self.txtExp+=(Int(self.txtUserScore)!+1)*20
            self.txtExp+=Int(self.txtUserShots)!*5
            self.txtExp+=(Int(self.txtUserPasses)!*2/10)
            self.totExp+=self.txtExp
            print("totexp: \(self.totExp)")
            self.exp.text="Exp +\(self.txtExp)"
            if(self.totExp>=200){
                let counter=self.totExp/200
                let remainder=self.totExp%200
                self.txtLevel+=counter
                self.totExp=0+remainder
                print("totexp2: \(self.totExp)")
                print("txtexp2: \(self.txtExp)")
            }
            
            
            self.saveUserData()
            }
        
        
           
            
       }
//    func getUserData(){
//        let userId = user!.uid
//        let userData = db.collection("users").document(userId)
//        userData.getDocument{ (document, err) in
//                if let err = err {
//                    print("Error getting documents: \(err)")
//                } else {
//                    if let document = document, document.exists {
//                        if(document.data()!["totScore"] != nil){
//                            self.totScore=document.data()!["totScore"]! as! Int
//                        }
//                        if(document.data()!["totShots"] != nil){
//                            self.totShots=document.data()!["totShots"]! as! Int
//                        }
//                        if(document.data()!["totPasses"] != nil){
//                            self.totPasses=document.data()!["totPasses"]! as! Int
//                        }
//                        if(document.data()!["wins"] != nil){
//                            self.wins=document.data()!["wins"] as! Int
//                        }
//                        if(document.data()!["gamePlayed"] != nil){
//                            self.txtGamePlayed=document.data()!["gamePlayed"]! as! Int
//                        }
//                        if(document.data()!["avgPasses"] != nil){
//                            self.txtAvgScore=document.data()!["avgPasses"]! as! Int}
//
//                        if(document.data()!["avgShots"] != nil){
//                            self.txtAvgPasses=document.data()!["avgShots"]! as! Int
//                        }
//                        if(document.data()!["avgScore"] != nil){
//                            self.txtAvgShots=document.data()!["avgScore"]! as! Int
//                        }
//                    }
//
//                }
//
//
//            }
//       }
    
}


extension ResultVC:UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return events.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("cell tapped")
    }

}
extension ResultVC:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return events.count
    }
    func tableView(_ tableView:UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
       // let cell = tableView.dequeueReusableCell(withIdentifier: "foodCellType", for: indexPath) as! LeaderCell
        let eventCell=tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath)
        eventCell.textLabel?.text=events[indexPath.row]

        return eventCell

    }
}
