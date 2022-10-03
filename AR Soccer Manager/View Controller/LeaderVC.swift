//
//  LeaderVC.swift
//  AR Soccer Manager
//
//  Created by Haonan Zhang on 2022-09-22.
//

import Foundation
import UIKit

class LeaderVC: UIViewController {
    @IBOutlet var tableView:UITableView!
//    @IBOutlet var name:UILabel!
//    @IBOutlet var score:UILabel!
    let names=[
    "Diamond","Haonan","Samuel"
    ]
    let scores=[243,3434,2132]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Homebcg.jpg")!)
        tableView.delegate=self
        tableView.dataSource=self
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

}

//class LeaderCell: UITableViewCell {
//    @IBOutlet var avatar : UIImageView?
//    @IBOutlet var name : UILabel?
//    @IBOutlet var score : UILabel?
//
//}
//class LeaderCell:UITableViewCell{
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
//    }
//}


extension LeaderVC:UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return names.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("cell tapped")
    }
    
}
extension LeaderVC:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return names.count
    }
    func tableView(_ tableView:UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
       // let cell = tableView.dequeueReusableCell(withIdentifier: "foodCellType", for: indexPath) as! LeaderCell
        let leaderCell=tableView.dequeueReusableCell(withIdentifier: "leaderCell", for: indexPath)
        leaderCell.textLabel?.text=names[indexPath.row]
        leaderCell.detailTextLabel?.text=String(scores[indexPath.row])
        //leaderCell.score?.text=names[indexPath.row]
        
        
        return leaderCell
        
    }
}
