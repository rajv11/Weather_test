//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by raj on 5/23/23.
//

import Foundation

struct WeatherData: Codable {
    let main: Main
    let weather: [Weather]
    let name: String

    enum CodingKeys: String, CodingKey {
        case main, weather, name
    }
}
