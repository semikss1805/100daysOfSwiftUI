//
//  ContentView.swift
//  BetterRest
//
//  Created by SemikSS on 29.12.2022.
//

import SwiftUI
import CoreML

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    var calculateBadTime: String {
        var alertTitle1 = ""
        
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let comoonents = Calendar.current.dateComponents([.hour, .minute],
            from: wakeUp)
            let hourInSec = (comoonents.hour ?? 0) * 60 * 60
            let minuteInSec = (comoonents.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hourInSec + minuteInSec), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            alertTitle1 = "Your ideal bedtime is: "
            alertTitle1 += sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
             alertTitle1 = "Error"
        }
        
        return alertTitle1
    }
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    var body: some View {
        NavigationView {
            Form {
                HStack {
                    Text("Wake up at")
                        .font(.headline)
                    
                    Spacer()
                    
                    DatePicker("Enter a time",
                               selection: $wakeUp,
                               displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Desired amount of sleep")
                        .font(.headline)
                    
                    Stepper("\(sleepAmount.formatted()) hours ",
                            value: $sleepAmount,
                            in: 4...12,
                            step: 0.5)
                }
                
                HStack(spacing: 0) {
                    Text("Dayly coffee intake")
                        .font(.headline)
                    
                    Picker("", selection: $coffeeAmount) {
                        ForEach(1..<21) {
                            Text($0 == 1 ? "1 cap" : "\($0) caps")
                        }
                    }
                    .labelsHidden()
                }
                
                Section {
                    Text(calculateBadTime)
                }
            }
            .navigationTitle("Better rest")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
