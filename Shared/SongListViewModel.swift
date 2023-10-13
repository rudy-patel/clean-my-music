//
//  SongListViewModel.swift
//  clean-my-music
//
//  Created by Rudy Patel on 2022-06-05.
//

import Combine
import Foundation
import SwiftUI

// ViewModel class responsible for managing the list of songs
class SongListViewModel: ObservableObject {
    // Published property for the search term
    @Published var searchTerm: String = ""
    
    // Published property for the list of song view models
    @Published public private(set) var songs: [SongViewModel] = []
    
    // Instances of DataModel and ArtworkLoader
    private let dataModel: DataModel = DataModel()
    private let artworkLoader: ArtworkLoader = ArtworkLoader()
    
    // Set of disposables to manage Combine subscriptions
    private var disposables = Set<AnyCancellable>()
    
    // Initializer to set up the Combine pipeline
    init() {
        // Set up a Combine pipeline to react to changes in the search term
        $searchTerm
            .sink(receiveValue: loadSongs(searchTerm:))
            .store(in: &disposables)
    }
    
    // Function to load songs based on a search term
    private func loadSongs(searchTerm: String) {
        // Clear the existing list of songs and reset the artwork loader
        songs.removeAll()
        artworkLoader.reset()
        
        // Use the DataModel to load songs based on the search term
        dataModel.loadSongs(searchTerm: searchTerm) { songs in
            // For each song, append it to the list
            songs.forEach { self.appendSong(song: $0) }
        }
    }
    
    // Function to append a song to the list and load its artwork
    private func appendSong(song: Song) {
        // Create a SongViewModel from the song
        let songViewModel = SongViewModel(song: song)
        
        // Append the song to the list on the main thread
        DispatchQueue.main.async {
            self.songs.append(songViewModel)
        }
        
        // Load the artwork for the song using the ArtworkLoader
        artworkLoader.loadArtwork(forSong: song) { image in
            // Update the artwork on the main thread
            DispatchQueue.main.async {
                songViewModel.artwork = image
            }
        }
    }
}

// ViewModel for an individual song
class SongViewModel: Identifiable, ObservableObject {
    // Song properties
    let id: Int
    let trackName: String
    let artistName: String
    
    // Published property for the artwork image
    @Published var artwork: Image?
    
    // Initializer to create a SongViewModel from a Song
    init(song: Song) {
        self.id = song.id
        self.trackName = song.trackName
        self.artistName = song.artistName
    }
}
