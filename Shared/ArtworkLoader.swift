//
//  ArtworkLoader.swift
//  clean-my-music
//
//  Created by Rudy Patel on 2022-06-05.
//

import Foundation
import SwiftUI

// Class responsible for loading artwork images
class ArtworkLoader {
    // Array to store URLSession data tasks
    private var dataTasks: [URLSessionDataTask] = []
    
    // Function to load artwork for a given song
    func loadArtwork(forSong song: Song, completion: @escaping((Image?) -> Void)) {
        // Create a URL from the song's artwork URL
        guard let imageUrl = URL(string: song.artworkUrl) else {
            completion(nil)
            return
        }
        
        // Create a URLSession data task to fetch the artwork data
        let dataTask = URLSession.shared.dataTask(with: imageUrl) { data, _, _ in
            // Check if there is valid data and create an Image from the UIImage
            guard let data = data, let artwork = UIImage(data: data) else {
                completion(nil)
                return
            }
            
            // Convert the UIImage to a SwiftUI Image
            let image = Image(uiImage: artwork)
            completion(image)
        }
        
        // Add the data task to the array and resume it
        dataTasks.append(dataTask)
        dataTask.resume()
    }
    
    // Function to cancel all ongoing data tasks
    func reset() {
        dataTasks.forEach { $0.cancel() }
    }
}
