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
   
    
    @IBOutlet weak var vsImage: UIImageView!
    @IBOutlet weak var loadingText: UILabel?

    
    @IBOutlet weak var oppositeClub: UILabel?
    @IBOutlet weak var userClub: UILabel?
    @IBOutlet weak var oppositeName: UILabel!
    @IBOutlet weak var oppositeClubLogo: UIImageView?
    @IBOutlet weak var userName: UILabel?
    
    @IBOutlet weak var userClubLogo: UIImageView?
    //let vc = PickerVC()
    var clubImageData=[String: String]()
    var txtName=""
    var txtUserClub=""
    var txtOppoClub=""
    var txtLeagueName=""
    var imgURL=""
    
//    let vc = PickerVC(nibName: "PickerVC", bundle: nil)
//    let randomInt = Int.random(in: 1..<73)
    
    @IBAction func startBtn(sender: Any){
        let alert = UIAlertController(title: "Pre match", message: "Notice: Please have a clear area for scenes to appear. If next scene does not appear for the new event, tilt the device slightly down then up", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        runTask()
        }
    func runTask (){
        Task{
            self.vsImage.rotate()
            self.loadingText?.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                self.switchViews()
            }
        }
    }
    
    func switchViews() {
        let vc=storyboard?.instantiateViewController(withIdentifier: "ARViewController") as! ARViewController
        vc.teamName = txtUserClub
        vc.oppName = txtOppoClub
        vc.leagueName = txtLeagueName
        vc.modalPresentationStyle = .fullScreen
        present(vc,animated: true,completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Homebcg.jpg")!)
        //print(self.userClub)
//        self.userClub?.text=self.vc.txtClub
//        self.userName?.text=self.vc.txtName
//        vc.completionHandler={text in
//            self.userClub?.text=text
//        }
        self.userName?.isHidden=true
        self.oppositeName.isHidden=true
        self.userClub?.text=txtUserClub
        self.oppositeClub?.text=txtOppoClub
        vsImage.image = UIImage(named: "vs")
        loadingText?.isHidden = true
        loadingText?.text = "Match is now loading!"
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

            self.imgURL=self.clubImageData[self.txtOppoClub] ?? "Barcelona"
            self.loadOppoImg(logoURL: URL(string: imgURL)!)
            
            self.imgURL=self.clubImageData[self.txtUserClub] ?? "Barcelona"
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

extension UIImageView{
    func rotate() {
        print("ROTATING")
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 10
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
}

extension UIAlertController {
    func presentInOwnWindow(animated: Bool, completion: (() -> Void)?) {
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindow.Level.alert + 1;
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(self, animated: animated, completion: completion)
    }
}





