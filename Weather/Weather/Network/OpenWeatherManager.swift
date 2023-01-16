//
//  OpenWeatherManager.swift
//  Weather
//
//  Created by SemikSS on 13.01.2023.
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
        guard let lat = locationManager.userLocation?.coordinate.latitude,
              let lon = locationManager.userLocation?.coordinate.longitude
        else {
            throw CLError(.locationUnknown)
        }
        
        let result: CurrentResponse = try await withCheckedThrowingContinuation({ continuation in
            provider.request(.current(lat: lat, lon: lon)) { result in
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
        guard let lat = locationManager.userLocation?.coordinate.latitude,
              let lon = locationManager.userLocation?.coordinate.longitude
        else {
            throw CLError(.locationUnknown)
        }
        
        let result: ForecastResponse = try await withCheckedThrowingContinuation({ continuation in
            provider.request(.forecast(lat: lat, lon: lon)) { result in
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
        
//        debugPrint(result)
        
        return result
    }
}
