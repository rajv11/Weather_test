//
//  WeatherModelTests.swift
//  WeatherAppTests
//
//  Created by raj on 5/24/23.
//

import XCTest
@testable import WeatherApp

final class WeatherModelTests: XCTestCase {
    
    func testWeatherDecoding() {
        // Given
        let jsonfileName = "weatherData"
        guard let data = Utilities.setUpJsonFile(jsonFileName: jsonfileName) else { return }
        
        // When
        let decoder = JSONDecoder()
        let weatherData = try? decoder.decode(WeatherData.self, from: data)
        
        // Then
        XCTAssertNotNil(weatherData)
        XCTAssertEqual(weatherData?.weather[0].description, "moderate rain")
        XCTAssertEqual(weatherData?.weather[0].icon, "10d")
    }
    
    func testWeatherEncoding() {
        // Given
        let weather = Weather(description: "Cloudy sky", icon: "03d")
        
        // When
        let encoder = JSONEncoder()
        let encodedData = try? encoder.encode(weather)
        let decoder = JSONDecoder()
        let decodedWeather = try? decoder.decode(Weather.self, from: encodedData!)
        
        // Then
        XCTAssertNotNil(encodedData)
        XCTAssertNotNil(decodedWeather)
        XCTAssertEqual(decodedWeather?.description, "Cloudy sky")
        XCTAssertEqual(decodedWeather?.icon, "03d")
    }
}

