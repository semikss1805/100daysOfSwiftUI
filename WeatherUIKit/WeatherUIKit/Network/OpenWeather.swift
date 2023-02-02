//
//  OpenWeather.swift
//  WeatherUIKit
//
//  Created by Denys Polishchuk on 30.01.2023.
//

import Foundation
import Moya
import SwiftUI

enum OpenWeather {
    static private var appid = "a89922672677afc87a54a586fa01e9e6"
    
    case forecast(lat: Double, lon: Double)
    
    case current(lat: Double, lon: Double)
}

struct Constant {
    static let baseURL = "https://api.openweathermap.org"
}

extension OpenWeather: TargetType {
    var baseURL: URL {
        return URL(string: Constant.baseURL)!
    }
    
    var path: String {
        switch self {
        case .forecast:
            return "/data/2.5/forecast"
            
        case .current:
            return "/data/2.5/weather"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .forecast, .current:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .forecast(lat: let lat, lon: let lon), .current(lat: let lat, lon: let lon):
            return .requestParameters(
                parameters: [
                    RequestParamsKey.APPID.rawValue: OpenWeather.appid,
                    RequestParamsKey.lat.rawValue: lat,
                    RequestParamsKey.lon.rawValue: lon,
                    RequestParamsKey.units.rawValue: "metric"],
                encoding: URLEncoding.default)}
    }
    
    enum RequestParamsKey: String {
        case APPID
        case lat
        case lon
        case units
        // ...
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
