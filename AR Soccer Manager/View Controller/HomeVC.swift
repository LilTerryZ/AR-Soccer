//
//  HomeVC.swift
//  AR Soccer Manager
//
//  Created by Haonan Zhang on 2022-09-14.
//

import Foundation
import UIKit
import FirebaseCore
import FirebaseFirestore


//HomeVC = (UIStoryboard(name: "Main",bundle: nil).instantiateViewControllerWithIdentifier("WWPhotoSlideShowVC") as! WWPhotoSlideShowVC)

class HomeVC: UIViewController{
   
    
    @IBOutlet weak var oppositeClub: UILabel?
    @IBOutlet weak var userClub: UILabel?
    @IBOutlet weak var oppositeName: UILabel!
    @IBOutlet weak var oppositeClubLogo: UIImageView?
    @IBOutlet weak var userName: UILabel?
    @IBOutlet weak var userClubLogo: UIImageView?
    //let vc = PickerVC()
    var clubImageData=[String: String]()
    var txtName=""
    var txtClub=""
    var imgURL=""
    let vc = PickerVC(nibName: "PickerVC", bundle: nil)
    let randomInt = Int.random(in: 1..<73)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Homebcg.jpg")!)
        //print(self.userClub)
//        self.userClub?.text=self.vc.txtClub
//        self.userName?.text=self.vc.txtName
//        vc.completionHandler={text in
//            self.userClub?.text=text
//        }
        self.userClub?.text=txtClub
       
    
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        self.getData(success: (clubImageData))
       
        //print("=========\(txtClub) ==============")
//        self.userTeam()
       // self.userName.text=self.txtName
        //userClubLogo?.image=UIImage(named: self.clubImageData[0])
    //    print("\(self.clubImageData[0])IMAGE--------")
   
    }
    override func viewDidAppear(_ animated: Bool) {
        self.getData(success: (clubImageData))
    }
       
    

    func getData(success:([String: String])){
        let db=Firestore.firestore()
        db.collection("clubs").order(by: "name").getDocuments(){ [self] (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    
                } else {
                    for document in querySnapshot!.documents {
                        self.clubImageData.updateValue("\(document.data()["logo"]!)", forKey: "\(document.data()["name"]!)")
//                        self.clubImageData.append(document.data()["logo"]! as! String)
                    }
                }
                print("logo",self.clubImageData.count)
                print(self.clubImageData)
//                self.didFetchData(data: self.clubImageData)
            self.oppositeClub?.text="Liverpool"
            self.imgURL=self.clubImageData["Liverpool"] ?? "Barcelona"
            self.loadOppoImg(logoURL: URL(string: imgURL)!)
            
            self.imgURL=self.clubImageData[self.txtClub] ?? "Barcelona"
            self.loadUserImg(logoURL: URL(string: imgURL)!)
//            self.userClubLogo?.frame = CGRect(x: 0, y: 0, width: 96, height: 96)
//            var im=UIImageView(frame: CGRectMake(x:0, y:0, self.view.frame.size.width*0.2,50))
            }
       }
//    func didFetchData(data:[String:String]){
//        if(data==self.clubImageData){createPicker()}
//    }
//
//    func createPicker(){
//        let optionClosure = {(action: UIAction) in
//            self.imgURL=self.clubImageData[self.txtClub]!
//            print("%%%%%%%%%%%")
//            print(action.title)
//        }
//
//        var optionsDic = [UIAction:UIAction]()
//
////        for club in clubImageData{
////            let action = UIAction(title: club, state: .off, handler: optionClosure)
////            optionsDic.updateValue(action, forKey: 1)()
////        }
//    }
//
    func loadUserImg(logoURL: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: logoURL) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.userClubLogo?.image = image
                    }
                }
            }
        }
    }
    func loadOppoImg(logoURL: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: logoURL) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.oppositeClubLogo?.image = image
                    }
                }
            }
        }
    }

    
    
    
}






