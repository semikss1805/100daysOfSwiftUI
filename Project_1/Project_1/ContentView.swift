//
//  ContentView.swift
//  Project_1
//
//  Created by SemikSS on 26.12.2022.
//

import SwiftUI

struct ContentView: View {
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 20
    @FocusState private var amountFocused: Bool
    
    var localCurrency: String {
        Locale.current.currencyCode ?? "USD"
    }
    
    
    var totalPerPerson: Double {
        let peopleCount = Double(numberOfPeople + 2)
        let tipSelection = Double(tipPercentage)
        
        let tipValue = checkAmount / 100 * tipSelection
        let grandTotal = checkAmount + tipValue
        let amountPerPerson = grandTotal / peopleCount
        
        return amountPerPerson
    }
    
    var totalPerCheck: Double {
        checkAmount * (Double(tipPercentage) + 100) / 100
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Amount", value: $checkAmount, format:
                        .currency(code: localCurrency))
                        .keyboardType(.decimalPad)
                        .focused($amountFocused)
                    
                    Picker("Number of people", selection: $numberOfPeople) {
                        ForEach(2..<100) {
                            Text("\($0) people")
                        }
                    }
                }
                
                Section {
                    Picker("Tip percentage", selection: $tipPercentage) {
                        ForEach(0..<101) {
                            Text($0, format: .percent)
                        }
                    }
                    .pickerStyle(.wheel)
                } header: {
                    Text("How much tip do u want to leave")
                }
                
                Section {
                    Text(totalPerPerson, format:
                        .currency(code: localCurrency))
                } header: {
                    Text("Amount per person")
                }
                
                Section {
                    Text(totalPerCheck, format:
                        .currency(code: localCurrency))
                        .foregroundColor(tipPercentage == 0 ? .red : nil)
                }
            }
            .navigationTitle("WeSplit")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Button("Done") {
                        amountFocused = false
                    }
                }
            }
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
