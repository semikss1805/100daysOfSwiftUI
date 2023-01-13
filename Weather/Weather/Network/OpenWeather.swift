//
//  OpenWeather.swift
//  Weather
//
//  Created by SemikSS on 04.01.2023.
//

import Foundation
import Moya
import SwiftUI

public enum OpenWeather {
    static private var appid = "a89922672677afc87a54a586fa01e9e6"
    
    case forecast(lat: Double, lon: Double)
    
    case current(lat: Double, lon: Double)
}

struct Constant {
    static let baseURL = "https://api.openweathermap.org"
}

enum Endpoint: String {
    case forecast = ""
    // ...
}

extension OpenWeather: TargetType {
    public var baseURL: URL {
        return URL(string: Constant.baseURL)!
    }
    
    public var path: String {
        switch self {
        case .forecast:
            return "/data/2.5/forecast"
            
        case .current:
            return "/data/2.5/weather"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .forecast, .current:
            return .get
        }
    }
    
    public var task: Task {
        switch self {
        case .forecast(lat: let lat, lon: let lon), .current(lat: let lat, lon: let lon):
            return .requestParameters(
                parameters: [
                    "APPID": OpenWeather.appid,
                    "lat": lat,
                    "lon": lon,
                    "units": "metric"],
                encoding: URLEncoding.default)}
    }
    
    enum RequestParamsKey: String {
        case appID = ""
        // ...
    }
    
    public var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
