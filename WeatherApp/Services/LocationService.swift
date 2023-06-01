//
//  LocationService.swift
//  WeatherApp
//
//  Created by raj on 5/23/23.
//

import CoreLocation

class LocationService: NSObject, CLLocationManagerDelegate {
    private let locationManager: CLLocationManager
    private var locationUpdateHandler: ((Result<CLLocation, Error>) -> Void)?
    
    override init() {
        self.locationManager = CLLocationManager()
        super.init()
        
        self.locationManager.delegate = self
    }
    
    func requestLocationAuthorization(completion: @escaping (Result<CLLocation, Error>) -> Void) {
        locationUpdateHandler = completion // Save the completion handler
        
        let status = locationManager.authorizationStatus
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            requestLocation()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            let error = NSError(domain: "LocationError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Location services not authorized."])
            completion(.failure(error))
        @unknown default:
            let error = NSError(domain: "LocationError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unknown location authorization status."])
            completion(.failure(error))
        }
    }
    
    private func requestLocation() {
        locationManager.requestLocation()
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            requestLocation()
        } else if status == .denied || status == .restricted {
            let error = NSError(domain: "LocationError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Location services not authorized."])
            locationUpdateHandler?(.failure(error))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationUpdateHandler?(.success(location))
        } else {
            let error = NSError(domain: "LocationError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to get location."])
            locationUpdateHandler?(.failure(error))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationUpdateHandler?(.failure(error))
    }
}
