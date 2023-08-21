//
//  WeatherViewController+Location.swift
//  DailyWeather
//
//  Created by Mani Yechuri on 2023/08/21.
//

import UIKit
import MapKit

extension WeatherViewController {
    
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
}
