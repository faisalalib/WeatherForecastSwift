//
//  WeatherModel.swift
//  WeatherForecast
//
//  Created by Zayan Tharani on 20/08/2020.
//  Copyright © 2020 folio3. All rights reserved.
//

import Foundation

struct WeatherModel {
    let cityName: String
    let conditionId: Int
    let temp: Double
    let feels_like: Double
    let description: String
    
    var tempString: String {
        return String(format: "%.1f", temp)
    }
    
    var feelsLikeString: String {
        return String(format: "%.1f", feels_like)
    }
    
    var conditionName: String {
        switch conditionId {
            case 200...232:
                return "cloud.bolt"
            case 300...321:
                return "cloud.drizzle"
            case 500...531:
                return "cloud.rain"
            case 600...622:
                return "cloud.snow"
            case 701...781:
                return "cloud.fog"
            case 800:
                return "sun.max"
            case 801...804:
                return "cloud.bolt"
            default:
                return "cloud"
        }
    }
     
}
