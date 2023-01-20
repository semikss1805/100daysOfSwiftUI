//
//  DailyView.swift
//  Weather
//
//  Created by SemikSS on 17.01.2023.
//

import SwiftUI

struct DailyView: View {
    var day: Day
    
    private let celsius = "°C"

    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 16) {
                ForEach(day.weatherForecastArray) { weatherForecast in
                    let date = Date(timeIntervalSince1970: TimeInterval(weatherForecast.unixTime + 6400))
                    let day = date.formatted(.dateTime.hour(.twoDigits(amPM: .abbreviated)))
                    
                    VStack {
                        Image(weatherForecast.weather ?? "")
                            .resizable()
                            .scaledToFit()
                            .frame(minHeight: 20, maxHeight: 100)
                        
                        Text(day)
                            .font(.title3.bold())
                        
                        Text("""
                            Temp: \(weatherForecast.temp.formatted()) \(celsius)
                            Feels like: \(weatherForecast.tempFeelsLike.formatted()) \(celsius)
                            Max temp: \(weatherForecast.maxTemp.formatted()) \(celsius)
                            Min temp \(weatherForecast.minTemp.formatted()) \(celsius)
                            """)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            .padding(8)
            .navigationBarTitle(day.day ?? "DayError")
        }
    }
}
