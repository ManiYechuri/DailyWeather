//
//  CurrentWeatherData.swift
//  DailyWeather
//
//  Created by Mani Yechuri on 2023/08/18.
//

import Foundation

struct CurrentWeatherData : Codable {
    var coord : Coordinates?
    var weather : [Weather]?
    var base,name : String
    var main : Main?
    var wind : Wind?
    var clouds : Clouds?
    var dt,timezone,id,cod,visibility : Int
    var sys : System?
}

struct Coordinates : Codable {
    var lon, lat : Double
}

struct Weather : Codable {
    var id : Int
    var main, description, icon  : String
}

struct Main : Codable {
    var temp,feels_like,temp_min,temp_max : Double
    var pressure, humidity : Int
}

struct Wind : Codable {
    var speed : Double
    var deg : Int
    var gust : Double?
}
struct Clouds : Codable {
    var all : Int
}

struct System : Codable {
    var country : String
    var sunrise,sunset : Int
}
