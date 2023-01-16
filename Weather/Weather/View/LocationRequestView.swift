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
                Image(systemName: "paperplane.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding(.top, 64)
                    .padding()
                
                Text("Start sharing your location with us")
                    .font(.system(size: 28, weight: .semibold))
                    .multilineTextAlignment(.center)
                    .padding()
                
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
                .frame(maxWidth: .infinity)
                .background(.white)
                .clipShape(Capsule())
                .padding(32)
            }
            .foregroundColor(.white)
        }
    }
}

struct LocationRequestView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ZStack {
                LocationRequestView()
            }
.previewInterfaceOrientation(.portraitUpsideDown)
        }
    }
}
