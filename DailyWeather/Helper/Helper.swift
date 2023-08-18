//
//  Helper.swift
//  DailyWeather
//
//  Created by Mani Yechuri on 2023/08/18.
//

import UIKit

class Helper {
    
    static let shared = Helper()
    private init(){}
    
    func getWeekdayFromDate(_ date: Date) -> String {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.weekdaySymbols[weekday - 1]
    }
    
    func convertStringToDate(dateString : String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.date(from:dateString)!
    }
    
    func convertKelvinToCelsius(temp : Double, from inputTempType: UnitTemperature, to outputTempType : UnitTemperature) -> String {
        let mf = MeasurementFormatter()
        mf.numberFormatter.maximumFractionDigits = 0
        mf.unitOptions = .providedUnit
        let input = Measurement(value: temp, unit: inputTempType)
        let output = input.converted(to: outputTempType)
        return mf.string(from: output)
    }
    
    func getAppDelegate() -> AppDelegate {
        DispatchQueue.main.sync {
            return UIApplication.shared.delegate as! AppDelegate
        }
    }
}

extension UIColor {
    
    static let SunnyColor = UIColor(rgb: 0x4a90e2)
    static let CloudyColor = UIColor(rgb: 0x628594)
    static let RainyColor = UIColor(rgb: 0x56555c)
    
    
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")
       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }
   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}
