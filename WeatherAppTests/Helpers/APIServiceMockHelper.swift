//
//  APIServiceMockHelper.swift
//  WeatherAppTests
//
//  Created by raj on 5/23/23.
//

import Foundation

// MockingURLProtocol is a subclass of URLProtocol used for mocking network requests during testing.
class MockingURLProtocol: URLProtocol {
    static var data: Data? // Static property to store the mock response data
    static var error: Error? // Static property to store the mock error
    
    // Override the canInit(with:) method to indicate that the protocol can handle all requests
    override class func canInit(with request: URLRequest) -> Bool {
        true
    }
    
    // Override the canonicalRequest(for:) method to return the provided request as is
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }
    
    // Override the startLoading() method to provide the mock response data or error
    override func startLoading() {
        if let data = Self.data {
            // If mock response data is set, notify the client that the data is being loaded and finish loading
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } else if let error = Self.error {
            // If mock error is set, notify the client that loading failed with the error
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    // Override the stopLoading() method to do nothing as there is no ongoing loading process
    override func stopLoading() {}
}
