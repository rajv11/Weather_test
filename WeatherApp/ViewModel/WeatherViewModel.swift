//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by raj on 5/23/23.
//

import Foundation
import CoreLocation
import UIKit

class WeatherViewModel {
    // MARK: - Properties
    
    private let weatherDataService: WeatherDataService
    private let locationService: LocationService
    private let imageCache: NSCache<NSString, UIImage>
    
    var temperature: String = ""                // Stores the temperature data
    var weatherDescription: String = ""         // Stores the weather description
    var weatherIconName: String = ""            // Stores the weather icon name
    var cityName: String = ""                   // Stores the city name
    var humidity: String = ""
    var high: String = ""
    var low: String = ""
    var feelsLike: String = ""
    
    // MARK: - Initialization
    
    init(weatherDataService: WeatherDataService, locationService: LocationService) {
        self.weatherDataService = weatherDataService
        self.locationService = locationService
        self.imageCache = NSCache()
    }
    
    // MARK: - Weather Data Fetching
    
    func fetchWeatherData(forCity city: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // Fetch weather data for the specified city
        weatherDataService.fetchWeatherData(for: city) { [weak self] result in
            switch result {
            case .success(let weatherData):
                self?.updateWeatherData(weatherData)
                completion(.success(()))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchWeatherDataForCurrentLocation(completion: @escaping (Result<Void, Error>) -> Void) {
        // Fetch weather data for the current user location
        locationService.requestLocationAuthorization { [weak self] result in
            switch result {
            case .success(let location):
                self?.fetchWeatherData(forLocation: location, completion: completion)
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func fetchWeatherData(forLocation location: CLLocation, completion: @escaping (Result<Void, Error>) -> Void) {
        // Fetch weather data for the specified location coordinates
        weatherDataService.fetchWeatherData(forLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude) { [weak self] result in
            switch result {
            case .success(let weatherData):
                self?.updateWeatherData(weatherData)
                completion(.success(()))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Update Weather Data
    
    private func updateWeatherData(_ weatherData: WeatherData) {
        /// Converting Kelvin to Celsius
        let temperature = weatherData.main.temp - 273.15
        let feelsLike = weatherData.main.feelsLike - 273.15
        let lowTemp = weatherData.main.tempMin - 273.15
        let highTemp = weatherData.main.tempMax - 273.15
        let humidity = weatherData.main.humidity
        
        self.temperature = "\(Int(temperature))°C"
        self.feelsLike = "\(Int(feelsLike))°C"
        self.low = "\(Int(lowTemp))°C"
        self.high = "\(Int(highTemp))°C"
        self.humidity = "\(humidity) %"
        self.weatherDescription = weatherData.weather.first?.description ?? ""
        self.weatherIconName = weatherData.weather.first?.icon ?? ""
        self.cityName = weatherData.name
    }
    
    // MARK: - Image Caching
    
    func getCachedImage(for weatherIconName: String) -> UIImage? {
        // Retrieve the cached image for the specified weather icon name
        return imageCache.object(forKey: weatherIconName as NSString)
    }
    
    func setCachedImage(_ image: UIImage, for weatherIconName: String) {
        // Cache the image for the specified weather icon name
        imageCache.setObject(image, forKey: weatherIconName as NSString)
    }
}
