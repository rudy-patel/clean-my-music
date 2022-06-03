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
    var body: some View {
        Text("Clean my music")
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
