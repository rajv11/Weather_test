//
//  MainModel.swift
//  WeatherApp
//
//  Created by raj on 5/23/23.
//

import Foundation

struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let humidity: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case humidity
    }
}
