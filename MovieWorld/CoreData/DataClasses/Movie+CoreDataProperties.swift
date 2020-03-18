//
//  Movie+CoreDataProperties.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 3/17/20.
//  Copyright © 2020 Clevertec. All rights reserved.
//
//

import Foundation
import CoreData


extension Movie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    @NSManaged public var posterPath: String?
    @NSManaged public var releaseDate: String?
    @NSManaged public var title: String?
    @NSManaged public var genres: NSSet?

}

// MARK: Generated accessors for genres
extension Movie {

    @objc(addGenresObject:)
    @NSManaged public func addToGenres(_ value: Genre)

    @objc(removeGenresObject:)
    @NSManaged public func removeFromGenres(_ value: Genre)

    @objc(addGenres:)
    @NSManaged public func addToGenres(_ values: NSSet)

    @objc(removeGenres:)
    @NSManaged public func removeFromGenres(_ values: NSSet)

}
