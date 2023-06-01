//
//  WeatherDataServiceTests.swift
//  WeatherAppTests
//
//  Created by raj on 5/23/23.
//

import XCTest
@testable import WeatherApp

final class WeatherDataServiceTests: XCTestCase {
    
    var weatherDataService: WeatherDataService!
    let apiKey = ""
    
    override func setUp() {
        super.setUp()
        weatherDataService = WeatherDataService(apiKey: apiKey)
        URLProtocol.registerClass(MockingURLProtocol.self)
    }
    
    override func tearDown() {
        weatherDataService = nil
        MockingURLProtocol.data = nil
        URLProtocol.unregisterClass(MockingURLProtocol.self)
        super.tearDown()
    }
    
    func testFetchWeatherData_Success() {
        
        let jsonfileName = "weatherData"
        guard let data = Utilities.setUpJsonFile(jsonFileName: jsonfileName) else { return }
        
        // Set the dummy data for the mocking protocol
        MockingURLProtocol.data = data
        
        // Create an expectation for the async network request
        let expectation = XCTestExpectation(description: "Fetch weather data")
        
        // Perform the fetch weather data request
        weatherDataService.fetchWeatherData(for: "Zocca") { result in
            switch result {
            case .success(let weatherData):
                XCTAssertEqual(weatherData.name, "Zocca", "City name should match")
                XCTAssertEqual(weatherData.main.temp, 298.48, "Temperature should match")
                expectation.fulfill()
                
            case .failure:
                XCTFail("Fetch weather data should succeed")
            }
        }
        
        // Wait for the expectation to be fulfilled
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testFetchWeatherData_Failure() {
        // Given
        let error = NSError(domain: "TestError", code: 0, userInfo: nil)
        MockWeatherDataService.error = error
        
        var expectedResult: Result<WeatherData, Error>?
        
        // Create a mock WeatherDataService instance
        let weatherDataService = MockWeatherDataService(apiKey: "")
        
        // When
        let expectation = self.expectation(description: "Completion called")
        // Perform the fetch weather data request
        weatherDataService.fetchWeatherData(for: "Dummy City") { result in
            
                expectedResult = result
                expectation.fulfill()
        }
        // Then
        guard case let .failure(receivedError) = expectedResult else {
            XCTFail("Expected fetchWeatherDataFor City to fail")
            return
        }
        
        XCTAssertEqual(receivedError as NSError, error)
        // Wait for the expectation to be fulfilled
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testFetchWeatherDataForLatitudeLongitude_Success() {
            // Prepare the dummy JSON response
        let jsonfileName = "weatherData"
        guard let data = Utilities.setUpJsonFile(jsonFileName: jsonfileName) else { return }
        
        // Set the dummy data for the mocking protocol
        MockingURLProtocol.data = data
            // Create an expectation for the async network request
            let expectation = XCTestExpectation(description: "Fetch weather data")
            
            // Perform the fetch weather data request
        weatherDataService.fetchWeatherData(forLatitude: 44.34, longitude: 10.99) { result in
                switch result {
                case .success(let weatherData):
                    XCTAssertEqual(weatherData.name, "Zocca", "City name should match")
                    XCTAssertEqual(weatherData.main.temp, 298.48, "Temperature should match")
                    expectation.fulfill()
                    
                case .failure:
                    XCTFail("Fetch weather data should succeed")
                }
            }
            
            // Wait for the expectation to be fulfilled
            wait(for: [expectation], timeout: 10.0)
        }
    
    func testFetchWeatherDataForLatitudeLongitude_Failure() {
        // Given
        let error = NSError(domain: "TestError", code: 0, userInfo: nil)
        MockWeatherDataService.error = error
        
        var expectedResult: Result<WeatherData, Error>?
        
        // Create a mock WeatherDataService instance
        let weatherDataService = MockWeatherDataService(apiKey: "")
        
        // When
        let expectation = self.expectation(description: "Completion called")
        weatherDataService.fetchWeatherData(forLatitude: 37.7749, longitude: -122.4194) { result in
            expectedResult = result
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
        
        // Then
        guard case let .failure(receivedError) = expectedResult else {
            XCTFail("Expected fetchWeatherDataForLatitudeLongitude to fail")
            return
        }
        
        XCTAssertEqual(receivedError as NSError, error)
    }
}
