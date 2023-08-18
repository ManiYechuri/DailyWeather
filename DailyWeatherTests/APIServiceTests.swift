//
//  APIServiceTests.swift
//  DailyWeatherTests
//
//  Created by Mani Yechuri on 2023/08/18.
//

import XCTest
@testable import DailyWeather


final class APIServiceTests: XCTestCase {
    
    var apiService : APIManager?

    override func setUpWithError() throws {
        apiService = APIManager()
        try super.setUpWithError()

    }

    override func tearDownWithError() throws {
        apiService = nil
        try super.tearDownWithError()
    }

    func testExample() throws {
        
    }
    
    func testCurrentWeatherAPI() throws {
        let service = apiService!
        
        let expect = XCTestExpectation(description: "callback")
        
        service.getWeatherData(urlString: Constant.API.currentWeatherAPI, latitude: "37.785834", longitude: "-122.406417", type: CurrentWeatherData.self) { response in
            expect.fulfill()
            switch response {
            case .success(let weather):
                XCTAssertNotNil(weather)
            case .failure(let _error):
                XCTAssertTrue(true)
            }
        }
        wait(for: [expect])
    }
    
    func testForecastWeatherAPI(){
        let service = apiService!
        
        let expect = XCTestExpectation(description: "callback")
        
        service.getWeatherData(urlString: Constant.API.currentWeatherAPI, latitude: "37.785834", longitude: "-122.406417", type: ForecastWeatherData.self) { response in
            expect.fulfill()
            switch response {
            case .success(let weather):
                XCTAssertNotNil(weather)
            case .failure(let _error):
                XCTAssertTrue(true)
            }
        }
        wait(for: [expect])
    }

    func testPerformanceExample() throws {
        self.measure {
        }
    }

}
