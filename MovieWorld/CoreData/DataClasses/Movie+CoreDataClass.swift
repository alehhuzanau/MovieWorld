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

    func getGenres() -> [Genre] {
        return self.genres?.allObjects as? [Genre] ?? []
    }

    func getMovie() -> MWMovie {
        return MWMovie(
            id: Int(self.id),
            title: self.title ?? "",
            posterPath: self.posterPath,
            genreIds: self.getGenres().map { Int($0.id) },
            releaseDate: self.releaseDate ?? "",
            imageData: self.image)
    }
}
