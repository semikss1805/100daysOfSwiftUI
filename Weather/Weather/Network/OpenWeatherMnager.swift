//
//  OpenWeatherMnager.swift
//  Weather
//
//  Created by SemikSS on 13.01.2023.
//

import Foundation
import Moya
import SwiftUI

final class OpenWeatherManager: ObservableObject {
    private var provider = MoyaProvider<OpenWeather>(plugins: [NetworkLoggerPlugin()])
    
    private var locationManager = LocationManager.shared
    
    private var weatherDataManager = WeatherDataManager()
    
    @Published var isUpdatingCompleted = false
    
    struct ForecastResponse: Codable {
        let list: [HourlyResponse]
    }
    
    struct HourlyResponse: Codable {
        let dt: Int
        let weather: [Weather]
    }
    
    struct CurrentResponse: Codable {
        let name: String
        let dt: Int
        let weather: [Weather]
    }
    
    struct Weather: Codable {
        let main: String
    }
    
    static var shared = OpenWeatherManager()
    
    private init() { }
    
    private func saveDataFromCurrentWeatherResponse() {
        guard let lat = locationManager.userLocation?.coordinate.latitude,
              let lon = locationManager.userLocation?.coordinate.longitude
        else {
            debugPrint("invalid location")
            return
        }
        
        provider.request(.current(lat: lat, lon: lon)) { result in
            switch result {
            case .success(let response):
                do {
                    let currentResponse = try response.map(CurrentResponse.self)
                    
                    self.weatherDataManager.saveCurrentWeather(currentResponse: currentResponse)
                } catch {
                    debugPrint("fail to map")
                }
            case .failure(let error):
                debugPrint(error.errorDescription ?? "Unknown error")
            }
        }
    }

    private func saveDataFromWeatherForecastResponse() {
        guard let lat = locationManager.userLocation?.coordinate.latitude,
              let lon = locationManager.userLocation?.coordinate.longitude
        else {
            debugPrint("invalid location")
            return
        }
        
        provider.request(.forecast(lat: lat, lon: lon)) { result in
            switch result {
            case .success(let response):
                do {
                    let forecastResponse = try response.map(ForecastResponse.self)
                    
                    self.weatherDataManager.saveWeatherForecast(forecastResponse: forecastResponse)
                    
                    withAnimation(.default) {
                        self.isUpdatingCompleted = true
                    }
                } catch {
                    debugPrint("fail to map")
                }
            case .failure(let error):
                debugPrint(error.errorDescription ?? "Unknown error")
            }
        }
    }
    
    func updateLocalWeatherData() {
        saveDataFromCurrentWeatherResponse()
        saveDataFromWeatherForecastResponse()
    }
}
