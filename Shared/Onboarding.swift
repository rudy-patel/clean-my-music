//
//  Onboarding.swift
//  clean-my-music
//
//  Created by Rudy Patel on 2022-06-04.
//

import Foundation
import SwiftUI

struct OnboardView: View {
    @Binding var shouldShowOnboarding: Bool
    
    var body: some View {
        TabView {
            OnboardPageView(systemImageName: "music.note.list",
                        title: "Clean My Music",
                        description: "Quickly create clean versions of your existing Apple Music playlists",
                        showRequestAccessButton: false,
                        showDismissButton: false,
                        shouldShowOnboarding: $shouldShowOnboarding)
            OnboardPageView(systemImageName: "iphone.badge.play",
                        title: "Allow Access",
                        description: "To generate playlists, we need access to your Apple Music library.",
                        showRequestAccessButton: true,
                        showDismissButton: false,
                        shouldShowOnboarding: $shouldShowOnboarding)
            OnboardPageView(systemImageName: "waveform",
                        title: "You're All Set",
                        description: "Enjoy your newly acquired AUX privileges around Mom. Use them responsibly...",
                        showRequestAccessButton: false,
                        showDismissButton: true,
                        shouldShowOnboarding: $shouldShowOnboarding)
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}

struct OnboardPageView: View {
    let systemImageName: String
    let title: String
    let description: String
    let showRequestAccessButton: Bool
    let showDismissButton: Bool
    @Binding var shouldShowOnboarding: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: systemImageName)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.teal)
            
            Text(title)
                .font(.title).bold()
            
            Text(description)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            if showRequestAccessButton {
                Button(action: {
                    
                }, label: {
                    Text("Enable Access")
                        .bold()
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(.teal)
                        .cornerRadius(6)
                })
            }
            
            if showDismissButton {
                Button(action: {
                    shouldShowOnboarding.toggle()
                }, label: {
                    Text("Get Started")
                        .bold()
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(.teal)
                        .cornerRadius(6)
                })
            }
        }
        .padding(.horizontal, 40)
        
        
    }
}
