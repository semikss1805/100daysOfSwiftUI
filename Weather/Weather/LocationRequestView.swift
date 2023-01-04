//
//  LocationRequestView.swift
//  Weather
//
//  Created by SemikSS on 03.01.2023.
//

import SwiftUI

struct LocationRequestView: View {
    var body: some View {
        ZStack {
            Color(.systemBlue).ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Image(systemName: "paperplane.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding()
                
                Text("Start sharing your location with us")
                    .font(.system(size: 28, weight: .semibold))
                    .multilineTextAlignment(.center)
                    .padding()
                
                Spacer()
                Spacer()
                
                Button {
                    print("Request lacation from user")
                    LocationManager.shared.requestLocation()
                } label: {
                    Text("Allow location")
                        .padding()
                        .font(.headline)
                        .foregroundColor(Color(.systemBlue))
                }
                .frame(width: UIScreen.main.bounds.width)
                .padding(.horizontal, -32)
                .background(.white)
                .clipShape(Capsule())
                .padding(.bottom,32)
                
            }
            .foregroundColor(.white)
        }
    }
}

struct LocationRequestView_Previews: PreviewProvider {
    static var previews: some View {
        LocationRequestView()
    }
}
