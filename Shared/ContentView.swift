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
    @ObservedObject var viewModel: SongListViewModel
    
    var body: some View {
        
        NavigationView {
            VStack {
                SearchBar(searchTerm: $viewModel.searchTerm)

                if viewModel.songs.isEmpty {
                    Spacer()
                    Text("No playlists found.")
                    Spacer()
                } else {
                    List(viewModel.songs) { song in
                        SongView(song: song)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Your Playlists")
        }
        .fullScreenCover(isPresented: $shouldShowOnboarding, content: {
            OnboardView(shouldShowOnboarding: $shouldShowOnboarding)
        })
    }
}

struct SongView: View {
    @ObservedObject var song: SongViewModel
    
    var body: some View {
        HStack {
            ArtworkView(image: song.artwork)
                .padding(.trailing)
            VStack(alignment: .leading) {
                Text(song.trackName)
                Text(song.artistName)
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
        }
        .padding()
    }
}

struct ArtworkView: View {
    let image: Image?
    
    var body: some View {
        ZStack {
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

struct SearchBar: UIViewRepresentable {
    typealias UIViewType = UISearchBar
    @Binding var searchTerm: String
    
    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search for a song, artist, or album..."
        return searchBar
    }
    
    func updateUIView(_ uiView: UISearchBar, context: Context) {}
    
    func makeCoordinator() -> SearchBarCoordinator {
        return SearchBarCoordinator(searchTerm: $searchTerm)
    }
    
    class SearchBarCoordinator: NSObject, UISearchBarDelegate {
        @Binding var searchTerm: String
        
        init(searchTerm: Binding<String>) {
            self._searchTerm = searchTerm
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchTerm = searchBar.text ?? ""
            UIApplication.shared.windows.first { $0.isKeyWindow }?.endEditing(true)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: SongListViewModel())
            .preferredColorScheme(.light)
    }
}
