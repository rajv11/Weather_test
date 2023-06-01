//
//  WeatherDataService.swift
//  WeatherApp
//
//  Created by raj on 5/23/23.
//

import Foundation

class WeatherDataService {
    // MARK: - Properties
    
    private let apiKey: String
    
    // MARK: - Initialization
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    // MARK: - Fetching Weather Data
    
    func fetchWeatherData(for city: String, completion: @escaping (Result<WeatherData, Error>) -> Void) {
        // Encoding the city name to ensure it is URL-safe
        let encodedCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        // Constructing the URL using the encoded city name and the API key
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(encodedCity)&appid=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            let error = NSError(domain: "Invalid URL", code: 0, userInfo: nil)
            completion(.failure(error))
            return
        }
        
        // Creating a URLSession data task to fetch the weather data
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "No data received", code: 0, userInfo: nil)
                completion(.failure(error))
                return
            }
            
            do {
                // Decoding the received JSON data into a WeatherData object using JSONDecoder
                let decoder = JSONDecoder()
                let weatherData = try decoder.decode(WeatherData.self, from: data)
                completion(.success(weatherData))
            } catch {
                completion(.failure(error))
            }
        }
        
        // Starting the URLSession data task
        task.resume()
    }
    
    func fetchWeatherData(forLatitude latitude: Double, longitude: Double, completion: @escaping (Result<WeatherData, Error>) -> Void) {
        // Constructing the URL using the latitude, longitude, and the API key
        let urlString = "http://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "WeatherDataService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        // Creating a URLSession data task to fetch the weather data
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "WeatherDataService", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                // Decoding the received JSON data into a WeatherData object using JSONDecoder
                let decoder = JSONDecoder()
                let weatherData = try decoder.decode(WeatherData.self, from: data)
                
                completion(.success(weatherData))
            } catch {
                completion(.failure(error))
            }
        }
        
        // Starting the URLSession data task
        task.resume()
    }
}
