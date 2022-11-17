//
//  UserDefaultService.swift
//  AR Soccer Manager
//
//  Created by Samuel Gerges on 2022-11-16.
//

import Foundation

class UserRepository {
    let userDefaults: UserDefaults
    // MARK: - Lifecycle
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    // MARK: - API
    func storeInfo(itemID: String, data: Data) {
        saveValue(value: data, itemID: itemID)
    }

    func getInfo(itemID: String) -> Data? {
        let returnData: Data? = readValue(itemID: itemID)
        return (returnData)
    }

    func removeInfo(itemID: String) {
        userDefaults.removeObject(forKey: itemID)
    }
    // MARK: - Private
    private func saveValue(value: Any, itemID: String) {
        userDefaults.set(value, forKey: itemID)
    }
    private func readValue<T>(itemID: String) -> T? {
        return userDefaults.value(forKey: itemID) as? T
    }
}
