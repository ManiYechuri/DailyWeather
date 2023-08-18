//
//  ForecastWeatherViewModel.swift
//  DailyWeather
//
//  Created by Mani Yechuri on 2023/08/18.
//

import Foundation

final class ForecastWeatherViewModel {
    
    var forecastWeatherData : ForecastWeatherData?
    var eventHandler : ((_ event : Event) -> Void)?
    
    func fetchForecastWeatherData(latitude: String, longitude: String){
        APIManager.shared.getWeatherData(urlString: Constant.API.forecastWeatherAPI, latitude: latitude, longitude: longitude, type: ForecastWeatherData.self) { response in
            self.eventHandler?(.loading)
            switch response {
            case .success(let weather):
                self.forecastWeatherData = weather
                self.eventHandler?(.dataLoaded)
            case .failure(let error):
                self.eventHandler?(.error(error))
            }
        }
    }
}
