//
//  OpenWeatherManager.swift
//  WeatherUIKit
//
//  Created by Denys Polishchuk on 30.01.2023.
//

import Foundation
import Moya
import CoreLocation

final class OpenWeatherManager {
    private var provider = MoyaProvider<OpenWeather>(plugins: [NetworkLoggerPlugin()])
    
    private var locationManager = LocationManager.shared
    
    struct ForecastResponse: Codable {
        let list: [HourlyResponse]
    }
    
    struct HourlyResponse: Codable {
        let main: Temp
        let dt: Int
        let weather: [Weather]
    }
    
    struct Temp: Codable {
        let temp: Double
        let feels_like: Double
        let temp_min: Double
        let temp_max: Double
    }
    
    struct CurrentResponse: Codable {
        let name: String
        let dt: Int
        let weather: [Weather]
    }
    
    struct Weather: Codable {
        let main: String
    }
    
    init() { }
    
    func getCurrentResponse() async throws -> CurrentResponse {
        let coordinates = try getCoordinates()
        
        let result: CurrentResponse = try await withCheckedThrowingContinuation({ continuation in
            provider.request(.current(lat: coordinates.lat, lon: coordinates.lon)) { result in
                switch result {
                case .success(let response):
                    do {
                        let currentResponse = try response.map(CurrentResponse.self)
                        continuation.resume(returning: currentResponse)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        })
        
        return result
    }

    func getForecastResponse() async throws -> ForecastResponse {
        let coordinates = try getCoordinates()
        
        let result: ForecastResponse = try await withCheckedThrowingContinuation({ continuation in
            provider.request(.forecast(lat: coordinates.lat, lon: coordinates.lon)) { result in
                switch result {
                case .success(let response):
                    do {
                        let forecastResponse = try response.map(ForecastResponse.self)
                        continuation.resume(returning: forecastResponse)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        })
        
        return result
    }
    
    private func getCoordinates() throws -> (lat: Double, lon: Double) {
        guard let lat = locationManager.userLocation?.coordinate.latitude,
              let lon = locationManager.userLocation?.coordinate.longitude
        else {
            throw CLError(.locationUnknown)
        }
        
        return (lat, lon)
    }
}
