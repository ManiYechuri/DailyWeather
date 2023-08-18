//
//  WeatherTableCell.swift
//  DailyWeather
//
//  Created by Mani Yechuri on 2023/08/18.
//

import UIKit

class WeatherTableCell: UITableViewCell {

    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var labelTemperature: UILabel!
    @IBOutlet weak var labelWeekDay: UILabel!
    
    var weatherData : DisplayForecastData? {
        didSet {
            weatherDetailConfiguration()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func weatherDetailConfiguration(){
        guard let weatherData else {return}
        weatherIcon.image = UIImage(named: weatherData.image)
        labelTemperature.text = weatherData.degree
        labelWeekDay.text = weatherData.weekday
    }
}
