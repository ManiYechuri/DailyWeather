//
//  WeatherViewController+Extension.swift
//  DailyWeather
//
//  Created by Mani Yechuri on 2023/08/21.
//

import UIKit

extension WeatherViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = forecastTableView.dequeueReusableCell(withIdentifier: "WeatherTableCell", for: indexPath) as! WeatherTableCell
        cell.weatherData = weatherData[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let weatherDetailScreen = self.storyboard?.instantiateViewController(withIdentifier: "WeatherDetailsViewController") as? WeatherDetailsViewController else { return }
        weatherDetailScreen.forecastWeatherData = weatherData[indexPath.row]
        weatherDetailScreen.modalTransitionStyle = .coverVertical
        weatherDetailScreen.modalPresentationStyle = .fullScreen
        self.present(weatherDetailScreen, animated: true)
    }
}
