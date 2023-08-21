//
//  WeatherViewController.swift
//  DailyWeather
//
//  Created by Mani Yechuri on 2023/08/18.
//

import UIKit
import MapKit

class WeatherViewController: UIViewController {

    @IBOutlet weak var locationView : UIView!
    @IBOutlet weak var settingaButton : UIButton!
    @IBOutlet weak var currentWeatherView : UIView!
    @IBOutlet weak var forecastTableView : UITableView!
    @IBOutlet weak var labelTemperature: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var labelWeekDay: UILabel!
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var labelMaximumTemperature: UILabel!
    @IBOutlet weak var labelMinimumTemperature: UILabel!
    @IBOutlet weak var labelCurrentTemperature: UILabel!
    private let currentWeatherViewModel = CurrentWeatherViewModel()
    private let forecastWeatherViewModel = ForecastWeatherViewModel()
    var weatherData = [DisplayForecastData]()
    let currentWeather : CurrentWeatherData? = nil
    let locationManager = MyLocationManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationView.isHidden = true
        self.currentWeatherView.isHidden = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configuration()
        setNeedsStatusBarAppearanceUpdate()
    }
    
    @IBAction func goToSettings(sender:UIButton){
        if let appSettingsURL = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(appSettingsURL, options: [:], completionHandler: nil)
        }
    }
}

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

extension WeatherViewController {
    func configuration(){
        forecastTableView.register(UINib(nibName: "WeatherTableCell", bundle: nil), forCellReuseIdentifier: "WeatherTableCell")
        forecastTableView.delegate = self
        forecastTableView.dataSource = self
        forecastTableView.reloadData()
        initViewModel()
        observeEvent()
        customizeWeatherView()
    }
    
    func initViewModel(){
        if NetworkMonitor.shared.isConnected {
            locationManager.onPermissionUpdate { [weak self]status in
                self?.checkLocationAuthorization(status)
            }
        }else {
            Helper.shared.showInternetError(title: "No Internet", message: "Please make sure you have active internet connection", viewController: self)
        }
    }
    
    func customizeWeatherView(){
        currentWeatherView.layer.shadowColor = UIColor.black.cgColor
        currentWeatherView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        currentWeatherView.layer.shadowOpacity = 0.3
        currentWeatherView.layer.shadowRadius = 10.0
        currentWeatherView.layer.cornerRadius = 20.0
        currentWeatherView.layer.masksToBounds = false
    }
    
    func checkLocationAuthorization(_ status : CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            self.locationView.isHidden = true
            self.currentWeatherView.isHidden = false
            locationManager.getUserLocation { [weak self] location in
                self?.currentWeatherViewModel.fetchCurrentWeather(latitude: "\(location.coordinate.latitude)", longitude: "\(location.coordinate.longitude)")
                location.fetchCity { city, error in
                    self?.labelLocation.text = city ?? ""
                }
            }
        case .denied, .restricted:
            self.locationView.isHidden = false
            self.currentWeatherView.isHidden = true
        case .notDetermined:
            MyLocationManager.shared.locationManager.requestWhenInUseAuthorization()
        @unknown default:
            fatalError("Unknown authorization status")
        }
    }
    
    func initForecastWeatherModel() {
        if NetworkMonitor.shared.isConnected {
            locationManager.getUserLocation { [weak self] location in
                self?.forecastWeatherViewModel.fetchForecastWeatherData(latitude: "\(location.coordinate.latitude)", longitude: "\(location.coordinate.longitude)")
            }
        }else {
            Helper.shared.showInternetError(title: "No Internet", message: "Please make sure you have active internet connection", viewController: self)
        }
    }
    
    func observeEvent(){
        currentWeatherViewModel.eventHandler = {[weak self] event in
            guard let self else {return}
            switch event {
            case .stopLoading : break
            case .loading : break
            case .dataLoaded :
                guard let weatherData = self.currentWeatherViewModel.currentWeather else {return}
                self.updateWeatherUI(currentWeather: weatherData)
                self.initForecastWeatherModel()
                self.observeForecastEvents()
            case .error(let error):
                debugPrint("Error while fetching forecast Weather : \(String(describing: error))")
            }
        }
    }
    
    func observeForecastEvents(){
        lazy var imageString = ""
        lazy var weatherCondition = ""
        forecastWeatherViewModel.eventHandler = {[weak self] event in
            guard let self else {return}
            switch event {
            case .stopLoading : break
            case .loading : break
            case .dataLoaded :
                locationManager.locationManager.stopUpdatingLocation()
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
            self.labelMaximumTemperature.text = "Max :" + Helper.shared.convertKelvinToCelsius(temp: currentWeather.main?.temp_max ?? 0.0, from: .kelvin, to: .celsius)
            self.labelMinimumTemperature.text = "Min : " + Helper.shared.convertKelvinToCelsius(temp: currentWeather.main?.temp_min ?? 0.0, from: .kelvin, to: .celsius)
            self.labelWeekDay.text = Helper.shared.getWeekdayFromDate(Date(timeIntervalSince1970: TimeInterval(currentWeather.dt))) + " at " + Date.getCurrentDate()
        }
    }
}
