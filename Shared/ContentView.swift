//
//  ContentView.swift
//  Shared
//
//  Created by Rudy Patel on 2022-06-03.
//

import SwiftUI
import StoreKit

let controller = SKCloudServiceController()
let developerToken = "..."

struct ContentView: View {
    @State var shouldShowOnboarding: Bool = true
    var body: some View {
        
        NavigationView {
            VStack {
                Text("Clean my music")
                    .padding()
            }
            .navigationTitle("Home")
        }
        .fullScreenCover(isPresented: $shouldShowOnboarding, content: {
            OnboardView(shouldShowOnboarding: $shouldShowOnboarding)
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.light)
    }
}
