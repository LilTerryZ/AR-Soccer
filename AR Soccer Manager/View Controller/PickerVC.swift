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

protocol DataRetrieval{
     func didFetchData(data:[String])
}


class PickerVC: UIViewController,DataRetrieval{

    @IBOutlet weak var premier:UIButton!
    @IBOutlet weak var ligue:UIButton!
    @IBOutlet weak var liga:UIButton!
    @IBOutlet weak var bundesliga:UIButton!
    
    @IBOutlet weak var selectPremier: UIButton!
    @IBOutlet weak var selectLiga: UIButton!
    @IBOutlet weak var selectLigue: UIButton!
    @IBOutlet weak var selectBundesliga: UIButton!
    //@Published var clubList=[Club]()
    //    var clubPickerData: [String] = [String]()
    //var clubData: [String] = [String]()
    var clubDataPremier=[String]()
    var clubDataLigue=[String]()
    var clubDataLiga=[String]()
    var clubDataBundesliga=[String]()
    
    //let vc = HomeVC(nibName: "HomeVC", bundle: nil)
    //let vc = HomeVC()

    var completionHandler:((String)->Void)?
    
    @IBOutlet weak var clubSelected: UILabel!
    @IBOutlet weak var leagueSelected: UILabel!
    
    
    @IBOutlet weak var startBtn: UIButton!
    
    @IBAction func startBtn(sender: Any){
      //  print("\(clubSelected.text) &&&&&&&&&&&&&&")
        //completionHandler?(txtClub)
        //completionHandler?(clubSelected.text)
        let vc=storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        vc.txtUserClub=clubSelected.text!
        vc.modalPresentationStyle = .fullScreen
        present(vc,animated: true,completion: nil)
    }

    @IBAction func selectPremier( sender: UIButton )
    {
        premier.isHidden=false
        liga.isHidden = true
        ligue.isHidden = true
        bundesliga.isHidden = true
        if (clubSelected.text == "TBD"){
            startBtn.isHidden=true}else{
                startBtn.isHidden=false
            }
    }

    @IBAction func selectLiga( sender: UIButton )
    {
        liga.isHidden=false
        premier.isHidden = true
        ligue.isHidden = true
        bundesliga.isHidden = true
    }
    
    @IBAction func selectLigue( sender: UIButton )
    {
        ligue.isHidden=false
        premier.isHidden = true
        liga.isHidden = true
        bundesliga.isHidden = true
    }
    
    @IBAction func selectBundesliga( sender: UIButton )
    {
        bundesliga.isHidden=false
        liga.isHidden = true
        ligue.isHidden = true
        premier.isHidden = true
    }
    
//    @IBAction func premier(sender: UIButton){
//        let saveAction = { (action: UIAction) in
//            print(action.title)
//        }
//    }
//    @IBAction func liga(sender:UIButton){
//
//    }
//    @IBAction func ligue(sender:UIButton){
//
//    }
//    @IBAction func bundesliga(sender:UIButton){
//
//    }

    
    func getDataLiga(success:([String])){
        let db=Firestore.firestore()
            db.collection("clubs").whereField("league", isEqualTo: "La Liga").order(by: "name").getDocuments(){ (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    
                } else {
                    for document in querySnapshot!.documents {
                        self.clubDataLiga.append(document.data()["name"]! as! String)
                    }
                }
                print("Liga",self.clubDataLiga.count)
              //  print(self.clubDataLiga)
                self.didFetchData(data: self.clubDataLiga)
            }
       }
    
    func getDataPremier(success:([String])){
        let db=Firestore.firestore()
        db.collection("clubs").whereField("league", isEqualTo: "Premier League").order(by: "name").getDocuments(){ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.clubDataPremier.append(document.data()["name"]! as! String)
                }
            }
            print("premier",self.clubDataPremier.count)
           // print(self.clubDataPremier)
            self.didFetchData(data: self.clubDataPremier)
        }
    
    }
    
    func getDataLigue(success:([String])){
        let db=Firestore.firestore()
        db.collection("clubs").whereField("league", isEqualTo: "Ligue 1").order(by: "name").getDocuments(){ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.clubDataLigue.append(document.data()["name"]! as! String)
                }
            }
            print("Ligue",self.clubDataLigue.count)
           // print(self.clubDataLigue)
            self.didFetchData(data: self.clubDataLigue)
        }
    }
    func getDataBundesliga(success:([String])){
        let db=Firestore.firestore()
        db.collection("clubs").whereField("league", isEqualTo: "Bundesliga").order(by: "name").getDocuments(){ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    // print("\(document.documentID) => \(document.data())")
                    // print(document.data()["name"]!)
                    self.clubDataBundesliga.append(document.data()["name"]! as! String)
                }
            }
            print("Bundesliga",self.clubDataBundesliga.count)
           // print(self.clubDataBundesliga)
            self.didFetchData(data: self.clubDataBundesliga)
        }
    }
    
    func createPicker(league:String){
        let optionClosurePremier = {(actionPremier: UIAction) in
            self.clubSelected.text=actionPremier.title
            self.leagueSelected.text="Premier League"
            if (self.clubSelected.text != "TBD"){
                self.startBtn.isHidden=false}
            print(actionPremier.title)
            
//            self.txtClub = actionPremier.title
//
//            let vc=self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
//            vc.txtClub=self.clubSelected.text!
           // self.completionHandler?(self.txtClub)
        }
        let optionClosureLiga = {(actionLiga: UIAction) in
            self.clubSelected.text=actionLiga.title
            self.leagueSelected.text="La Liga"
            if (self.clubSelected.text != "TBD"){
                self.startBtn.isHidden=false}
            print(actionLiga.title)
//            self.txtClub = actionLiga.title
        }
        let optionClosureLigue = {(actionLigue: UIAction) in
            self.clubSelected.text=actionLigue.title
            self.leagueSelected.text="Ligue 1"
            if (self.clubSelected.text != "TBD"){
                self.startBtn.isHidden=false}
            print(actionLigue.title)
           // self.vc.txtClub = actionLigue.title
        }
        let optionClosureBundesliga = {(actionBundesliga: UIAction) in
            self.clubSelected.text=actionBundesliga.title
            self.leagueSelected.text="Bundesliga"
            if (self.clubSelected.text != "TBD"){
                self.startBtn.isHidden=false}
            print(actionBundesliga.title)
            //self.vc.txtClub = actionBundesliga.title
        }
        
        var optionsArrPremier = [UIAction]()
        var optionsArrLiga = [UIAction]()
        var optionsArrLigue = [UIAction]()
        var optionsArrBundesliga = [UIAction]()
        
        if (league=="premier"){
            for club in clubDataPremier{
                let actionPremier = UIAction(title: club, state: .off, handler: optionClosurePremier)
                optionsArrPremier.append(actionPremier)
            }
            let optionsMenuPremier = UIMenu(title: "", options: .displayInline, children: optionsArrPremier)
            //optionsArrPremier[0].state = .on
          //  print( "optionsMenuPremier",optionsMenuPremier)
            premier.menu = optionsMenuPremier
            
        }
        if (league=="liga"){
            for club in clubDataLiga{
                let actionLiga = UIAction(title: club, state: .off, handler: optionClosureLiga)
                optionsArrLiga.append(actionLiga)
            }
            let optionsMenuLiga = UIMenu(title: "", options: .displayInline, children: optionsArrLiga)
           //optionsArrLiga[0].state = .on
//            print("menu",optionsMenuLiga)
//            print("Arr",optionsArrLiga)
            liga.menu = optionsMenuLiga
        }
        if (league=="ligue"){
            for club in clubDataLigue{
                let actionLigue = UIAction(title: club, state: .off, handler: optionClosureLigue)
                optionsArrLigue.append(actionLigue)
            }
            let optionsMenuLigue = UIMenu(title: "", options: .displayInline, children: optionsArrLigue)
            //optionsArrLigue[0].state = .on
            ligue.menu = optionsMenuLigue
        }
        if (league=="bundesliga"){
            for club in clubDataBundesliga{
                let actionBundesliga = UIAction(title: club, state: .off, handler: optionClosureBundesliga)
                optionsArrBundesliga.append(actionBundesliga)
            }
            let optionsMenuBundesliga = UIMenu(title: "", options: .displayInline, children: optionsArrBundesliga)
           // optionsArrBundesliga[0].state = .on
            bundesliga.menu = optionsMenuBundesliga
        }

    }
    
    
        func didFetchData(data:[String]){
            //print("working")
            if(data==self.clubDataPremier){createPicker(league: "premier")}
            if(data==self.clubDataLiga){createPicker(league: "liga")}
            if(data==self.clubDataLigue){createPicker(league: "ligue")}
            if(data==self.clubDataBundesliga){createPicker(league: "bundesliga")}
            
            
        }
    
    
    
    override func loadView() {
        super.loadView()
        self.getDataPremier(success: (clubDataPremier))
        self.getDataLigue(success: (clubDataLigue))
        self.getDataLiga(success: (clubDataLiga))
        self.getDataBundesliga(success: (clubDataBundesliga))
        
        premier.isHidden=true
        liga.isHidden = true
        ligue.isHidden = true
        bundesliga.isHidden = true
        startBtn.isHidden=true
    }

  
    
    override func viewDidLoad() {
        super.viewDidLoad()
     //   let db=Firestore.firestore()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Homebcg.jpg")!)
        if #available(iOS 15.0, *) {
            premier.showsMenuAsPrimaryAction=true
            premier.changesSelectionAsPrimaryAction=true
            ligue.showsMenuAsPrimaryAction=true
            ligue.changesSelectionAsPrimaryAction=true
            liga.showsMenuAsPrimaryAction=true
            liga.changesSelectionAsPrimaryAction=true
            bundesliga.showsMenuAsPrimaryAction=true
            bundesliga.changesSelectionAsPrimaryAction=true
        } else {
            // Fallback on earlier versions
        }
        clubSelected.text="TBD"
        leagueSelected.text="TBD"
//        selectPremier.addAction(UIAction(title:"",handler:{(_) in print("default")}), for: .touchUpInside)
//        selectLiga.addAction(UIAction(title:"",handler:{(_) in print("default")}), for: .touchUpInside)
//        selectLigue.addAction(UIAction(title:"",handler:{(_) in print("default")}), for: .touchUpInside)
//        selectBundesliga.addAction(UIAction(title:"",handler:{(_) in print("default")}), for: .touchUpInside)
       
        premier.addAction(UIAction(title:"",handler:{(_) in
            print("default")}), for: .touchUpInside)
        liga.addAction(UIAction(title:"",handler:{(_) in
            print("default")}), for: .touchUpInside)
        ligue.addAction(UIAction(title:"",handler:{(_) in
            print("default")}), for: .touchUpInside)
        bundesliga.addAction(UIAction(title:"",handler:{(_) in print("default")}), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }

//    func getData() {
//        let db = Firestore.firestore()
//        db.collection("clubs").getDocuments { snapshot, error in
//            if error == nil {
//                // No errors
//                if let snapshot = snapshot {
//
//                    // Update the list property in the main thread
//                    DispatchQueue.main.async {
//
//                        // Get all the documents and create Todos
//                        self.clubList = snapshot.documents.map { d in
//
//                            // Create a Club item for each document returned
//                            return Club(id: d.documentID,
//                                        league:d["league"] as? String ?? "",
//                                        logo: d["logo"] as? String ?? "",
//                                        name: d["name"] as? String ?? "")
//                        }
//                       // print(self.clubList["name"])
//                        self.length=(self.clubList).count
//                    }
//                }
//
//            }
//            else {
//                // Handle the error
//            }
//        }
//    }
//
    
}


//extension PickerVC:UIPickerViewDataSource,UIPickerViewDelegate{
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        //return (self.clubList).count
////        self.getData()
////        print("out")
////        print(clubList.count)
//
//        return clubData.count
//    }
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        //print("text")
////        self.getData()
//         //return clubData[row]
//          return "l"
//    }
//}




