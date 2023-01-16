//
//  ContentView.swift
//  Weather
//
//  Created by SemikSS on 03.01.2023.
//

import SwiftUI
import CoreData

struct DailyView: View {
    var day: Day

    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 16) {
                ForEach(day.weatherForecastArray) { weatherForecast in
                    let date = Date(timeIntervalSince1970: TimeInterval(weatherForecast.unixTime + 6400))
                    let day = date.formatted(.dateTime.hour(.twoDigits(amPM: .abbreviated)))
                    
                    VStack {
                        Image(weatherForecast.weather ?? "")
                        Text(day)
                            .font(.title3.bold())
                        Text("""
                            Temp: \(weatherForecast.temp.formatted())
                            Feels like: \(weatherForecast.tempFeelsLike.formatted())
                            Max temp: \(weatherForecast.maxTemp.formatted())
                            Min temp \(weatherForecast.minTemp.formatted())
                            """)
                    }
                }
            }
            .padding(8)
            .navigationBarTitle(day.day ?? "DayError")
        }
    }
}

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
    
    @FetchRequest(entity: Day.entity(),
                  sortDescriptors: [NSSortDescriptor(key: "dayNumber", ascending: true)],
                  animation: .default
    ) var dayResponses : FetchedResults<Day>
    
    @ObservedObject var locationManager = LocationManager.shared
    
    let weatherDataManager = WeatherDataManager()
    
    @State private var isUpdatingCompleted = false
    
    var body: some View {
        if locationManager.userLocation == nil {
            LocationRequestView()
        } else {
            VStack {
                if !isUpdatingCompleted {
                    Text("Connection...")
                        .font(.title.bold())
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .background(.thinMaterial)
                }
                
                VStack {
                    VStack {
                        Image(currentWeather.last?.weather ?? "")
                            .scaleEffect(4)
                    }
                    .frame(height: 100, alignment: .center)
                    Text("\(currentWeather.last?.name ?? ""), \(currentWeather.last?.day ?? "")")
                        .font(.title2.bold())
                        .padding()
                        .background(.thinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding()
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.top, 96)
                
                Spacer()
                
                NavigationView {
                    ScrollView(.horizontal) {
                        HStack(alignment: .center, spacing: 40) {
                            
                            ForEach(dayResponses) { day in
                                NavigationLink(destination: DailyView(day: day)) {
                                    VStack(alignment: .center, spacing: 10) {
                                        Image(day.weatherForecastArray[0].weather ?? "")
                                        // do not use force unwrap
                                        Text(day.day ?? "")
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
                }
                .padding(.bottom, 32)
            }
            .task {
                do {
                    try await weatherDataManager.updateLocalData()
                    withAnimation {
                        isUpdatingCompleted = true
                    }
                } catch {
                    debugPrint("update failed")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ZStack {
                ContentView()
            }
            .previewInterfaceOrientation(.landscapeLeft)
        }
    }
}
