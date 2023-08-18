//
//  WeatherDetailsViewController.swift
//  DailyWeather
//
//  Created by Mani Yechuri on 2023/08/18.
//

import UIKit

class WeatherDetailsViewController: UIViewController {
    
    var forecastWeatherData : DisplayForecastData?

    @IBOutlet weak var labelWind: UILabel!
    @IBOutlet weak var labelSunset: UILabel!
    @IBOutlet weak var labelHumidity: UILabel!
    @IBOutlet weak var labelFeelsLike: UILabel!
    @IBOutlet weak var labelAverageTemperature: UILabel!
    @IBOutlet weak var labelWeatherCondition: UILabel!
    @IBOutlet weak var labelCurrentTemperature: UILabel!
    @IBOutlet weak var labelLocation: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.labelLocation.text = forecastWeatherData?.location
        self.labelWeatherCondition.text = forecastWeatherData?.weatherCondition
        self.labelCurrentTemperature.text = forecastWeatherData?.degree
        self.labelAverageTemperature.text = "Min : \(forecastWeatherData?.minDegree ?? "")  " + "Max : \(forecastWeatherData?.maxDegree ?? "") "
        self.labelFeelsLike.text = forecastWeatherData?.feelsLike
        self.labelHumidity.text = "\(forecastWeatherData?.humidity ?? 0)%"
        self.labelWind.text = "\(forecastWeatherData?.windSpeed ?? 0.0) meters/sec"
        self.labelSunset.text = "\(forecastWeatherData?.pressure ?? 0) hPa"
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    @IBAction func goBack(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
