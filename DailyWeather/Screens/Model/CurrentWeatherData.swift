//
//  CurrentWeatherData.swift
//  DailyWeather
//
//  Created by Mani Yechuri on 2023/08/18.
//

import Foundation
struct CurrentWeatherData : Decodable {
    var coord : Coordinates?
    var weather : [Weather]?
    var base,name : String
    var main : Main?
    var wind : Wind?
    var clouds : Clouds?
    var dt,timezone,id,cod,visibility : Int
    var sys : System?
}

struct Coordinates : Decodable {
    var lon, lat : Double
}

struct Weather : Decodable {
    var id : Int
    var main, description, icon  : String
}

struct Main : Decodable {
    var temp,feels_like,temp_min,temp_max : Double
    var pressure, humidity : Int
}

struct Wind : Decodable {
    var speed : Double
    var deg : Int
    var gust : Double?
}
struct Clouds : Decodable {
    var all : Int
}

struct System : Decodable {
    var country : String
    var sunrise,sunset : Int
}
