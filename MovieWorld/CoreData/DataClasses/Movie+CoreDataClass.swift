//
//  Movie+CoreDataClass.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 3/17/20.
//  Copyright © 2020 Clevertec. All rights reserved.
//
//

import UIKit
import CoreData

@objc(Movie)
public class Movie: NSManagedObject {

    static func getMovie(from movie: MWMovie) -> Movie {
        let managedContext = MWCoreDataManager.sh.context
        let newMovie = Movie(context: managedContext)
        newMovie.id = movie.id
        newMovie.title = movie.title
        newMovie.releaseDate = movie.releaseDate
        newMovie.posterPath = movie.posterPath
        if let genres = MWCoreDataManager.sh.fetchGenres() {
            genres
                .filter { movie.genres.contains($0.id) }
                .forEach { newMovie.addToGenres($0) }
        }
        
        return newMovie
    }
    
    func getImage() -> UIImage? {
        if let data = self.image {
            return UIImage(data: data)
        }
        return nil
    }
    
    func getReleaseDateYear() -> String {
        return String(self.releaseDate?.prefix(4) ?? "")
    }
    
    func getGenres() -> [Genre] {
        return self.genres?.allObjects as? [Genre] ?? []
    }
}
