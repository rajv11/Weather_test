//
//  MainModelTests.swift
//  WeatherAppTests
//
//  Created by raj on 5/24/23.
//

import XCTest
@testable import WeatherApp

final class MainModelTests: XCTestCase {
    
    func testMainDecoding() {
        // Given
        let jsonfileName = "weatherData"
        guard let data = Utilities.setUpJsonFile(jsonFileName: jsonfileName) else { return }
        
        // When
        let decoder = JSONDecoder()
        let weatherData = try? decoder.decode(WeatherData.self, from: data)
        
        // Then
        XCTAssertNotNil(weatherData?.main)
        XCTAssertEqual(weatherData?.main.temp, 298.48)
    }
    
    func testMainEncoding() {
        // Given
        let main = Main(temp: 23.0, feelsLike: 24.0, tempMin: 16.0, tempMax: 30.0, humidity: 64)
        
        // When
        let encoder = JSONEncoder()
        let encodedData = try? encoder.encode(main)
        let decoder = JSONDecoder()
        let decodedMain = try? decoder.decode(Main.self, from: encodedData!)
        
        // Then
        XCTAssertNotNil(encodedData)
        XCTAssertNotNil(decodedMain)
        XCTAssertEqual(decodedMain?.temp, 23.0)
        XCTAssertEqual(decodedMain?.feelsLike, 24.0)
        XCTAssertEqual(decodedMain?.tempMin, 16.0)
        XCTAssertEqual(decodedMain?.tempMax, 30.0)
        XCTAssertEqual(decodedMain?.humidity, 64)
        
    }
}
