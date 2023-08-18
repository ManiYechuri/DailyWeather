//
//  APIManager.swift
//  DailyWeather
//
//  Created by Mani Yechuri on 2023/08/18.
//

import Foundation
import UIKit

class APIManager {
    
    static let shared = APIManager()
    init(){}
    
    func getWeatherData<T : Decodable >(urlString : String ,latitude : String,longitude : String,type : T.Type ,completion : @escaping (Result<T,DataError>) -> Void) {
        guard let url = URL(string: urlString + "lat=\(latitude)&lon=\(longitude)&appid=\(Constant.APPID.appId)") else {
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data, error == nil else {
                return
            }
            guard let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode else {
                return
            }
            do {
                let currentWeather = try JSONDecoder().decode(T.self, from: data)
                completion(.success(currentWeather))
            }catch {
                completion(.failure(.network(error)))
            }
        }.resume()
    }
}
