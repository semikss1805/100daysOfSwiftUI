//
//  ContentView.swift
//  Weather
//
//  Created by SemikSS on 03.01.2023.
//

import SwiftUI
import CoreData
import Moya

struct ContentView: View {
    var provider = MoyaProvider<OpenWeather>(plugins: [NetworkLoggerPlugin()])
    
    struct SumResponse: Codable {
        let name: String
        var dt: Int
        let weather: [Weather]
    }
    
    struct Weather: Codable {
        let main: String
    }
    
    @State private var sumResponse = [SumResponse]()
    
    
    @ObservedObject var locationManager = LocationManager.shared

    var body: some View {
        Group {
            if locationManager.userLocation == nil {
                LocationRequestView()
            } else {
                Text("\(locationManager.userLocation!)")
                    .padding()
                    .onAppear {
                        print(locationManager.userLocation!.coordinate)
                    }
                
                Button("send request") {
                    start()
                }
                
                if sumResponse.first != nil {
                    Text("""
                         \(sumResponse[0].name)
                         \(sumResponse[0].weather[0].main)
                         \(NSDate(timeIntervalSince1970: TimeInterval(sumResponse[0].dt)))
                         """)
                }
            }
        }
    }
    
    private func start() {
        let dateInSec = Int(Date.now.timeIntervalSince1970)
        
        provider.request(.weather(lat: locationManager.userLocation!.coordinate.latitude,
                                  lon: locationManager.userLocation!.coordinate.longitude,
                                  date: dateInSec - 86400)) { result in
            switch result {
                case .success(let response):
                do {
                    print(try response.mapJSON())
                    print(NSDate(timeIntervalSince1970: TimeInterval(dateInSec - 86400)))
                    sumResponse.append(try response.map(SumResponse.self))
                    print(sumResponse)
                } catch {
                    print ("fail to map")
                }
                case .failure(let error):
                    print(error.errorDescription ?? "Unknown error")
                }
        }
    }
}
