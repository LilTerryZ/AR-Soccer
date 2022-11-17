//
//  LeaguesVC.swift
//  AR Soccer Manager
//
//  Created by Samuel Gerges on 2022-11-16.
//

import Foundation
import UIKit

class LeaguesVC: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Homebcg.jpg")!)
        
        let userDefault = UserRepository()
        
        let userId = userDefault.getInfo(itemID: "userId")
        print(String(decoding: userId!, as: UTF8.self))
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func PremierLeagueBtn(_ sender: Any) {
    }
    
    @IBAction func LaLigaBtn(_ sender: Any) {
    }
    
    @IBAction func LigueOneBtn(_ sender: Any) {
    }
    
    @IBAction func BundesligaBtn(_ sender: Any) {
    }
    
    
    @IBOutlet weak var StandingTableRef: UITableView!
}
