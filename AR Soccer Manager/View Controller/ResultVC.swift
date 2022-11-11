//
//  ResultVC.swift
//  AR Soccer Manager
//
//  Created by Haonan Zhang on 2022-11-04.
//

import Foundation
import UIKit

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
    
    var txtUserClub="",txtOppositeClub="",txtUserScore="",txtOppositeScore="",txtUserShots="",txtOppositeShots="",txtUserPasses="",txtOppositePassses="",txtUserPose="",txtOppositePose=""
    
    
    var events = ["Game Events:"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Homebcg.jpg")!)
        userScore.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.heavy)
        oppositeScore.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.heavy)
        eventsList.delegate=self
        eventsList.dataSource=self
        userScore.text=txtUserScore
        oppositePassses.text=txtOppositePassses
        oppositePose.text=txtOppositePose
        oppositeScore.text=txtOppositeScore
        oppositeShots.text=txtOppositeShots
        userClub.text=txtUserClub
        userClub2.text=txtUserClub
        userPose.text=txtUserPose
        userPasses.text=txtUserPasses
        userShots.text=txtUserShots
        oppositeClub2.text=txtOppositeClub
        oppositeClub.text=txtOppositeClub
//        eventsList.register(UITableViewCell.self, forCellReuseIdentifier: "eventCell")
        
//        userClub.text="bbbbb"
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    
    
    
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
