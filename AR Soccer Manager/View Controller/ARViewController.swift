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
    @IBOutlet var awayScore: UILabel!
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
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Load the "Box" scene from the "Experience" Reality File
        //let boxAnchor = try! Experience.loadBox()
        
        let tackleAnchor = try! Experience.loadTackle()
        
        let goalAnchor = try! Experience.loadGoalkeeperScore()
        let saveAnchor = try! Experience.loadGoalkeeperSave()
        
        let passIAnchor = try! Experience.loadPassIncomplete()
        let passAnchor = try! Experience.loadPassComplete()
        
        let dribbleAnchor = try! Experience.loadDribble()
        
        let koAnchor = try! Experience.loadKickoff()
        self.homeScore?.text = "Home: \(hScore)"
        self.awayScore?.text = "Away: \(aScore)"
        
        runSimulation()
       
        func runSimulation() {
            let simulation = Simulation()

            Task{
                let result = await simulation.runSimulation(homeTeamName: "Liverpool", awayTeamName: "Manchester City")
                
                 print("Hello")
                 print(result["events"]!)
                
                let events = result["events"]
            
                for event in events as! [String] {
                    if event == "HA" {
                        arView.scene.anchors.append(passAnchor)
                        self.eventL?.text = "Home team making some plays!"
                        DispatchQueue.main.asyncAfter(deadline: .now() + 6.57) {
                            print("Removing")
                            self.arView.scene.anchors.removeAll()
                            }
                        try await Task.sleep(nanoseconds: 7000000000)
                    } else if event == "AT" {
                        arView.scene.anchors.append(passAnchor)
                        self.eventL?.text = "Away team making some moves!"
                        DispatchQueue.main.asyncAfter(deadline: .now() + 6.57) {
                            print("Removing")
                            self.arView.scene.anchors.removeAll()
                            }
                        try await Task.sleep(nanoseconds: 7000000000)
                    } else if event == "HDC" {
                        arView.scene.anchors.append(tackleAnchor)
                        self.eventL?.text = "Home team defends their field!"
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5.4) {
                            print("Removing")
                            self.arView.scene.anchors.removeAll()
                            }
                        try await Task.sleep(nanoseconds: 6000000000)
                    } else if event == "ADC" {
                        arView.scene.anchors.append(tackleAnchor)
                        self.eventL?.text = "Away team makes an amazing tackle!"
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5.4) {
                            print("Removing")
                            self.arView.scene.anchors.removeAll()
                            }
                        try await Task.sleep(nanoseconds: 6000000000)
                    } else if event == "HMC" {
                        arView.scene.anchors.append(passIAnchor)
                        self.eventL?.text = "Home team has pass intercepted!"
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.71) {
                            print("Removing")
                            self.arView.scene.anchors.removeAll()
                            }
                        try await Task.sleep(nanoseconds: 4000000000)
                    } else if event == "AMC" {
                        arView.scene.anchors.append(passIAnchor)
                        self.eventL?.text = "Away team has pass intercepted!"
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.71) {
                            print("Removing")
                            self.arView.scene.anchors.removeAll()
                            }
                        try await Task.sleep(nanoseconds: 4000000000)
                    } else if event == "HS" {
                        self.hScore = hScore + 1
                        self.homeScore?.text = "Home: \(hScore)"
                        arView.scene.anchors.append(goalAnchor)
                        self.eventL?.text = "Home team has scored!"
                        DispatchQueue.main.asyncAfter(deadline: .now() + 6.2) {
                            print("Removing")
                            self.arView.scene.anchors.removeAll()
                            }
                        try await Task.sleep(nanoseconds: 7000000000)
                    } else if event == "AS" {
                        self.aScore = aScore + 1
                        self.awayScore?.text = "Away: \(aScore)"
                        arView.scene.anchors.append(goalAnchor)
                        self.eventL?.text = "Away team has scored!"
                        DispatchQueue.main.asyncAfter(deadline: .now() + 6.2) {
                            print("Removing")
                            self.arView.scene.anchors.removeAll()
                            }
                        try await Task.sleep(nanoseconds: 7000000000)
                    } else if event == "HGKS" {
                        arView.scene.anchors.append(saveAnchor)
                        self.eventL?.text = "Home team saves shot!"
                        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                            print("Removing")
                            self.arView.scene.anchors.removeAll()
                            }
                        try await Task.sleep(nanoseconds: 7000000000)
                    } else if event == "AGKS" {
                        arView.scene.anchors.append(saveAnchor)
                        self.eventL?.text = "Away team saves shot!"
                        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                            print("Removing")
                            self.arView.scene.anchors.removeAll()
                            }
                        try await Task.sleep(nanoseconds: 7000000000)

                    } else if event == "HT" {
                        arView.scene.anchors.append(koAnchor)
                        self.eventL?.text = "Half time"
                        DispatchQueue.main.asyncAfter(deadline: .now() + 7.2) {
                            print("Removing")
                            self.arView.scene.anchors.removeAll()
                            }
                        try await Task.sleep(nanoseconds: 8000000000)

                    } else if event == "FT" {
                        arView.scene.anchors.append(koAnchor)
                        self.eventL?.text = "MATCH DONE"
                        DispatchQueue.main.asyncAfter(deadline: .now() + 7.2) {
                            print("Removing")
                            self.arView.scene.anchors.removeAll()
                            }
                        try await Task.sleep(nanoseconds: 8000000000)

                    } else if event == "KF"  {
                        arView.scene.anchors.append(koAnchor)
                        self.eventL?.text = "Kickoff"
                        DispatchQueue.main.asyncAfter(deadline: .now() + 7.2) {
                            print("Removing")
                            self.arView.scene.anchors.removeAll()
                            }
                        try await Task.sleep(nanoseconds: 8000000000)
                    }
                }
            }
            
        }
    }
    

}

