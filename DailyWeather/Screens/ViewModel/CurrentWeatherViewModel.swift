//
//  CurrentWeatherViewModel.swift
//  DailyWeather
//
//  Created by Mani Yechuri on 2023/08/18.
//

import Foundation
final class CurrentWeatherViewModel {
        
    var currentWeather : CurrentWeatherData?
    var forecastWeatherData : ForecastWeatherData?
    var eventHandler : ((_ event : Event) -> Void)?
    
    
    func fetchCurrentWeather(latitude: String, longitude: String){
        APIManager.shared.getWeatherData(urlString: Constant.API.currentWeatherAPI, latitude: latitude, longitude: longitude, type: CurrentWeatherData.self) { response in
            self.eventHandler?(.loading)
            switch response {
            case .success(let weather):
                self.currentWeather = weather
                self.eventHandler?(.dataLoaded)
            case .failure(let error):
                self.eventHandler?(.error(error))
            }
        }
    }
}
