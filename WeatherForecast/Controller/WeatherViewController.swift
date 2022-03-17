//
//  ViewController.swift
//  WeatherForecast
//
//  Created by Zayan Tharani on 20/08/2020.
//  Copyright © 2020 folio3. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    enum tempUnit: Int {
        case cent = 0
        case farhen = 1
    }
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var temperatureUnitLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UISearchBar!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var feelsLikeUnit: UILabel!
    
    private var weatherData =  WeatherManager()
    private let location = CLLocationManager()
    private var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        location.delegate = self
        location.requestWhenInUseAuthorization()
        location.requestLocation()
        location.startUpdatingLocation() //Incase of continuous location requests
        searchTextField.delegate = self
        weatherData.delegate = self
      
        
    }
    
    @IBAction func changeUnits(_ sender: UISegmentedControl) {
        
        var tempConvert: Float
        var tempConvert2: Float
        let currentTempUnit = sender.selectedSegmentIndex
        
        if let t1 = temperatureLabel.text, let t2 = feelsLikeLabel.text {
            
            tempConvert = Float(t1) ?? 0.0
            tempConvert2 = Float(t2) ?? 0.0
            
            if (currentTempUnit == tempUnit.farhen.rawValue){
                tempConvert = tempConvert * (9/5) + 32
                tempConvert2 = tempConvert2 * (9/5) + 32
            } else {
                tempConvert = (tempConvert - 32) * (5/9)
                tempConvert2 = (tempConvert2 - 32) * (5/9)
            }
            
            updateUI(convertedTemp1: tempConvert, convertedTemp2: tempConvert2, unit: currentTempUnit)
        }
    }
    
    func updateUI(convertedTemp1: Float, convertedTemp2: Float, unit: Int){
        
        temperatureLabel.text = String(format: "%.1f", convertedTemp1)
        feelsLikeLabel.text = String(format: "%.1f", convertedTemp2)
        
        if (unit == tempUnit.cent.rawValue) {
            temperatureUnitLabel.text = "C"
            feelsLikeUnit.text = "C"
        } else {
            temperatureUnitLabel.text = "F"
            feelsLikeUnit.text = "F"
        }
        
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        
        searchTextField.endEditing(true)
        
    }
    
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        if let location = currentLocation {
            weatherData.fetchCityNameFromLocation(location)

        }
    }
    @IBAction func changeThemePressed(_ sender: UIButton) {
        print("Pressed")
        
        if (overrideUserInterfaceStyle == .light) {
            overrideUserInterfaceStyle = .dark

        }
        else {
            overrideUserInterfaceStyle = .light
        }
    }
}

//MARK: SearchBar

extension WeatherViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchTextField.endEditing(true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("Calling API")
        weatherData.fetchCityName(cityName: searchBar.text!)
        searchTextField.text = ""
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        if (searchBar.text != "") {
            return true
        }
        searchBar.placeholder = "City name is required"
        return false
    }
}

//MARK: WeatherDataAndAPIs
extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateWeatherData(_ weatherManager: WeatherManager,_ weather: WeatherModel) {
        
        print(weather.conditionName)
        
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.tempString
            self.feelsLikeLabel.text = weather.feelsLikeString
            self.cityLabel.text = weather.cityName
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.weatherDescription.text = weather.description
        }
        
    }
    
    func didFailWithError(_ weatherManager: WeatherManager, _ error: Error) {
        print("There was an error at \(error)")
    }
}

//MARK: LoctionManager

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            currentLocation = location
            print("Latitude \(location.coordinate.latitude)")
            print("Longitude \(location.coordinate.longitude)")

        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}



