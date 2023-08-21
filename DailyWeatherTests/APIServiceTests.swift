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
            case .failure(_):
                XCTAssertTrue(true)
            }
        }
        wait(for: [expect], timeout: 10.0)
    }
    
    func testForecastWeatherAPI(){
        let service = apiService!
        
        let expect = XCTestExpectation(description: "callback")
        
        service.getWeatherData(urlString: Constant.API.currentWeatherAPI, latitude: "37.785834", longitude: "-122.406417", type: ForecastWeatherData.self) { response in
            expect.fulfill()
            switch response {
            case .success(let weather):
                XCTAssertNotNil(weather)
            case .failure(_):
                XCTAssertTrue(true)
            }
        }
        wait(for: [expect], timeout: 5.0)
    }
    
    func testCurrentWeatherJSONProcessing() {
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "CurrentWeather", withExtension: "json") else {
            XCTFail("Could not find CurrentWeather.json file")
            return
        }
        
        do {
            let jsonData = try Data(contentsOf: url)
            let currentWeather = try JSONDecoder().decode(CurrentWeatherData.self, from: jsonData)
            XCTAssertNotNil(currentWeather)
            XCTAssertEqual(currentWeather.name, "Cupertino")
            XCTAssertEqual(currentWeather.coord!.lat, 37.3281)
            XCTAssertEqual(currentWeather.coord!.lon, -122.0198)
            XCTAssertEqual(currentWeather.base, "stations")
            XCTAssertEqual(currentWeather.main?.feels_like, 298.81)
            XCTAssertEqual(currentWeather.main?.humidity, 56)
            XCTAssertEqual(currentWeather.main?.pressure, 1010)
            XCTAssertEqual(currentWeather.main?.temp, 298.73)
            XCTAssertEqual(currentWeather.main?.temp_min, 292.36)
            XCTAssertEqual(currentWeather.main?.temp_max, 302.37)
            XCTAssertEqual(currentWeather.visibility, 10000)
            XCTAssertNotEqual(currentWeather.wind?.speed, 2.09 )
            XCTAssertNotEqual(currentWeather.wind?.deg, 200)
            XCTAssertEqual(currentWeather.clouds?.all, 20)
            XCTAssertEqual(currentWeather.dt, 1692386780)
            XCTAssertEqual(currentWeather.sys?.country, "US")
            XCTAssertEqual(currentWeather.sys?.sunrise, 1692365214)
            XCTAssertEqual(currentWeather.sys?.sunset, 1692413839)
            XCTAssertEqual(currentWeather.timezone, -25200)
            XCTAssertEqual(currentWeather.id, 5341145)

        }catch {
            XCTFail("Error reading or parsing JSON: \(error)")
        }
    }
    
    
    func testForecastWeatherJSONProcessing(){
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "ForecastWeather", withExtension: "json") else {
            XCTFail("Could not find ForecastWeather.json file")
            return
        }
        do {
            let jsonData = try Data(contentsOf: url)
            let forecastWeather = try JSONDecoder().decode(ForecastWeatherData.self, from: jsonData)
            XCTAssertNotNil(forecastWeather)
            XCTAssertEqual(forecastWeather.city.country, "US")
            XCTAssertEqual(forecastWeather.city.name, "Cupertino")
            XCTAssertEqual(forecastWeather.city.coord.lat, 37.3301)
            XCTAssertEqual(forecastWeather.city.coord.lon, -122.021)
            XCTAssertEqual(forecastWeather.city.timezone, -25200)
            XCTAssertEqual(forecastWeather.city.sunrise, 1692365214)
            XCTAssertEqual(forecastWeather.city.sunset, 1692413840)
            XCTAssertEqual(forecastWeather.city.id, 5341145)
        }catch {
            XCTFail("Error reading or parsing JSON: \(error)")
        }
    }

    func testPerformanceExample() throws {
        self.measure {
        }
    }

}
