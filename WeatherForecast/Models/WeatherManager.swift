//
//  WeatherData.swift
//  WeatherForecast
//
//  Created by Zayan Tharani on 20/08/2020.
//  Copyright © 2020 folio3. All rights reserved.
//

import Foundation
import Alamofire
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeatherData(_ weatherManager: WeatherManager,_ weather: WeatherModel)
    func didFailWithError(_ weatherManager: WeatherManager, _ error: Error)
}

struct WeatherManager {
    var delegate: WeatherManagerDelegate?
    
    let baseUrl = "https://api.openweathermap.org/data/2.5/weather?units=metric&appid=9f85a5802437960dd541b4fa6e275bdd"
    
    func fetchCityName(cityName: String) {
        let url = "\(baseUrl)&q=\(cityName)"
        performGetRequest(url)
    }
    
    func fetchCityNameFromLocation(_ location: CLLocation) {
        let url = "\(baseUrl)&lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)"
        performGetRequest(url)
    }
    
    func performGetRequest(_ url: String) {
        
        AF.request(url).responseData { (response) in
            switch response.result {
                
            case .success(_):
                if let json = response.value {
                    if let weatherData = self.parseJSON(json: json) {
                        self.delegate?.didUpdateWeatherData(self, weatherData)
                    }
                }
            case .failure(let error):
                print("There is an error \(error)")
                self.delegate?.didFailWithError(self, error)
            }
            
        }
        
        
        
    }
    
    func parseJSON(json: Data) -> WeatherModel? {
        
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: json)
            
            let weather = WeatherModel(cityName: decodedData.name, conditionId: decodedData.weather[0].id, temp: decodedData.main.temp, feels_like: decodedData.main.feels_like, description: decodedData.weather[0].description)
            
            return weather
           
        }
        catch {
            self.delegate?.didFailWithError(self, error)

            return nil
        }
    }
    
   
    
    
}
