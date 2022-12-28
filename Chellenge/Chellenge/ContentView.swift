//
//  ContentView.swift
//  Chellenge
//
//  Created by SemikSS on 28.12.2022.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedInput = "S"
    @State private var selectedOutput = "M"
    @State private var inputValue = 0.0
        
    let time = ["S", "M", "H", "D"]
    
    var inputToSecond: Double {
        switch selectedInput {
        case "S":
            return inputValue
        case "M":
            return inputValue * 60
        case "H":
            return inputValue * 3600
        case "D":
            return inputValue * 86400
        default:
            return 0
        }
    }
    
    var convertToSelectedType: Double {
        switch selectedOutput {
        case "S":
            return inputToSecond
        case "M":
            return inputToSecond / 60
        case "H":
            return inputToSecond / 3600
        case "D":
            return inputToSecond / 86400
        default:
            return 0
        }
    }
    
    
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Input type", selection: $selectedInput) {
                        ForEach(time, id: \.self) {
                            Text("\($0)")
                        }
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text("Input type")
                }
                
                Section {
                    Picker("Output type", selection: $selectedOutput) {
                        ForEach(time, id: \.self) {
                            Text("\($0)")
                        }
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text("Output type")
                }
                
                Section {
                    TextField("Input value", value: $inputValue, format: .number)
                        .keyboardType(.decimalPad)
                }
                
                Section {
                    Text("\(convertToSelectedType.formatted())")
                }
            }
            .navigationTitle("Time converter")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            ContentView()
        }
    }
}
