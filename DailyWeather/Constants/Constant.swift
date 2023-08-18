//
//  Constant.swift
//  DailyWeather
//
//  Created by Mani Yechuri on 2023/08/18.
//

import Foundation

enum Constant {
    enum API {
        static let baseURL = "https://api.openweathermap.org/data/2.5/"
        static let currentWeatherAPI = baseURL + "weather?"
        static let forecastWeatherAPI = baseURL + "forecast?"
    }
    enum APPID {
        static let appId = "95d5a919db52edcd4fb0aecad3d04872"
    }
}
