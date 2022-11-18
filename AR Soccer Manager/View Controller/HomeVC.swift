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
   
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var circleA: UIView!
    @IBOutlet weak var circleB: UIView!
    @IBOutlet weak var circleD: UIView!
    @IBOutlet weak var circleC: UIView!
    
    lazy var circles: [UIView] = [circleA, circleB, circleC, circleD]
    var circle = 0
    var colors: [UIColor] = [UIColor.systemPink, UIColor.systemYellow, UIColor.systemIndigo, UIColor.systemPurple ]
    lazy var random = Int.random(in: 0...colors.count-1)
    var loading = false
    
    lazy var blurry: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blurEffectView
    }()
    
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
    var imgURL=""
    
//    let vc = PickerVC(nibName: "PickerVC", bundle: nil)
//    let randomInt = Int.random(in: 1..<73)
    
    @IBAction func startBtn(sender: Any){
        
        self.loading = true
        self.loadingView()
        
        let vc=storyboard?.instantiateViewController(withIdentifier: "ARViewController") as! ARViewController
        vc.teamName = txtUserClub
        vc.oppName = txtOppoClub
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
        self.userClub?.text=txtUserClub
        self.oppositeClub?.text=txtOppoClub
        setupCirlces()
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
       
    func setupCirlces(){
        containerView.isUserInteractionEnabled = false
        circles.forEach{circle in
            circle.layer.cornerRadius = circle.frame.height / 2
            circle.backgroundColor = .clear
        }
    }
    
    func blurView(completion: @escaping (_ success: Bool) -> ()) {
        
            self.view.addSubview(blurry)
            self.view.bringSubviewToFront(blurry)
            self.view.bringSubviewToFront(containerView)
            
    }
    
    func nextCircle() {
        random = Int.random(in: 0...colors.count-1)
        if circle == circles.count-1{
            circle = 0
        } else {
            circle = circle + 1
        }
    }
    
    func circlesAnimation(){
        circles[circle].backgroundColor = colors[random].withAlphaComponent(0)
        
        UIView.animate(withDuration: 0.50){
            self.circles[self.circle].backgroundColor = self.colors[self.random].withAlphaComponent(0.70)
        } completion: { success in
            self.circles[self.circle].backgroundColor = self.colors[self.random].withAlphaComponent(0.70)
            self.nextCircle()
            if self.loading == true{
                self.circlesAnimation()
            }
        }
    }
    
    func loadingView(){
        if loading == true {
            blurView { success in
                self.circlesAnimation()
            }
        } else {
            if self.view.contains(blurry) {
                setupCirlces()
                blurry.removeFromSuperview()
            }
        }
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






