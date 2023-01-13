//
//  ContentView.swift
//  Weather
//
//  Created by SemikSS on 03.01.2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(entity: CurrentWeather.entity(),
                  sortDescriptors: [NSSortDescriptor(key: "unixTime", ascending: true)],
                  animation: .default
    ) var currentWeather: FetchedResults<CurrentWeather>
    
    @FetchRequest(entity: WeatherForecast.entity(),
                  sortDescriptors: [NSSortDescriptor(key: "unixTime", ascending: true)],
                  animation: .default
    ) var weatherForecast: FetchedResults<WeatherForecast>
    
    @ObservedObject var openWeatherManager = OpenWeatherManager.shared
    
    @ObservedObject var locationManager = LocationManager.shared
    
    var body: some View {
        Group {
            if locationManager.userLocation == nil {
                LocationRequestView()
            } else {
                VStack {
                    if !openWeatherManager.isUpdatingCompleted {
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
                        .frame(height: 200, alignment: .center)
                        Text("\(currentWeather.last?.name ?? ""), \(currentWeather.last?.day ?? "")")
                            .font(.title2.bold())
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
                                        Image(forecast.weather ?? "")
                                        // do not use force unwrap
                                        Text(forecast.day ?? "")
                                            .font(.title3.bold())
                                    }
                                    .frame(width: 120)
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
                    openWeatherManager.updateLocalWeatherData()
                }
            }
        }
    }
}
