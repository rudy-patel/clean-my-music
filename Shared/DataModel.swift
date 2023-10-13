//
//  DataModel.swift
//  clean-my-music
//
//  Created by Rudy Patel on 2022-06-05.
//

import Foundation

// DataModel class responsible for handling data-related operations
class DataModel {
    private var dataTask: URLSessionDataTask?
    
    // Function to load songs based on a search term
    func loadSongs(searchTerm: String, completion: @escaping(([Song]) -> Void)) {
        // Cancel any existing data tasks to avoid conflicts
        dataTask?.cancel()
        
        // Build the URL for the iTunes Search API
        guard let url = buildUrl(forTerm: searchTerm) else {
            completion([])
            return
        }
        
        // Create a URLSession data task to fetch data from the API
        dataTask = URLSession.shared.dataTask(with: url) { data, _, _ in
            // Check if there is valid data
            guard let data = data else {
                completion([])
                return
            }
            
            // Decode the JSON data into a SongResponse object
            if let songResponse = try? JSONDecoder().decode(SongResponse.self, from: data) {
                // Call the completion handler with the array of songs
                completion(songResponse.songs)
            }
        }
        
        // Resume the data task to initiate the network request
        dataTask?.resume()
    }
    
    // Function to build the URL for the iTunes Search API
    private func buildUrl(forTerm searchTerm: String) -> URL? {
        // Check if the search term is not empty
        guard !searchTerm.isEmpty else { return nil }
        
        // Construct the query items for the URL
        let queryItems = [
            URLQueryItem(name: "term", value: searchTerm),
            URLQueryItem(name: "entity", value: "song"),
        ]
        
        // Construct the URL components and return the URL
        var components = URLComponents(string: "https://itunes.apple.com/search")
        components?.queryItems = queryItems
        
        return components?.url
    }
}

// SongResponse struct representing the response from the iTunes Search API
struct SongResponse: Decodable {
    let songs: [Song]
    
    // Define coding keys to map JSON keys to struct properties
    enum CodingKeys: String, CodingKey {
        case songs = "results"
    }
}

// Song struct representing a song with its properties
struct Song: Decodable {
    let id: Int
    let trackName: String
    let artistName: String
    let artworkUrl: String
    
    // Define coding keys to map JSON keys to struct properties
    enum CodingKeys: String, CodingKey {
        case id = "trackId"
        case trackName
        case artistName
        case artworkUrl = "artworkUrl60"
    }
}
