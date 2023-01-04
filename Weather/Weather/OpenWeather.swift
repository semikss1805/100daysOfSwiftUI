//
//  OpenWeather.swift
//  Weather
//
//  Created by SemikSS on 04.01.2023.
//

import Foundation
import Moya

public enum OpenWeather {
    static private var appid = "a89922672677afc87a54a586fa01e9e6"
    
    case weather(lat: Double, lon: Double, date: Int)
}

extension OpenWeather: TargetType {
    public var baseURL: URL {
        return URL(string: "https://api.openweathermap.org")!
    }
    
    public var path: String {
        switch self {
        case .weather(lat: _, lon: _ , date: _):
            return "/data/2.5/weather"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .weather(lat: _, lon: _, date: _):
            return .get
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self{
        case .weather(lat: let lat, lon: let lon, date: let date):
            return .requestParameters(
                parameters: [
                    "APPID": OpenWeather.appid,
                    "dt": date,
                    "lat": lat,
                    "lon": lon,
                    "units": "metric"],
                encoding: URLEncoding.default)
        }
    }
    
    public var headers: [String : String]? {
        return ["Content-Type": "application/json", "APPID": "\(OpenWeather.appid)"]
    }
    
}
