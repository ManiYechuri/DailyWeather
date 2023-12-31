//
//  DailyWeatherTests.swift
//  DailyWeatherTests
//
//  Created by Mani Yechuri on 2023/08/18.
//

import XCTest
@testable import DailyWeather

final class DailyWeatherTests: XCTestCase {
    
    var viewModel : CurrentWeatherViewModel?
    var locationManager : MyLocationManager?

    override func setUpWithError() throws {
        locationManager = MyLocationManager()
        viewModel = CurrentWeatherViewModel()
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        viewModel = nil
        locationManager = nil
        try super.tearDownWithError()
    }

    func testExample() throws {
       
    }
    
    func testGetCurrentWeatherDataNotNil(){
        MyLocationManager.shared.getUserLocation { location in
            self.viewModel?.fetchCurrentWeather(latitude: "\(location.coordinate.latitude)", longitude: "\(location.coordinate.longitude)")
        }
        self.viewModel?.eventHandler = { event in
            XCTAssertNotNil(event)
            
        }
    }
    
    func testGetCurrentWeatherDataIsNil(){
        MyLocationManager.shared.getUserLocation { location in
            self.viewModel?.fetchCurrentWeather(latitude: "\(location.coordinate.latitude)", longitude: "\(location.coordinate.longitude)")
        }
        
        self.viewModel?.eventHandler = { event in
            XCTAssertNotNil(event)
            
        }
    }

    func testPerformanceExample() throws {
        self.measure {
        }
    }

}
