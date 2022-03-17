//
//  WeatherData.swift
//  WeatherForecast
//
//  Created by Zayan Tharani on 20/08/2020.
//  Copyright © 2020 folio3. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let weather: [Weather]
    let main: Main
}

struct Weather: Codable {
    let id: Int
    let description: String
}

struct Main: Codable {
    let temp: Double
    let feels_like: Double
}
