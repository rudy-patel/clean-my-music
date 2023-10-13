//
//  Onboarding.swift
//  clean-my-music
//
//  Created by Rudy Patel on 2022-06-04.
//

import Foundation
import SwiftUI

// View for the entire onboarding experience
struct OnboardView: View {
    @Binding var shouldShowOnboarding: Bool
    @State private var selectedTabIndex = 0
    
    var body: some View {
        // TabView to display multiple onboarding pages
        TabView(selection: $selectedTabIndex) {
            // First onboarding page
            OnboardPageView(systemImageName: "music.note.list",
                            title: "Clean My Music",
                            description: "Quickly create clean versions of your existing Apple Music playlists",
                            showRequestAccessButton: false,
                            showDismissButton: false,
                            shouldShowOnboarding: $shouldShowOnboarding)
            .tag(0)
            
            // Second onboarding page
            OnboardPageView(systemImageName: "iphone.badge.play",
                            title: "Connect to Apple Music",
                            description: "To generate playlists, we need access to your Apple Music library.",
                            showRequestAccessButton: true,
                            showDismissButton: false,
                            shouldShowOnboarding: $shouldShowOnboarding)
            .tag(1)
            
            // Third onboarding page
            OnboardPageView(systemImageName: "waveform",
                            title: "You're Ready!",
                            description: "Enjoy your new AUX privileges around Mom. Use them responsibly...",
                            showRequestAccessButton: false,
                            showDismissButton: true,
                            shouldShowOnboarding: $shouldShowOnboarding)
            .tag(2)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        .onTapGesture {
            // Check if the tap is on the last page
            if selectedTabIndex == 2 && shouldShowOnboarding {
                shouldShowOnboarding.toggle()
            }
        }
    }
}

// View for an individual onboarding page
struct OnboardPageView: View {
    let systemImageName: String
    let title: String
    let description: String
    let showRequestAccessButton: Bool
    let showDismissButton: Bool
    @Binding var shouldShowOnboarding: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            // Display system image for the onboarding page
            Image(systemName: systemImageName)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.teal)
            
            // Display title for the onboarding page
            Text(title)
                .font(.title).bold()
            
            // Display description for the onboarding page
            Text(description)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            // Display "Enable Access" button if needed
            if showRequestAccessButton {
                Button(action: {
                    // Action for enabling access (placeholder)
                }, label: {
                    Text("Enable Access")
                        .bold()
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(.teal)
                        .cornerRadius(6)
                })
            }
            
            // Display "Get Started" button if needed
            if showDismissButton {
                Button(action: {
                    // Action for dismissing onboarding
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
