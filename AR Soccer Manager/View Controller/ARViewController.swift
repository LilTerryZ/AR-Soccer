//
//  ARViewController.swift
//  AR Simulation
//
//  Created by Diamond Winter-Hogan on 2022-08-27.
//

import UIKit
import RealityKit
import ARKit

class ARViewController: UIViewController {
    
    @IBOutlet var homeScore: UILabel!
    @IBOutlet var awayScore: UILabel!
    @IBOutlet var eventL: UILabel!
    
    @IBOutlet var arView: ARView!
    
    let configuration = ARWorldTrackingConfiguration()
    
    func runConfig() {(
     configuration: ARConfiguration.self,
     options: [ARSession.RunOptions.resetTracking, ARSession.RunOptions.removeExistingAnchors]
    )}
    
    var hScore: Int = 0
    var aScore: Int = 0
    
    var teamName = ""
    var oppName = ""
    
    var oppPoss = 0.0
    var teamPoss = 0.0
    
    var oppPasses = 0
    var teamPasses = 0
    
    var oppShots = 0
    var teamShots = 0
    
    var totalPoss = 0.0
    
    var simHS = 0
    var simAS = 0
    
    var eventsList = ["events"]
    
    var gameStatus = true

        
   @IBOutlet weak var resultBtn: UIButton!
    @IBOutlet weak var skipBtn: UIButton!
    
    @IBAction func resultBtn(sender: Any){
        let vc=storyboard?.instantiateViewController(withIdentifier: "ResultVC") as! ResultVC
        vc.txtUserScore=String(simHS)
        vc.txtOppositeScore=String(simAS)
        vc.txtUserClub=teamName
        vc.txtOppositeClub=oppName
        vc.txtOppositePose=String(oppPoss)
        vc.txtUserPose=String(teamPoss)
        vc.txtUserShots=String(teamShots)
        vc.txtOppositeShots=String(oppShots)
        vc.txtOppositePassses=String(oppPasses)
        vc.txtUserPasses=String(teamPasses)
        vc.events = eventsList
        
        
        vc.modalPresentationStyle = .fullScreen
        present(vc,animated: true,completion: nil)
    }
    
    @IBAction func skipBtn(sender: Any){
        self.gameStatus = false
        let vc=storyboard?.instantiateViewController(withIdentifier: "ResultVC") as! ResultVC
        vc.txtUserScore=String(simHS)
        vc.txtOppositeScore=String(simAS)
        vc.txtUserClub=teamName
        vc.txtOppositeClub=oppName
        vc.txtOppositePose=String(oppPoss)
        vc.txtUserPose=String(teamPoss)
        vc.txtUserShots=String(teamShots)
        vc.txtOppositeShots=String(oppShots)
        vc.txtOppositePassses=String(oppPasses)
        vc.txtUserPasses=String(teamPasses)
        vc.events = eventsList
        
        vc.modalPresentationStyle = .fullScreen
        present(vc,animated: true,completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultBtn.isHidden=true
        skipBtn.isHidden=true
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Homebcg.jpg")!)
        
        // Load the "Box" scene from the "Experience" Reality File
        //let boxAnchor = try! Experience.loadBox()
        
        eventL.text = "Players getting into position!"
        
        setPlayerColours()
        
        self.homeScore?.text = "\(self.teamName): \(hScore)"
        self.awayScore?.text = "\(self.oppName): \(aScore)"
        
        runSimulation()

        func runSimulation() {
            let simulation = Simulation()
            
           Task{
                let result = await simulation.runSimulation(homeTeamName: teamName, awayTeamName: oppName)
                
                let events = result["events"]
                
                for event in events as! [String]{
                    if event == "HA" {
                        eventsList.append("\(teamName) is trying to make some moves!")
                        teamPasses = teamPasses+1
                        teamPoss = teamPoss + 1
                        totalPoss = totalPoss+1
                    } else if event == "AT" {
                        eventsList.append("\(oppName) presses the attack!")
                        oppPasses = oppPasses+1
                        oppPoss = oppPoss+1
                        totalPoss = totalPoss+1
                    } else if event == "HDC" {
                        eventsList.append("An excellent steal by \(teamName)")
                        teamPoss = teamPoss + 1
                        totalPoss = totalPoss+1
                    } else if event == "ADC" {
                        eventsList.append("An amazing tackle from \(oppName)")
                        oppPoss = oppPoss+1
                        totalPoss = totalPoss+1
                    } else if event == "HMC" {
                        eventsList.append("\(teamName) has stolen possesion from \(oppName)!")
                        oppPoss = oppPoss+1
                        totalPoss = totalPoss+1
                    } else if event == "AMC" {
                        eventsList.append("\(oppName) intercepts \(teamName)'s pass!")
                        teamPoss = teamPoss + 1
                        totalPoss = totalPoss+1
                    } else if event == "HS" {
                        teamShots = teamShots+1
                        teamPoss = teamPoss + 1
                        totalPoss = totalPoss+1
                        simHS = simHS+1
                        eventsList.append("\(teamName) has scored!")
                    } else if event == "AS" {
                        oppShots = oppShots+1
                        oppPoss = oppPoss+1
                        totalPoss = totalPoss+1
                        simAS = simAS+1
                        eventsList.append("\(oppName) has scored!")
                    } else if event == "HGKS" {
                        eventsList.append("\(teamName) has blocked \(oppName)'s shot!")
                        oppShots = oppShots+1
                        oppPoss = oppPoss+1
                        totalPoss = totalPoss+1
                    } else if event == "AGKS" {
                        eventsList.append("\(oppName) has blocked \(teamName)'s shot!")
                        teamShots = teamShots+1
                        teamPoss = teamPoss + 1
                        totalPoss = totalPoss+1
                    } else if event == "HT" {
                        eventsList.append("HALFTIME!")
                    } else if event == "FT" {
                        eventsList.append("FULLTIME!")
                    } else if event == "KF"  {
                        eventsList.append("KICKOFF!")
                    }
                }
                
                teamPoss = (teamPoss/totalPoss) * 100.0
                teamPoss = round(teamPoss * 10) / 10.0
                
                oppPoss = (oppPoss/totalPoss) * 100.0
                oppPoss = round(oppPoss * 10) / 10.0
                
                print("STATS DONE")
                print(totalPoss)
                print(teamPoss)
                print(oppPoss)
                print(simAS)
                print(simHS)
                print(teamShots)
                print(oppShots)
                print(teamPasses)
                print(oppPasses)
                skipBtn.isHidden=false
                
               let red = SimpleMaterial(color: .red, isMetallic: false)
               let blue = SimpleMaterial(color: .blue, isMetallic: false)
               
                    for event in events as! [String] {
                        if event == "HA" {
                            let dribbleAnchor = try! Experience.loadDribble()
                            let hgk2 = dribbleAnchor.homeGK2?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            let agk2 = dribbleAnchor.awayGK2?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            let drib1 = dribbleAnchor.drib1?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            let drib2 = dribbleAnchor.drib2?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            let drib3 = dribbleAnchor.drib3?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            let drib4 = dribbleAnchor.drib4?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            let drib5 = dribbleAnchor.drib5?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            let drib6 = dribbleAnchor.drib6?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            let drib7 = dribbleAnchor.drib7?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            let drib8 = dribbleAnchor.drib8?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            drib1.model?.materials = [red]
                            drib2.model?.materials = [red]
                            drib3.model?.materials = [red]
                            drib4.model?.materials = [red]
                            drib5.model?.materials = [red]
                            drib6.model?.materials = [red]
                            drib7.model?.materials = [red]
                            drib8.model?.materials = [red]
                            hgk2.model?.materials = [blue]
                            agk2.model?.materials = [red]
                            arView.scene.anchors.append(dribbleAnchor)
                            eventChange(text: "\(teamName) is trying to make some moves!")
                            DispatchQueue.main.asyncAfter(deadline: .now() + 6.57) {
                                print("Removing")
                                self.arView.scene.anchors.removeAll()
                                //self.arView.scene.removeAnchor(dribbleAnchor)
                                //self.arView.session.run(self.configuration, options: ARSession.RunOptions.resetTracking)
                            }
                            if self.gameStatus == false{
                                break
                            }
                            try await Task.sleep(nanoseconds: 7000000000)
                        } else if event == "AT" {
                            let passAnchor = try! Experience.loadPassComplete()
                            let ph1 = passAnchor.ph1?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            let pa1 = passAnchor.pa1?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            let pa2 = passAnchor.pa2?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            let pa3 = passAnchor.pa3?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            let agk5 = passAnchor.agk5?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            let hgk5 = passAnchor.hgk5?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            ph1.model?.materials = [red]
                            pa1.model?.materials = [blue]
                            pa2.model?.materials = [blue]
                            pa3.model?.materials = [blue]
                            hgk5.model?.materials = [red]
                            agk5.model?.materials = [blue]
                            arView.scene.anchors.append(passAnchor)
                            eventChange(text: "\(oppName) presses the attack!")
                            DispatchQueue.main.asyncAfter(deadline: .now() + 6.57) {
                                print("Removing")
                                self.arView.scene.anchors.removeAll()
                                //self.arView.scene.removeAnchor(passAnchor)
                               // self.arView.session.run(self.configuration, options: ARSession.RunOptions.resetTracking)
                            }
                            if self.gameStatus == false{
                                break
                            }
                            try await Task.sleep(nanoseconds: 7000000000)
                        } else if event == "HDC" {
                            
                            let tackleAnchor2 = try! Experience.loadTackleAway()
                            let TA1 = tackleAnchor2.tA1?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            let TA2 = tackleAnchor2.tA2?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            let TA3 = tackleAnchor2.tA3?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            let TA4 = tackleAnchor2.tA4?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                           
                            let TA5 = tackleAnchor2.tA5?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            let TD6 = tackleAnchor2.tH10?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            let TAA6 = tackleAnchor2.tA6?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            let TA8 = tackleAnchor2.tA8?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                           
                            let TA9 = tackleAnchor2.tA9?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            let hgk4 = tackleAnchor2.homeGK3?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            let agk4 = tackleAnchor2.awayGK3?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            TA1.model?.materials = [red]
                            TA2.model?.materials = [red]
                            TA3.model?.materials = [red]
                            TA4.model?.materials = [red]
                            TA5.model?.materials = [red]
                            TD6.model?.materials = [blue]
                            TAA6.model?.materials = [red]
                            TA8.model?.materials = [red]
                            TA9.model?.materials = [red]
                            agk4.model?.materials = [red]
                            hgk4.model?.materials = [blue]
                            arView.scene.anchors.append(tackleAnchor2)
                            eventChange(text: "An excellent stop by \(oppName)")
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5.4) {
                                print("Removing")
                                self.arView.scene.anchors.removeAll()
                                //self.arView.scene.removeAnchor(tackleAnchor)
                               // self.arView.session.run(self.configuration, options: ARSession.RunOptions.resetTracking)
                            }
                            if self.gameStatus == false{
                                break
                            }
                            try await Task.sleep(nanoseconds: 6000000000)
                        } else if event == "ADC" {
                            let tackleAnchor = try! Experience.loadTackle()
                            let TD1 = tackleAnchor.tH1?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            let TD2 = tackleAnchor.tH2?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            let TD3 = tackleAnchor.tH3?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            let TD4 = tackleAnchor.tH4?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                           
                            let TD5 = tackleAnchor.tH5?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            let TA6 = tackleAnchor.tH6?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            let TD7 = tackleAnchor.tH7?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                           
                            let TD8 = tackleAnchor.tH8?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            let TD9 = tackleAnchor.tH9?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            let hgk3 = tackleAnchor.homeGK3?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            let agk3 = tackleAnchor.awayGK3?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            TD1.model?.materials = [blue]
                            TD2.model?.materials = [blue]
                            TD3.model?.materials = [blue]
                            TD4.model?.materials = [blue]
                            TD5.model?.materials = [blue]
                            TD7.model?.materials = [blue]
                            TD8.model?.materials = [blue]
                            TD9.model?.materials = [blue]
                            TA6.model?.materials = [red]
                            hgk3.model?.materials = [red]
                            agk3.model?.materials = [blue]
                            arView.scene.anchors.append(tackleAnchor)
                            eventChange(text: "An amazing tackle from \(teamName)")
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5.4) {
                                print("Removing")
                                self.arView.scene.anchors.removeAll()
                                //self.arView.scene.removeAnchor(tackleAnchor2)
                                //self.arView.session.run(self.configuration, options: ARSession.RunOptions.resetTracking)
                            }
                            if self.gameStatus == false{
                                break
                            }
                            try await Task.sleep(nanoseconds: 6000000000)
                        } else if event == "HMC" {
                            let passIAnchor2 = try! Experience.loadPassIncompleteAway()
                        
                            let pia3 = passIAnchor2.pia3?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            let pia4 = passIAnchor2.pia4?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            let pia5 = passIAnchor2.pia5?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            let pih4 = passIAnchor2.pih4?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            let pih5 = passIAnchor2.pih5?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            let agk7 = passIAnchor2.agk7?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            let hgk7 = passIAnchor2.hgk7?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            
                            pia3.model?.materials = [blue]
                            pia4.model?.materials = [blue]
                            pia5.model?.materials = [blue]
                            pih4.model?.materials = [red]
                            pih5.model?.materials = [red]
                            hgk7.model?.materials = [red]
                            agk7.model?.materials = [blue]
                            arView.scene.anchors.append(passIAnchor2)
                            eventChange(text: "\(oppName) intercepts \(teamName)'s pass!")
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.71) {
                                print("Removing")
                                self.arView.scene.anchors.removeAll()
                                //self.arView.scene.removeAnchor(passIAnchor)
                             //   self.arView.session.run(self.configuration, options: ARSession.RunOptions.resetTracking)
                            }
                            if self.gameStatus == false{
                                break
                            }
                            try await Task.sleep(nanoseconds: 4000000000)
                        } else if event == "AMC" {
                            
                            
                            let passIAnchor = try! Experience.loadPassIncomplete()
                            let pih1 = passIAnchor.pih1?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            let pih2 = passIAnchor.pih2?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            let pih3 = passIAnchor.pih3?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            let pia1 = passIAnchor.pia1?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            let pia2 = passIAnchor.pia2?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            let agk6 = passIAnchor.agk6?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            let hgk6 = passIAnchor.hgk6?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            pih1.model?.materials = [red]
                            pih2.model?.materials = [red]
                            pih3.model?.materials = [red]
                            pia1.model?.materials = [blue]
                            pia2.model?.materials = [blue]
                            hgk6.model?.materials = [red]
                            agk6.model?.materials = [blue]
                            arView.scene.anchors.append(passIAnchor)
                            eventChange(text: "\(teamName) has stolen possesion from \(oppName)!")
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.71) {
                                print("Removing")
                                self.arView.scene.anchors.removeAll()
                                //self.arView.scene.removeAnchor(passIAnchor)
                                //self.arView.session.run(self.configuration, options: ARSession.RunOptions.resetTracking)
                            }
                            if self.gameStatus == false{
                                break
                            }
                            try await Task.sleep(nanoseconds: 4000000000)
                        } else if event == "HS" {
                            homeScore()
                            let goalAnchor = try! Experience.loadGoalkeeperScore()
                            let gh1 = goalAnchor.gh1?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            let ga1 = goalAnchor.ga1?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            let ga2 = goalAnchor.ga2?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            let ga3 = goalAnchor.ga3?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity

                            let ga4 = goalAnchor.ga4?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity

                            
                            gh1.model?.materials = [red]
                            ga1.model?.materials = [blue]
                            ga2.model?.materials = [blue]
                            ga3.model?.materials = [red]
                            ga4.model?.materials = [blue]
                            arView.scene.anchors.append(goalAnchor)
                            eventChange(text: "\(teamName) has scored!")
                            DispatchQueue.main.asyncAfter(deadline: .now() + 6.2) {
                                print("Removing")
                                self.arView.scene.anchors.removeAll()
                                //self.arView.scene.removeAnchor(goalAnchor)
                                //self.arView.session.run(self.configuration, options: ARSession.RunOptions.resetTracking)
                            }
                            if self.gameStatus == false{
                                break
                            }
                            try await Task.sleep(nanoseconds: 7000000000)
                        } else if event == "AS" {
                            awayScore()
                            let goalAnchor2 = try! Experience.loadGoalkeeperScoreAway()
                            let ag1 = goalAnchor2.ag1?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            let hg1 = goalAnchor2.hg1?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            let hg2 = goalAnchor2.hg2?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            let hg3 = goalAnchor2.hg3?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity

                            let agg2 = goalAnchor2.agg2?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            ag1.model?.materials = [blue]
                            agg2.model?.materials = [blue]
                            hg1.model?.materials = [red]
                            hg2.model?.materials = [red]
                            hg3.model?.materials = [red]
                            arView.scene.anchors.append(goalAnchor2)
                            eventChange(text: "\(oppName) has scored!")
                            DispatchQueue.main.asyncAfter(deadline: .now() + 6.2) {
                                print("Removing")
                                self.arView.scene.anchors.removeAll()
                                //self.arView.scene.removeAnchor(goalAnchor2)
                                //self.arView.session.run(self.configuration, options: ARSession.RunOptions.resetTracking)
                            }
                            if self.gameStatus == false{
                                break
                            }
                            try await Task.sleep(nanoseconds: 7000000000)
                        } else if event == "HGKS" {
                            let saveAnchor = try! Experience.loadGoalkeeperSave()
                            let gka1 = saveAnchor.gka1?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            let gkh1 = saveAnchor.gkh1?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            let gkh2 = saveAnchor.gkh2?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            let gkh3 = saveAnchor.gkh3?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            gkh1.model?.materials = [red]
                            gkh2.model?.materials = [red]
                            gkh3.model?.materials = [red]
                            gka1.model?.materials = [blue]
                            arView.scene.anchors.append(saveAnchor)
                            eventChange(text: "\(teamName) has blocked \(oppName)'s shot!")
                            DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                                print("Removing")
                                self.arView.scene.anchors.removeAll()
                                //self.arView.scene.removeAnchor(saveAnchor)
                                //self.arView.session.run(self.configuration, options: ARSession.RunOptions.resetTracking)
                            }
                            if self.gameStatus == false{
                                break
                            }
                            try await Task.sleep(nanoseconds: 7000000000)
                        } else if event == "AGKS" {
                            let saveAnchor2 = try! Experience.loadGoalkeeperSaveAway()
                            let gkh4 = saveAnchor2.gkh4?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            let gka2 = saveAnchor2.gka2?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            let gka3 = saveAnchor2.gka3?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            let gka4 = saveAnchor2.gka4?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            gkh4.model?.materials = [red]
                            gka2.model?.materials = [blue]
                            gka3.model?.materials = [blue]
                            gka4.model?.materials = [blue]
                            arView.scene.anchors.append(saveAnchor2)
                            eventChange(text: "\(oppName) has blocked \(teamName)'s shot!")
                            DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                                print("Removing")
                                self.arView.scene.anchors.removeAll()
                                //self.arView.scene.removeAnchor(saveAnchor2)
                                //self.arView.session.run(self.configuration, options: ARSession.RunOptions.resetTracking)
                            }
                            if self.gameStatus == false{
                                break
                            }
                            try await Task.sleep(nanoseconds: 7000000000)
                            
                        } else if event == "HT" {
                            let koAnchor = try! Experience.loadKickoff()
                            let hgk1 = koAnchor.homeGK1?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            let agk1 = koAnchor.awayGK1?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            let passer = koAnchor.homePass?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            let receiver = koAnchor.homeRec?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            hgk1.model?.materials = [red]
                            agk1.model?.materials = [blue]
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
                            
                            arView.scene.anchors.append(koAnchor)
                            eventChange(text: "HALF TIME HAS STARTED")
                            DispatchQueue.main.asyncAfter(deadline: .now() + 7.2) {
                                print("Removing")
                                self.arView.scene.anchors.removeAll()
                                //self.arView.scene.removeAnchor(koAnchor)
                                //self.arView.session.run(self.configuration, options: ARSession.RunOptions.resetTracking)
                            }
                            if self.gameStatus == false{
                                break
                            }
                            try await Task.sleep(nanoseconds: 8000000000)
                            
                        } else if event == "FT" {
                            let koAnchor = try! Experience.loadKickoff()
                            let hgk1 = koAnchor.homeGK1?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            let agk1 = koAnchor.awayGK1?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            let passer = koAnchor.homePass?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            let receiver = koAnchor.homeRec?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            hgk1.model?.materials = [red]
                            agk1.model?.materials = [blue]
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
                            
                            arView.scene.anchors.append(koAnchor)
                            eventChange(text: "MATCH DONE")
                            DispatchQueue.main.asyncAfter(deadline: .now() + 7.2) {
                                print("Removing")
                                self.arView.scene.anchors.removeAll()
                                //self.arView.scene.removeAnchor(koAnchor)
                                //self.arView.session.run(self.configuration, options: ARSession.RunOptions.resetTracking)
                            }
                            if self.gameStatus == false{
                                break
                            }
                            try await Task.sleep(nanoseconds: 8000000000)
                            
                        } else if event == "KF"  {
                            let koAnchor = try! Experience.loadKickoff()
                            let hgk1 = koAnchor.homeGK1?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            let agk1 = koAnchor.awayGK1?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            let passer = koAnchor.homePass?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            let receiver = koAnchor.homeRec?.children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0].children[0] as! ModelEntity
                            
                            hgk1.model?.materials = [red]
                            agk1.model?.materials = [blue]
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
                            
                            arView.scene.anchors.append(koAnchor)
                            eventChange(text: "Kickoff")
                            DispatchQueue.main.asyncAfter(deadline: .now() + 7.2) {
                                print("Removing")
                                self.arView.scene.anchors.removeAll()
                               // self.arView.session.run(self.configuration, options: ARSession.RunOptions.resetTracking)
                            }
                            if self.gameStatus == false{
                                break
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
            
            //Kickoff
            //Pass and Receiver
            
            //Dribble
            
            
            
            
            //Home Tackle
            
            
            //Away tackle
            
            
            //Home Goal
            
            
            //Away goal
            
            
            //Home save
            
            
            //Away save
           
            
            //Pass complete
           
            //Pass incomplete home
            
            
        }
            
    }
}

