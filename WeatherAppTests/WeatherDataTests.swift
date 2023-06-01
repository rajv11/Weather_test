//
//  WeatherDataTests.swift
//  WeatherAppTests
//
//  Created by raj on 5/23/23.
//

import XCTest
@testable import WeatherApp

final class WeatherDataTests: XCTestCase {
    
    func testWeatherDataDecoding() {
        // Given
        let jsonfileName = "weatherData"
        guard let data = Utilities.setUpJsonFile(jsonFileName: jsonfileName) else { return }
        
        // When
        let decoder = JSONDecoder()
        let weatherData = try? decoder.decode(WeatherData.self, from: data)
        
        // Then
        XCTAssertNotNil(weatherData)
        XCTAssertEqual(weatherData?.main.temp, 298.48)
        XCTAssertEqual(weatherData?.weather.count, 1)
        XCTAssertEqual(weatherData?.weather.first?.description, "moderate rain")
        XCTAssertEqual(weatherData?.weather.first?.icon, "10d")
        XCTAssertEqual(weatherData?.name, "Zocca")
    }
    
    func testWeatherDataEncoding() {
        // Given
        let main = Main(temp: 23.0, feelsLike: 24.0, tempMin: 16.0, tempMax: 30.0, humidity: 64)
        let weather = Weather(description: "Sunny day", icon: "02d")
        let weatherData = WeatherData(main: main, weather: [weather], name: "City")
        
        // When
        let encoder = JSONEncoder()
        let encodedData = try? encoder.encode(weatherData)
        let decoder = JSONDecoder()
        let decodedWeatherData = try? decoder.decode(WeatherData.self, from: encodedData!)
        
        // Then
        XCTAssertNotNil(encodedData)
        XCTAssertNotNil(decodedWeatherData)
        XCTAssertEqual(decodedWeatherData?.main.temp, 23.0)
        XCTAssertEqual(decodedWeatherData?.weather.count, 1)
        XCTAssertEqual(decodedWeatherData?.weather.first?.description, "Sunny day")
        XCTAssertEqual(decodedWeatherData?.weather.first?.icon, "02d")
        XCTAssertEqual(decodedWeatherData?.name, "City")
    }
}
