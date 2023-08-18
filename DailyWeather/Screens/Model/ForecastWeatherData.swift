//
//  ForecastWeatherData.swift
//  DailyWeather
//
//  Created by Mani Yechuri on 2023/08/18.
//

import Foundation


struct ForecastWeatherData : Decodable {
    var cod : String
    var message : Int
    var cnt : Int
    var list : [List]
    var city : City
}

struct List : Decodable {
    var dt : TimeInterval
    var weather : [Weather]
    var main : Main
    var clouds : Clouds
    var wind : Wind
    var dt_txt : String
    var visibility : Int
    var pop : Float
}

struct City : Decodable {
    var name : String
    var coord : Coordinates
    var country : String?
    var population, timezone, sunrise, sunset, id : Int
}

struct DisplayForecastData : Hashable {
    
    var weekday,image, degree,location : String
    var date : Date
    var minDegree, maxDegree, feelsLike, weatherCondition : String
    var humidity, pressure : Int
    var windSpeed : Double
}

