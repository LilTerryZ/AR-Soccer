//
//  PickerVC.swift
//  AR Soccer Manager
//
//  Created by Haonan Zhang on 2022-10-13.
//
import Foundation
import UIKit
import FirebaseCore
import FirebaseFirestore

//protocol DataRetrieval{
//     func didFetchData(data:[String])
//}


//class PickVC: UIViewController,DataRetrieval{
class PickVC: UIViewController{
    
    @IBOutlet weak var userClub:UIButton!
    @IBOutlet weak var oppoClub:UIButton!
  
    var allClubs=[String]()
    
    @IBOutlet weak var userClubSelected: UILabel!
    @IBOutlet weak var oppoClubSelected: UILabel!
    
    
    @IBOutlet weak var startBtn: UIButton!
    @IBAction func startBtn(sender: Any){

        let vc=storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        
        vc.txtUserClub=userClubSelected.text!
        vc.txtOppoClub=oppoClubSelected.text!
        
        vc.modalPresentationStyle = .fullScreen
        present(vc,animated: true,completion: nil)
    }


    
    func getClub(success:([String])){
        let db=Firestore.firestore()
            db.collection("clubs").whereField("league", isEqualTo: "Premier League").order(by: "name").getDocuments(){ (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        self.allClubs.append(document.data()["name"]! as! String)
                    }
                }
                print("Club",self.allClubs.count)
                self.createPicker()
            }
       }
    

    
    func createPicker(){
        let optionClosureUserClub = {(actionUserClub: UIAction) in
            self.userClubSelected.text=actionUserClub.title
            if (self.userClubSelected.text != "TBD" && self.oppoClubSelected.text != "TBD"){
                self.startBtn.isHidden=false}
            print(actionUserClub.title)
        }
        
        let optionClosureOppoClub = {(actionOppoClub: UIAction) in
            self.oppoClubSelected.text=actionOppoClub.title
            if (self.userClubSelected.text != "TBD" && self.oppoClubSelected.text != "TBD"){
                self.startBtn.isHidden=false}
            print(actionOppoClub.title)
            
        }
        
        var optionsArrUserClub = [UIAction]()
        var optionsArrOppoClub = [UIAction]()
        
        for club in allClubs{
            let actionUserClub = UIAction(title: club, state: .off, handler: optionClosureUserClub)
            optionsArrUserClub.append(actionUserClub)
            let actionOppoClub = UIAction(title: club, state: .off, handler: optionClosureOppoClub)
            optionsArrOppoClub.append(actionOppoClub)

            let optionsMenuUserClub = UIMenu(title: "", options: .displayInline, children: optionsArrUserClub)
            let optionsMenuOppoClub = UIMenu(title: "", options: .displayInline, children: optionsArrOppoClub)
            
            userClub.menu = optionsMenuUserClub
            oppoClub.menu = optionsMenuOppoClub
        }
    }
        

    override func loadView() {
        super.loadView()
        self.getClub(success: (allClubs))
        startBtn.isHidden=true
    }

  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Homebcg.jpg")!)
      
        if #available(iOS 15.0, *) {
            userClub.showsMenuAsPrimaryAction=true
            userClub.changesSelectionAsPrimaryAction=true
            oppoClub.showsMenuAsPrimaryAction=true
            oppoClub.changesSelectionAsPrimaryAction=true
        } else {
        }
        
        userClubSelected.text="TBD"
        oppoClubSelected.text="TBD"

        userClub.addAction(UIAction(title:"",handler:{(_) in
            print("default")}), for: .touchUpInside)
        oppoClub.addAction(UIAction(title:"",handler:{(_) in
            print("default")}), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    
}

