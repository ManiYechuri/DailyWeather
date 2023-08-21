//
//  LocationManager.swift
//  DailyWeather
//
//  Created by Mani Yechuri on 2023/08/18.
//

import CoreLocation
import UIKit

typealias LocationPermissionClosure = (CLAuthorizationStatus) -> Void

class MyLocationManager : NSObject{
    
    static let shared = MyLocationManager()
    let locationManager = CLLocationManager()
    var completion : ((CLLocation) -> Void)?
    var permissionUpdateClosure : LocationPermissionClosure?
    
    override init() {
        super.init()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    public func getUserLocation(completion: @escaping (CLLocation) -> Void){
        self.completion = completion
    }
    
    public func onPermissionUpdate(_ closure : @escaping LocationPermissionClosure){
        permissionUpdateClosure = closure
    }
}

extension MyLocationManager : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        completion?(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        permissionUpdateClosure?(status)
    }
}

extension CLLocation {
    func fetchCity(completion: @escaping (_ city: String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality, $1) }
    }
}
