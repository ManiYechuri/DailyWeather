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
    let currentWeatherViewModel = CurrentWeatherViewModel()
    let forecastWeatherViewModel = ForecastWeatherViewModel()
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
}
