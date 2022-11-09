//
//  ViewController.swift
//  AR Test 2
//
//  Created by Diamond Winter-Hogan on 2022-08-27.
//

import UIKit
import RealityKit

class ARViewController: UIViewController {
    
    @IBOutlet var homeScore: UILabel!
    @IBOutlet weak var awayScore: UILabel!
    @IBOutlet var eventL: UILabel!
    
    @IBOutlet var arView: ARView!
    var gameTimer: Timer?
    var anchorStatus = false
    
    var timer:Timer = Timer()
    var count:Double = 0.0
    var timerCounting:Bool = false
    
    var sceneTime: Double = 0.0
    
    var hScore: Int = 0
    var aScore: Int = 0

        
   @IBOutlet weak var resultBtn: UIButton!
    
    @IBAction func resultBtn(sender: Any){
        let vc=storyboard?.instantiateViewController(withIdentifier: "ResultVC") as! ResultVC
//        vc.txtUserClub=clubSelected.text!
        
        
        
        
        
        vc.modalPresentationStyle = .fullScreen
        present(vc,animated: true,completion: nil)
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
       // resultBtn.isHidden=true
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Homebcg.jpg")!)
        
        // Load the "Box" scene from the "Experience" Reality File
        //let boxAnchor = try! Experience.loadBox()
        
        let tackleAnchor = try! Experience.loadTackle()
        let tackleAnchor2 = try! Experience.loadTackleAway()
        
        let goalAnchor = try! Experience.loadGoalkeeperScore()
        let goalAnchor2 = try! Experience.loadGoalkeeperScoreAway()
        
        let saveAnchor = try! Experience.loadGoalkeeperSave()
        let saveAnchor2 = try! Experience.loadGoalkeeperSaveAway()
        
        let passIAnchor = try! Experience.loadPassIncomplete()
        let passIAnchor2 = try! Experience.loadPassIncompleteAway()
        
        let passAnchor = try! Experience.loadPassComplete()
        
        let dribbleAnchor = try! Experience.loadDribble()
        
        let koAnchor = try! Experience.loadKickoff()
        setPlayerColours()
        
        self.homeScore?.text = "Home: \(hScore)"
        self.awayScore?.text = "Away: \(aScore)"
        
        runSimulation()

        func runSimulation() {
            let simulation = Simulation()
            
            Task{
                let result = await simulation.runSimulation(homeTeamName: "Liverpool", awayTeamName: "Manchester City")
                
                print(result["events"]!)
                
                let events = result["events"]
                
                for event in events as! [String] {
                    if event == "HA" {
                        arView.scene.anchors.append(dribbleAnchor)
                        eventChange(text: "Home team trying to make some moves!")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 6.57) {
                            print("Removing")
                            self.arView.scene.anchors.removeAll()
                            self.arView.scene.removeAnchor(dribbleAnchor)
                        }
                        try await Task.sleep(nanoseconds: 7000000000)
                    } else if event == "AT" {
                        arView.scene.anchors.append(passAnchor)
                        eventChange(text: "The away team presses the attack!")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 6.57) {
                            print("Removing")
                            self.arView.scene.anchors.removeAll()
                            self.arView.scene.removeAnchor(passAnchor)
                        }
                        try await Task.sleep(nanoseconds: 7000000000)
                    } else if event == "HDC" {
                        arView.scene.anchors.append(tackleAnchor)
                        eventChange(text: "An excellent steal by the home team!")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5.4) {
                            print("Removing")
                            self.arView.scene.anchors.removeAll()
                            self.arView.scene.removeAnchor(tackleAnchor)
                        }
                        try await Task.sleep(nanoseconds: 6000000000)
                    } else if event == "ADC" {
                        arView.scene.anchors.append(tackleAnchor2)
                        eventChange(text: "An amazing tackle from the away team!")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5.4) {
                            print("Removing")
                            self.arView.scene.anchors.removeAll()
                            self.arView.scene.removeAnchor(tackleAnchor2)
                        }
                        try await Task.sleep(nanoseconds: 6000000000)
                    } else if event == "HMC" {
                        arView.scene.anchors.append(passIAnchor)
                        eventChange(text: "The away team has stolen possesion from home!")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.71) {
                            print("Removing")
                            self.arView.scene.anchors.removeAll()
                            self.arView.scene.removeAnchor(passIAnchor)
                        }
                        try await Task.sleep(nanoseconds: 4000000000)
                    } else if event == "AMC" {
                        arView.scene.anchors.append(passIAnchor2)
                        eventChange(text: "Home team intercepts the away teams pass!")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.71) {
                            print("Removing")
                            self.arView.scene.anchors.removeAll()
                            self.arView.scene.removeAnchor(passIAnchor)
                        }
                        try await Task.sleep(nanoseconds: 4000000000)
                    } else if event == "HS" {
                        homeScore()
                        arView.scene.anchors.append(goalAnchor)
                        eventChange(text: "The home team has scored!")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 6.2) {
                            print("Removing")
                            self.arView.scene.anchors.removeAll()
                            self.arView.scene.removeAnchor(goalAnchor)
                        }
                        try await Task.sleep(nanoseconds: 7000000000)
                    } else if event == "AS" {
                        awayScore()
                        arView.scene.anchors.append(goalAnchor2)
                        eventChange(text: "Away team has scored!")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 6.2) {
                            print("Removing")
                            self.arView.scene.anchors.removeAll()
                            self.arView.scene.removeAnchor(goalAnchor2)
                        }
                        try await Task.sleep(nanoseconds: 7000000000)
                    } else if event == "HGKS" {
                        arView.scene.anchors.append(saveAnchor)
                        eventChange(text: "The home team has blocked the away teams shot!")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                            print("Removing")
                            self.arView.scene.anchors.removeAll()
                            self.arView.scene.removeAnchor(saveAnchor)
                        }
                        try await Task.sleep(nanoseconds: 7000000000)
                    } else if event == "AGKS" {
                        arView.scene.anchors.append(saveAnchor2)
                        eventChange(text: "The away team has blocked the shot!")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                            print("Removing")
                            self.arView.scene.anchors.removeAll()
                            self.arView.scene.removeAnchor(saveAnchor2)
                        }
                        try await Task.sleep(nanoseconds: 7000000000)
                        
                    } else if event == "HT" {
                        arView.scene.anchors.append(koAnchor)
                        eventChange(text: "HALF TIME")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 7.2) {
                            print("Removing")
                            self.arView.scene.anchors.removeAll()
                            self.arView.scene.removeAnchor(koAnchor)
                        }
                        try await Task.sleep(nanoseconds: 8000000000)
                        
                    } else if event == "FT" {
                        arView.scene.anchors.append(koAnchor)
                        eventChange(text: "MATCH DONE")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 7.2) {
                            print("Removing")
                            self.arView.scene.anchors.removeAll()
                            self.arView.scene.removeAnchor(koAnchor)
                        }
                        try await Task.sleep(nanoseconds: 8000000000)
                        
                    } else if event == "KF"  {
                        arView.scene.anchors.append(koAnchor)
                        eventChange(text: "Kickoff")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 7.2) {
                            print("Removing")
                            self.arView.scene.anchors.removeAll()
                            self.arView.scene.removeAnchor(koAnchor)
                        }
                        try await Task.sleep(nanoseconds: 8000000000)
                    }
                }
                resultBtn.isHidden=false
            }
            
        }
        
        func awayScore(){
            let animation:CATransition = CATransition()
            
            animation.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
            
            animation.type = CATransitionType.push //1.
            
            self.aScore = aScore + 1
            self.awayScore?.text = "Away: \(aScore)"
            
            animation.duration = 0.25
            self.awayScore.layer.add(animation, forKey: CATransitionType.push.rawValue)//2.
        }
        
        func homeScore(){
            let animation:CATransition = CATransition()
            
            animation.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
            
            animation.type = CATransitionType.push //1.
            
            self.hScore = hScore + 1
            self.homeScore?.text = "Home: \(hScore)"
            
            animation.duration = 0.25
            self.homeScore.layer.add(animation, forKey: CATransitionType.push.rawValue)//2.
        }
        
        func eventChange(text: String){
            let animation:CATransition = CATransition()
            animation.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
            animation.type = CATransitionType.fade
            animation.subtype = CATransitionSubtype.fromTop
            self.eventL.text = text
            animation.duration = 0.25
            self.eventL.layer.add(animation, forKey: CATransitionType.fade.rawValue)
        }
        
        func setPlayerColours(){
            let red = SimpleMaterial(color: .red, isMetallic: false)
            let blue = SimpleMaterial(color: .blue, isMetallic: false)
            //Kickoff
            //Pass and Receiver
            let passer = koAnchor.homePass?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
            
            let receiver = koAnchor.homeRec?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
            
            passer.model?.materials = [red]
            receiver.model?.materials = [red]
            
            let homeI1 = koAnchor.homeIdle1?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
            
            let homeI2 = koAnchor.homeIdle2?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
            
            let homeI3 = koAnchor.homeIdle3?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
            
            homeI1.model?.materials = [red]
            homeI2.model?.materials = [red]
            homeI3.model?.materials = [red]
            
            let awayI1 = koAnchor.awayIdle1?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
            
            let awayI2 = koAnchor.awayIdle2?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
            
            let awayI3 = koAnchor.awayIdle3?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
            
            let awayI4 = koAnchor.awayIdle4?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
            
            let awayI5 = koAnchor.awayIdle5?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
            
            awayI1.model?.materials = [blue]
            awayI2.model?.materials = [blue]
            awayI3.model?.materials = [blue]
            awayI4.model?.materials = [blue]
            awayI5.model?.materials = [blue]
            
            //Dribble
            let drib1 = dribbleAnchor.drib1?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
            
            let drib2 = dribbleAnchor.drib2?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
            
            let drib3 = dribbleAnchor.drib3?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
            
            let drib4 = dribbleAnchor.drib4?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
            drib1.model?.materials = [red]
            drib2.model?.materials = [red]
            drib3.model?.materials = [red]
            drib4.model?.materials = [red]
            
            //Home Tackle
            let TD1 = tackleAnchor.tH1?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
            
            let TD2 = tackleAnchor.tH2?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
            
            let TD3 = tackleAnchor.tH3?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
            
            let TD4 = tackleAnchor.tH4?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
           
            let TD5 = tackleAnchor.tH5?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
            
            let TA6 = tackleAnchor.tH6?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
            
            TD1.model?.materials = [blue]
            TD2.model?.materials = [blue]
            TD3.model?.materials = [blue]
            TD4.model?.materials = [blue]
            TD5.model?.materials = [blue]
            TA6.model?.materials = [red]
            
            //Away tackle
            let TA1 = tackleAnchor2.tA1?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
            
            let TA2 = tackleAnchor2.tA2?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
            
            let TA3 = tackleAnchor2.tA3?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
            
            let TA4 = tackleAnchor2.tA4?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
           
            let TA5 = tackleAnchor2.tA5?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
            
            let TD6 = tackleAnchor2.tH6?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
            
            TA1.model?.materials = [red]
            TA2.model?.materials = [red]
            TA3.model?.materials = [red]
            TA4.model?.materials = [red]
            TA5.model?.materials = [red]
            TD6.model?.materials = [blue]
            
            //Home Goal
            let gh1 = goalAnchor.gh1?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
            
            let ga1 = goalAnchor.ga1?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
            
            let ga2 = goalAnchor.ga2?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
            
            gh1.model?.materials = [red]
            ga1.model?.materials = [blue]
            ga2.model?.materials = [blue]
            
            //Away goal
            let ag1 = goalAnchor2.ag1?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
            
            let hg1 = goalAnchor2.hg1?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
            
            let hg2 = goalAnchor2.hg2?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
            
            ag1.model?.materials = [blue]
            hg1.model?.materials = [red]
            hg2.model?.materials = [red]
            
            //Home save
            let gka1 = saveAnchor.gka1?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
            
            let gkh1 = saveAnchor.gkh1?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
            
            let gkh2 = saveAnchor.gkh2?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
            
            let gkh3 = saveAnchor.gkh3?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
            
            gkh1.model?.materials = [red]
            gkh2.model?.materials = [red]
            gkh3.model?.materials = [red]
            gka1.model?.materials = [blue]
            
            //Away save
            let gkh4 = saveAnchor2.gkh4?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
            
            let gka2 = saveAnchor2.gka2?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
            
            let gka3 = saveAnchor2.gka3?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
            
            let gka4 = saveAnchor2.gka4?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
            
            gkh4.model?.materials = [red]
            gka2.model?.materials = [blue]
            gka3.model?.materials = [blue]
            gka4.model?.materials = [blue]
            
            //Pass complete
            let ph1 = passAnchor.ph1?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
            
            let pa1 = passAnchor.pa1?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
            
            let pa2 = passAnchor.pa2?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
            
            let pa3 = passAnchor.pa3?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
            
            ph1.model?.materials = [red]
            pa1.model?.materials = [blue]
            pa2.model?.materials = [blue]
            pa3.model?.materials = [blue]
            
            //Pass incomplete home
            let pih1 = passIAnchor.pih1?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
            
            let pih2 = passIAnchor.pih2?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
            
            let pih3 = passIAnchor.pih3?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
            
            let pia1 = passIAnchor.pia1?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
            
            let pia2 = passIAnchor.pia2?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
            
            pih1.model?.materials = [red]
            pih2.model?.materials = [red]
            pih3.model?.materials = [red]
            pia1.model?.materials = [blue]
            pia2.model?.materials = [blue]
            
            //Pass incomplete away
            let pia3 = passIAnchor2.pia3?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
            
            let pia4 = passIAnchor2.pia4?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
            
            let pia5 = passIAnchor2.pia5?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
            
            let pih4 = passIAnchor2.pih4?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
            
            let pih5 = passIAnchor2.pih5?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
            
            pia3.model?.materials = [blue]
            pia4.model?.materials = [blue]
            pia5.model?.materials = [blue]
            pih4.model?.materials = [red]
            pih5.model?.materials = [red]
        }
            
    }
}

