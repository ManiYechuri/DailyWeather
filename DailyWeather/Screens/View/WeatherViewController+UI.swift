//
//  WeatherViewController+UI.swift
//  DailyWeather
//
//  Created by Mani Yechuri on 2023/08/21.
//

import UIKit

extension WeatherViewController {
    func observeForecastEvents(){
        lazy var imageString = ""
        lazy var weatherCondition = ""
        forecastWeatherViewModel.eventHandler = {[weak self] event in
            guard let self else {return}
            switch event {
            case .stopLoading : break
            case .loading : break
            case .dataLoaded :
                self.locationManager.locationManager.stopUpdatingLocation()
                guard let weatherData = self.forecastWeatherViewModel.forecastWeatherData else {return}
                DispatchQueue.main.async {
                    self.weatherData.removeAll()
                    for data in weatherData.list {
                        for climate in data.weather {
                            if climate.main == WeatherCondition.Clouds.rawValue {
                                imageString = "icon_cloudy"
                                weatherCondition = WeatherCondition.Clouds.rawValue
                            }else if climate.main == WeatherCondition.Clear.rawValue {
                                imageString = "icon_sunny"
                                weatherCondition = WeatherCondition.Clear.rawValue
                            }else if climate.main == WeatherCondition.Rain.rawValue {
                                imageString = "icon_rainy"
                                weatherCondition = WeatherCondition.Rain.rawValue
                            }
                        }
                        let weekday = Helper.shared.getWeekdayFromDate(Date(timeIntervalSince1970: data.dt))
                        let date = Helper.shared.convertStringToDate(dateString: data.dt_txt)
                        self.weatherData.append(DisplayForecastData(weekday: weekday, image: imageString, degree: Helper.shared.convertKelvinToCelsius(temp: data.main.temp, from: .kelvin, to: .celsius), location: self.labelLocation.text ?? "", date: date, minDegree: Helper.shared.convertKelvinToCelsius(temp: data.main.temp_min, from: .kelvin, to: .celsius), maxDegree: Helper.shared.convertKelvinToCelsius(temp: data.main.temp_max, from: .kelvin, to: .celsius), feelsLike: Helper.shared.convertKelvinToCelsius(temp: data.main.feels_like, from: .kelvin, to: .celsius),  weatherCondition: weatherCondition, humidity: data.main.humidity, pressure: data.main.pressure, windSpeed: data.wind.speed))
                    }
                    self.forecastTableView.reloadData()
                }
            case .error(let error):
                debugPrint("Error while fetching forecast Weather : \(String(describing: error))")
            }
        }
    }
    
    func updateWeatherUI(currentWeather : CurrentWeatherData){
        DispatchQueue.main.async {
            guard let mainWeather = currentWeather.weather else {return}
            if mainWeather[0].main == WeatherCondition.Clouds.rawValue {
                self.weatherImage.image = UIImage(named: "Cloudy")
                self.weatherIcon.image = UIImage(named: "icon_cloudy")
                self.labelTemperature.text = WeatherCondition.Clouds.rawValue
            }else if mainWeather[0].main == WeatherCondition.Rain.rawValue {
                self.weatherImage.image = UIImage(named: "Rain")
                self.weatherIcon.image = UIImage(named: "icon_rainy")
                self.labelTemperature.text = WeatherCondition.Rain.rawValue
            }else if mainWeather[0].main == WeatherCondition.Clear.rawValue {
                self.weatherImage.image = UIImage(named: "Sunny")
                self.weatherIcon.image = UIImage(named: "icon_sunny")
                self.labelTemperature.text = WeatherCondition.Clear.rawValue
            }
            self.labelCurrentTemperature.text = Helper.shared.convertKelvinToCelsius(temp: currentWeather.main?.temp ?? 0.0, from: .kelvin, to: .celsius)
            self.labelMaximumTemperature.text = "Max : " + Helper.shared.convertKelvinToCelsius(temp: currentWeather.main?.temp_max ?? 0.0, from: .kelvin, to: .celsius)
            self.labelMinimumTemperature.text = "Min : " + Helper.shared.convertKelvinToCelsius(temp: currentWeather.main?.temp_min ?? 0.0, from: .kelvin, to: .celsius)
            self.labelWeekDay.text = Helper.shared.getWeekdayFromDate(Date(timeIntervalSince1970: TimeInterval(currentWeather.dt))) + " at " + Date.getCurrentDate()
        }
    }
}
