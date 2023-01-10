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
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(entity: CurrentWeather.entity(),
                  sortDescriptors: [],
                  animation: .default
    ) var currentWeather: FetchedResults<CurrentWeather>
    
    @FetchRequest(entity: WeatherForecast.entity(),
                  sortDescriptors: [],
                  animation: .default
    ) var weatherForecast: FetchedResults<WeatherForecast>
    
    @State private var forecast = [Forecast]()
    
    struct Forecast {
        let dt: String
        let weather: String
    }
    
    var provider = MoyaProvider<OpenWeather>(plugins: [NetworkLoggerPlugin()])
    
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
    
    @ObservedObject var locationManager = LocationManager.shared
    
    @State private var isLoading = true
    
    var body: some View {
        Group {
            if locationManager.userLocation == nil {
                LocationRequestView()
            } else {
                VStack {
                    if isLoading {
                        Text("Connection...")
                            .font(.title.bold())
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                            .background(.thinMaterial)
                    }
                    
                    VStack {
                        VStack {
                            Image(currentWeather.last?.weather ?? "")
                                .scaleEffect(5)
                        }
                        .frame(height: 250, alignment: .center)
                        Text("\(currentWeather.last?.name ?? ""), \(currentWeather.last?.dt ?? "")")
                            .font(.title.bold())
                            .padding()
                            .background(.thinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .padding()
                    }
                    .padding(.top, 32)
                    
                    Spacer()
                    
                    ScrollView(.horizontal) {
                        HStack(alignment: .center, spacing: 40) {
                            
                            if weatherForecast.count == 5 {
                                ForEach(weatherForecast) { forecast in
                                    VStack(alignment: .center, spacing: 10) {
                                        Image(forecast.weather!)
                                        // do not use force unwrap
                                        Text(forecast.dt!)
                                            .font(.title3.bold())
                                    }
                                    .frame(width: 100)
                                }
                            }
                        }
                        .padding()
                        .padding(.horizontal, 20)
                        .frame(maxWidth: .infinity, maxHeight: 100, alignment: .center)
                    }
                    
                    Spacer()
                }
                .onAppear{
                    start()
                }
            }
        }
    }
    
    // move this logic to another file, read about mvp, mvvm, viper
    private func start() {
        let lat = locationManager.userLocation.coordinate.latitude
        let lon = locationManager.userLocation.coordinate.longitude
        
        provider.request(.current(lat: lat, lon: lon)) { result in
            switch result {
            case .success(let response):
                do {
                    let currentResponse = try response.map(CurrentResponse.self)
                    
                    let date = Date(timeIntervalSince1970: TimeInterval(currentResponse.dt))
                    let day = date.formatted(date: .complete, time: .shortened)
                    
                    if currentWeather.isEmpty {
                        let currentWeatherFromResponse = CurrentWeather(context: managedObjectContext)
                        currentWeatherFromResponse.weather = currentResponse.weather[0].main
                        currentWeatherFromResponse.name = currentResponse.name
                        currentWeatherFromResponse.dt = day
                    } else {
                        currentWeather[0].weather = currentResponse.weather[0].main
                        currentWeather[0].name = currentResponse.name
                        currentWeather[0].dt = day
                    }
                    
                    // split core data logic and network manager
                    try managedObjectContext.save()
                    
                    // use debugPrint instead of print
                    print(currentWeather.count)
                    for weather in currentWeather{
                        print(weather)
                    }
                } catch {
                    print ("fail to map")
                }
            case .failure(let error):
                print(error.errorDescription ?? "Unknown error")
            }
            
        }
        
        provider.request(.forecast(lat: lat, lon: lon)) { result in
            switch result {
            case .success(let response):
                do {
                    let forecastResponse = try response.map(ForecastResponse.self)
                    
                    var fiveForecastResponse = [forecastResponse.list[7]]
                    for i in 2...5 {
                        fiveForecastResponse.append(forecastResponse.list[(8 * i) - 1])
                    }
                    print(fiveForecastResponse.count)
                    
                    for index in 0..<5 {
                        let date = Date(timeIntervalSince1970: TimeInterval(fiveForecastResponse[index].dt))
                        let day = date.formatted(.dateTime.weekday(.wide))
                        print(day)
                        
                        if weatherForecast.count == 5 {
                            weatherForecast[index].weather = fiveForecastResponse[index].weather[0].main
                            weatherForecast[index].dt = day
                        } else {
                            let weatherForecastFromResponse = WeatherForecast(context: managedObjectContext)
                            weatherForecastFromResponse.weather = fiveForecastResponse[index].weather[0].main
                            weatherForecastFromResponse.dt = day
                        }
                        
                        try managedObjectContext.save()
                    }
                    
                    withAnimation {
                        isLoading = false
                    }
                    
                    print(weatherForecast.count)
                } catch {
                    print ("fail to map")
                }
            case .failure(let error):
                print(error.errorDescription ?? "Unknown error")
            }
        }
    }
}
