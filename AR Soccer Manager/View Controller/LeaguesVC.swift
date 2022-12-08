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
    @IBOutlet weak var leagueSelector: UIButton!
    
    var leagueSelected = "pr"
    
    var standingsSorted = [TeamStanding]()
    let userId = String(decoding: UserRepository().getInfo(itemID: "userId")!, as: UTF8.self)
    
    override func loadView() {
        loadLeague(leagueName: leagueSelected)
        super.loadView()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Homebcg.jpg")!)
                
        self.StandingTableRef.dataSource = self
        self.StandingTableRef.delegate = self
        
        self.StandingTableRef.reloadData()
        
        print(userId)
        
        if #available(iOS 15.0, *) {
               leagueSelector.showsMenuAsPrimaryAction=true
               leagueSelector.changesSelectionAsPrimaryAction=true
           } else {
           }
           
           let optionSelector = {(action: UIAction) in
               self.leagueSelector.setTitle(action.title, for: .normal)
               
               var leagueAbrv = ""
               let actionTitle = action.title
               
               if(actionTitle == "Premier League") {
                   leagueAbrv = "pr"
               }else if(actionTitle == "Ligue 1") {
                   leagueAbrv = "lig"
               }else if(actionTitle == "La Liga") {
                   leagueAbrv = "lalig"
               }else if(actionTitle == "Bundesliga") {
                   leagueAbrv = "bund"
               }
               
               self.loadLeague(leagueName: leagueAbrv)
               
               print(actionTitle)
           }
           
           var menuItems = [UIAction]()
               
           let prMenuItem = UIAction(title: "Premier League", state: .off, handler: optionSelector)
           menuItems.append(prMenuItem)
           
           let laligMenuItem = UIAction(title: "La Liga", state: .off, handler: optionSelector)
           menuItems.append(laligMenuItem)
           
           let ligMenuItem = UIAction(title: "Ligue 1", state: .off, handler: optionSelector)
           menuItems.append(ligMenuItem)
           
           let bundMenuItem = UIAction(title: "Bundesliga", state: .off, handler: optionSelector)
           menuItems.append(bundMenuItem)
           
           let menu = UIMenu(title: "", options: .displayInline, children: menuItems)
           
           leagueSelector.menu = menu
               
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return standingsSorted.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamCell",
                                                             for: indexPath) as! TeamCell

        if(standingsSorted.count != 0 ){


            let team = standingsSorted[indexPath.row]
            

            cell.name?.text = String(indexPath.row + 1) + " - " + team.name
            cell.played?.text = String(team.played as! Int)
            cell.points?.text = String(team.points as! Int)
            cell.won?.text = String(team.won as! Int)
            cell.draw?.text = String(team.draw as! Int)
            cell.loss?.text = String(team.loss as! Int)
        }
       
        
        return cell
      
    }
    
    func loadLeague(leagueName: String) {
        
        
        let db=Firestore.firestore()
        
        print("PR")
        
        db.collection("users").document(userId).getDocument(){ (document, err) in
            if let document = document, document.exists {
                print("Document Good")
                let dataDescription = document.data()! as Dictionary<String, AnyObject>
                let leagues = dataDescription["leagues"] as! Dictionary<String, AnyObject>
                let league = leagues[leagueName] as! Dictionary<String, AnyObject>
                
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
