//
//  LeaguesVC.swift
//  AR Soccer Manager
//
//  Created by Samuel Gerges on 2022-11-16.
//

import Foundation
import UIKit
import FirebaseCore
import FirebaseFirestore

class TeamCell: UITableViewCell {
    @IBOutlet var name : UILabel?
    @IBOutlet var played : UILabel?
    @IBOutlet var points : UILabel?
    @IBOutlet var won : UILabel?
    @IBOutlet var draw : UILabel?
    @IBOutlet var loss : UILabel?
}

class LeaguesVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var StandingTableRef: UITableView!
    @IBOutlet weak var HeaderCell: UIView!
    
    var standingsSorted = [TeamStanding]()
    let userId = String(decoding: UserRepository().getInfo(itemID: "userId")!, as: UTF8.self)
    
    override func loadView() {
        loadLeague()
        super.loadView()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Homebcg.jpg")!)
                
        self.StandingTableRef.dataSource = self
        self.StandingTableRef.delegate = self
        
        self.StandingTableRef.reloadData()
        
        print(userId)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamCell",
                                                             for: indexPath) as! TeamCell

        if(standingsSorted.count != 0 ){


            let team = standingsSorted[indexPath.row]
            

            cell.name?.text = String(indexPath.row) + " - " + team.name
            cell.played?.text = String(team.played as! Int)
            cell.points?.text = String(team.points as! Int)
            cell.won?.text = String(team.won as! Int)
            cell.draw?.text = String(team.draw as! Int)
            cell.loss?.text = String(team.loss as! Int)
        }
       
        
        return cell
      
    }
    
    func loadLeague() {
        
        
        let db=Firestore.firestore()
        
        print("PR")
        
        db.collection("users").document(userId).getDocument(){ (document, err) in
            if let document = document, document.exists {
                print("Document Good")
                let dataDescription = document.data()! as Dictionary<String, AnyObject>
                let leagues = dataDescription["leagues"] as! Dictionary<String, AnyObject>
                let league = leagues["pr"] as! Dictionary<String, AnyObject>
                
                let teams = league["standing"] as! [Dictionary<String, AnyObject>]
                var teamsSorted = [TeamStanding]()
                
                for item in teams {
                    let newObj = TeamStanding()
                    newObj.name = item["name"] as! String
                    newObj.played = item["played"] as! Int
                    newObj.won = item["won"] as! Int
                    newObj.loss = item["loss"] as! Int
                    newObj.draw = item["draw"] as! Int
                    newObj.points = item["points"] as! Int
                    
                    teamsSorted.append(newObj)
                }
                teamsSorted = teamsSorted.sorted(by:{ $0.points > $1.points } )
                
                self.standingsSorted = teamsSorted
                
                DispatchQueue.main.async {
                    self.StandingTableRef.reloadData()
                }
                   
            } else {
                print("Document does not exist")
            }
        }
        
    }
    
    class TeamStanding {
        var draw = Int()
        var loss = Int()
        var played = Int()
        var points = Int()
        var won = Int()
        var name = String()
    }
    

}
