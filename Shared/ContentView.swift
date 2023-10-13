//
//  ContentView.swift
//  Shared
//
//  Created by Rudy Patel on 2022-06-03.
//

import SwiftUI
import StoreKit

// Set up the MusicKit controller and provide the developer token
let controller = SKCloudServiceController()
let developerToken = "..."

// The main content view of the app
struct ContentView: View {
    @State var shouldShowOnboarding: Bool = true
    @ObservedObject var viewModel: SongListViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                // Search bar for entering search terms
                SearchBar(searchTerm: $viewModel.searchTerm)
                
                if viewModel.songs.isEmpty {
                    // Display a message if no playlists are found
                    Spacer()
                    Text("No playlists found.")
                    Spacer()
                } else {
                    // Display the list of songs
                    List(viewModel.songs) { song in
                        SongView(song: song)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Your Playlists")
        }
        // Display onboarding view as a full-screen cover
        .fullScreenCover(isPresented: $shouldShowOnboarding, content: {
            OnboardView(shouldShowOnboarding: $shouldShowOnboarding)
        })
    }
}

// A view for displaying a single song in the list
struct SongView: View {
    @ObservedObject var song: SongViewModel
    
    var body: some View {
        HStack {
            // Display the artwork or a default music note icon
            ArtworkView(image: song.artwork)
                .padding(.trailing)
            VStack(alignment: .leading) {
                // Display the track name and artist name
                Text(song.trackName)
                Text(song.artistName)
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
        }
        .padding()
    }
}

// A view for displaying the artwork of a song
struct ArtworkView: View {
    let image: Image?
    
    var body: some View {
        ZStack {
            // Display the artwork or a default music note icon on a colored background
            if image != nil {
                image
            } else {
                Color(.systemIndigo)
                Image(systemName: "music.note")
                    .font(.largeTitle)
                    .foregroundColor(.white)
            }
        }
        .frame(width: 50, height: 50)
        .shadow(radius: 5)
        .padding(.trailing, 5)
    }
}

// A UIKit-based search bar wrapped for SwiftUI
struct SearchBar: UIViewRepresentable {
    typealias UIViewType = UISearchBar
    @Binding var searchTerm: String
    
    // Create the UIKit search bar
    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search for a song, artist, or album..."
        return searchBar
    }
    
    func updateUIView(_ uiView: UISearchBar, context: Context) {}
    
    // Create a coordinator to handle search bar events
    func makeCoordinator() -> SearchBarCoordinator {
        return SearchBarCoordinator(searchTerm: $searchTerm)
    }
    
    // Coordinator class to handle search bar events
    class SearchBarCoordinator: NSObject, UISearchBarDelegate {
        @Binding var searchTerm: String
        
        init(searchTerm: Binding<String>) {
            self._searchTerm = searchTerm
        }
        
        // Handle the search button click event
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchTerm = searchBar.text ?? ""
            // Dismiss the keyboard
            UIApplication.shared.windows.first { $0.isKeyWindow }?.endEditing(true)
        }
    }
}

// Preview for ContentView
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: SongListViewModel())
            .preferredColorScheme(.light)
    }
}
