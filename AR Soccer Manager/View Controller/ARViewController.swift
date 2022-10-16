//
//  ViewController.swift
//  AR Test 2
//
//  Created by Diamond Winter-Hogan on 2022-08-27.
//

import UIKit
import RealityKit

class ARViewController: UIViewController {
    
    @IBOutlet var arView: ARView!
    var gameTimer: Timer?
    var anchorStatus = false
    
    var timer:Timer = Timer()
    var count:Double = 0.0
    var timerCounting:Bool = false
    
    var sceneTime: Double = 0.0
        
    
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
        

        //arView.scene.anchors.append(koAnchor);
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
                        DispatchQueue.main.asyncAfter(deadline: .now() + 6.57) {
                            print("Removing")
                            self.arView.scene.anchors.removeAll()
                            }
                        try await Task.sleep(nanoseconds: 7000000000)
                    } else if event == "AT" {
                        arView.scene.anchors.append(passAnchor)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 6.57) {
                            print("Removing")
                            self.arView.scene.anchors.removeAll()
                            }
                        try await Task.sleep(nanoseconds: 7000000000)
                    } else if event == "HDC" {
                        arView.scene.anchors.append(tackleAnchor)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5.4) {
                            print("Removing")
                            self.arView.scene.anchors.removeAll()
                            }
                        try await Task.sleep(nanoseconds: 6000000000)
                    } else if event == "ADC" {
                        arView.scene.anchors.append(tackleAnchor)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5.4) {
                            print("Removing")
                            self.arView.scene.anchors.removeAll()
                            }
                        try await Task.sleep(nanoseconds: 6000000000)
                    } else if event == "HMC" {
                        arView.scene.anchors.append(passIAnchor)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.71) {
                            print("Removing")
                            self.arView.scene.anchors.removeAll()
                            }
                        try await Task.sleep(nanoseconds: 4000000000)
                    } else if event == "AMC" {
                        arView.scene.anchors.append(passIAnchor)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.71) {
                            print("Removing")
                            self.arView.scene.anchors.removeAll()
                            }
                        try await Task.sleep(nanoseconds: 4000000000)
                    } else if event == "HS" {
                        arView.scene.anchors.append(goalAnchor)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 6.2) {
                            print("Removing")
                            self.arView.scene.anchors.removeAll()
                            }
                        try await Task.sleep(nanoseconds: 7000000000)
                    } else if event == "AS" {
                        arView.scene.anchors.append(goalAnchor)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 6.2) {
                            print("Removing")
                            self.arView.scene.anchors.removeAll()
                            }
                        try await Task.sleep(nanoseconds: 7000000000)
                    } else if event == "HGKS" {
                        arView.scene.anchors.append(saveAnchor)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                            print("Removing")
                            self.arView.scene.anchors.removeAll()
                            }
                        try await Task.sleep(nanoseconds: 7000000000)
                    } else if event == "AGKS" {
                        arView.scene.anchors.append(saveAnchor)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                            print("Removing")
                            self.arView.scene.anchors.removeAll()
                            }
                        try await Task.sleep(nanoseconds: 7000000000)

                    } else if event == "HT" {
                        arView.scene.anchors.append(koAnchor)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 7.2) {
                            print("Removing")
                            self.arView.scene.anchors.removeAll()
                            }
                        try await Task.sleep(nanoseconds: 8000000000)

                    } else if event == "FT" {
                        arView.scene.anchors.append(koAnchor)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 7.2) {
                            print("Removing")
                            self.arView.scene.anchors.removeAll()
                            }
                        try await Task.sleep(nanoseconds: 8000000000)

                    } else if event == "KF"  {
                        arView.scene.anchors.append(koAnchor)
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

