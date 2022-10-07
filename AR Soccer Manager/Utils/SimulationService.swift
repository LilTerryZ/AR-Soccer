//
//  SimulationService.swift
//  AR Soccer Manager
//
//  Created by Samuel Gerges on 2022-10-07.
//

import Foundation

class Simulation{
    
    var resultDataDict = [String: Any]()
    
    func runSimulation(homeTeamName: String , awayTeamName: String) async -> [String: Any] {
        guard let url = URL(string: "https://us-central1-ar-soccer-manager-5cab3.cloudfunctions.net/simulateGame") else {
            print("Invalid URL")
            return ["Error": "Invalid URL"]
        }
        print(homeTeamName, awayTeamName)
        let body = ["homeTeam": ["name": homeTeamName],"awayTeam": ["name": awayTeamName]]
        let requestBodyJson = try? JSONSerialization.data(withJSONObject: body)

        var request = URLRequest(url: url)

        request.httpMethod = "POST"

        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")

        request.httpBody = requestBodyJson
        
        do{
            let (data, _) = try await URLSession.shared.data(for:request)
            
            if let dataString = String(data: data, encoding: .utf8) {
                return self.convertAndReturnData(str: dataString)
            } 
        }catch{
            return ["Error": "Bad Request"]
        }
        
        return [String: Any]()
        
    }
    func convertAndReturnData(str:String) -> [String: Any] {
        let data = Data(str.utf8)
        var returnData = [String: Any]()
        do {
            if let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]{
                returnData = dict
            }
        }catch let error as NSError{
            print("Failed to load: \(error.localizedDescription)")
        }
        
        return returnData
    }

    
}


extension String {
    func convertToDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
