//
//  WeatherViewModelTests.swift
//  WeatherAppTests
//
//  Created by raj on 5/23/23.
//

import XCTest
import CoreLocation
@testable import WeatherApp


final class WeatherViewModelTests: XCTestCase {
    
    var weatherDataService: WeatherDataService!
    var locationService: LocationService!
    var weatherViewModel: WeatherViewModel!
    
    override func setUp() {
        super.setUp()
        weatherDataService = WeatherDataService(apiKey: "")
        locationService = LocationService()
        weatherViewModel = WeatherViewModel(weatherDataService: weatherDataService, locationService: locationService)
        
        // Register MockingURLProtocol as the default protocol for URLSession
        URLProtocol.registerClass(MockingURLProtocol.self)
    }
    
    override func tearDown() {
        weatherDataService = nil
        locationService = nil
        weatherViewModel = nil
        
        // Unregister MockingURLProtocol
        URLProtocol.unregisterClass(MockingURLProtocol.self)
        
        super.tearDown()
    }
    
    func testFetchWeatherDataForCity_Success() {
        // Given
        let expectation = XCTestExpectation(description: "Fetch weather data for city")
        let city = "Zocca"
        
        let jsonfileName = "weatherData"
        guard let data = Utilities.setUpJsonFile(jsonFileName: jsonfileName) else { return }
        
        // Set the dummy data for the mocking protocol
        MockingURLProtocol.data = data
        
        // When
        weatherViewModel.fetchWeatherData(forCity: city) { result in
            // Then
            switch result {
            case .success:
                // Verify that the weather data has been updated
                XCTAssertEqual(self.weatherViewModel.cityName, city)
                XCTAssertFalse(self.weatherViewModel.temperature.isEmpty)
                XCTAssertFalse(self.weatherViewModel.weatherDescription.isEmpty)
                XCTAssertFalse(self.weatherViewModel.weatherIconName.isEmpty)
                
                expectation.fulfill()
                
            case .failure:
                XCTFail("Fetching weather data for city failed")
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFetchWeatherDataForCity_Failure() {
        // Given
        let expectation = XCTestExpectation(description: "Fetch weather data for city")
        let city = "NonexistentCity"
        
        // Mock error
        let error = NSError(domain: "WeatherDataService", code: 0, userInfo: [NSLocalizedDescriptionKey: "City not found"])
        
        // Set the mocked error in the MockingURLProtocol
        MockingURLProtocol.error = error
        
        // When
        weatherViewModel.fetchWeatherData(forCity: city) { result in
            // Then
            switch result {
            case .success:
                XCTFail("Fetching weather data for city should have failed")
                
            case .failure(let error):
                // Verify the error
                XCTAssertEqual((error as NSError).localizedDescription, "City not found")
                
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }

    func testFetchWeatherDataForCurrentLocation_Success() {
        // Given
        let expectation = XCTestExpectation(description: "Fetch weather data for current location")
        
        let jsonfileName = "weatherData"
        guard let data = Utilities.setUpJsonFile(jsonFileName: jsonfileName) else { return }
        
        // Set the dummy data for the mocking protocol
        MockingURLProtocol.data = data
        
        // When
        weatherViewModel.fetchWeatherDataForCurrentLocation { result in
            // Then
            switch result {
            case .success:
                // Verify that the weather data has been updated
                XCTAssertFalse(self.weatherViewModel.cityName.isEmpty)
                XCTAssertFalse(self.weatherViewModel.temperature.isEmpty)
                XCTAssertFalse(self.weatherViewModel.weatherDescription.isEmpty)
                XCTAssertFalse(self.weatherViewModel.weatherIconName.isEmpty)
                
                expectation.fulfill()
                
            case .failure:
                XCTFail("Fetching weather data for current location failed")
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }

    func testFetchWeatherDataForCurrentLocation_Failure() {
        // Given
        let error = NSError(domain: "TestError", code: 0, userInfo: nil)
        MockLocationService.authorizationStatus = .authorizedWhenInUse
        MockLocationService.location = CLLocation(latitude: 37.7749, longitude: -122.4194)
        MockWeatherDataService.error = error
        
        // Create a mock WeatherDataService instance and pass it to the WeatherViewModel
        let weatherDataService = MockWeatherDataService(apiKey: "")
        weatherViewModel = WeatherViewModel(weatherDataService: weatherDataService, locationService: locationService)
        
        var expectedResult: Result<Void, Error>?
        
        // When
        let expectation = self.expectation(description: "Completion called")
        weatherViewModel.fetchWeatherDataForCurrentLocation { result in
            expectedResult = result
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
        
        // Then
        guard case let .failure(receivedError) = expectedResult else {
            XCTFail("Expected fetchWeatherDataForCurrentLocation to fail")
            return
        }
        
        XCTAssertEqual(receivedError as NSError, error)
    }

    func testGetCachedImage() {
        // Given
        let iconName = "01d"
        let image = UIImage(named: "placeholderImage")!
        
        // Cache the image
        weatherViewModel.setCachedImage(image, for: iconName)
        
        // When
        let cachedImage = weatherViewModel.getCachedImage(for: iconName)
        
        // Then
        XCTAssertNotNil(cachedImage)
        XCTAssertEqual(cachedImage, image)
    }

    func testSetCachedImage() {
        // Given
        let iconName = "02d"
        let image = UIImage(named: "placeholderImage")!
        
        // When
        weatherViewModel.setCachedImage(image, for: iconName)
        
        // Then
        let cachedImage = weatherViewModel.getCachedImage(for: iconName)
        XCTAssertNotNil(cachedImage)
        XCTAssertEqual(cachedImage, image)
    }

    
}
