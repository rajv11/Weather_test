//
//  MockLocationService.swift
//  WeatherAppTests
//
//  Created by raj on 5/23/23.
//

import Foundation
import CoreLocation
@testable import WeatherApp

// MockLocationService is a subclass of LocationService used for testing purposes.
class MockLocationService: LocationService {
    static var authorizationStatus: CLAuthorizationStatus = .notDetermined // Static property to store the mock authorization status
    static var location: CLLocation? // Static property to store the mock location
    
    // Overriding the requestLocationAuthorization(completion:) method to provide mock location data or error
    override func requestLocationAuthorization(completion: @escaping (Result<CLLocation, Error>) -> Void) {
        switch Self.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            if let location = Self.location {
                completion(.success(location)) // Return the mock location data as a success result
            } else {
                // If location is not set, return a generic error indicating location is not available
                let error = NSError(domain: "MockLocationService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Location not available"])
                completion(.failure(error))
            }
            
        case .denied, .restricted:
            // If authorization is denied or restricted, return a specific error indicating location authorization is denied
            let error = NSError(domain: "MockLocationService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Location authorization denied"])
            completion(.failure(error))
            
        default:
            // If authorization status is not determined, return a generic error indicating location authorization is not determined
            let error = NSError(domain: "MockLocationService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Location authorization not determined"])
            completion(.failure(error))
        }
    }
}

