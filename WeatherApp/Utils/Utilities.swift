//
//  Utilities.swift
//  WeatherApp
//
//  Created by raj on 5/23/23.
//

import Foundation

class Utilities {
    class func setUpJsonFile(jsonFileName: String?) -> Data? {
        guard let path = Bundle.main.path(forResource: jsonFileName, ofType: "json") else { return nil }
        do {
            return try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped) as Data
        } catch let error {
            debugPrint(error.localizedDescription)
        }
        return nil
    }
}
