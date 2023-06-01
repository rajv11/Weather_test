//
//  MockWeatherDataService.swift
//  WeatherAppTests
//
//  Created by raj on 5/23/23.
//

import Foundation
@testable import WeatherApp

// MockWeatherDataService is a subclass of WeatherDataService used for testing purposes.
class MockWeatherDataService: WeatherDataService {
    static var weatherData: WeatherData? // Static property to store the weather data for mocking
    static var error: Error? // Static property to store the error for mocking
    
    // Overriding the fetchWeatherData(for city:completion:) method to provide mock weather data or error
    override func fetchWeatherData(for city: String, completion: @escaping (Result<WeatherData, Error>) -> Void) {
        if let weatherData = Self.weatherData {
            completion(.success(weatherData)) // Return the mock weather data
        } else if let error = Self.error {
            completion(.failure(error)) // Return the mock error
        } else {
            // If neither weather data nor error is set, return a generic error indicating weather data is not available
            let error = NSError(domain: "MockWeatherDataService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Weather data not available"])
            completion(.failure(error))
        }
    }
    
    // Overriding the fetchWeatherData(forLatitude:longitude:completion:) method to provide mock weather data or error
    override func fetchWeatherData(forLatitude latitude: Double, longitude: Double, completion: @escaping (Result<WeatherData, Error>) -> Void) {
        if let weatherData = Self.weatherData {
            completion(.success(weatherData)) // Return the mock weather data
        } else if let error = Self.error {
            completion(.failure(error)) // Return the mock error
        } else {
            // If neither weather data nor error is set, return a generic error indicating weather data is not available
            let error = NSError(domain: "MockWeatherDataService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Weather data not available"])
            completion(.failure(error))
        }
    }
}
