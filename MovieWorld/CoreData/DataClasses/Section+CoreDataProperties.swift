//
//  Section+CoreDataProperties.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 4/7/20.
//  Copyright © 2020 Clevertec. All rights reserved.
//
//

import Foundation
import CoreData


extension Section {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Section> {
        return NSFetchRequest<Section>(entityName: "Section")
    }

    @NSManaged public var name: String?
    @NSManaged public var urlPath: String?
    @NSManaged public var movies: NSSet?
    @NSManaged public var parameters: NSSet?

}

// MARK: Generated accessors for movies
extension Section {

    @objc(addMoviesObject:)
    @NSManaged public func addToMovies(_ value: Movie)

    @objc(removeMoviesObject:)
    @NSManaged public func removeFromMovies(_ value: Movie)

    @objc(addMovies:)
    @NSManaged public func addToMovies(_ values: NSSet)

    @objc(removeMovies:)
    @NSManaged public func removeFromMovies(_ values: NSSet)

}

// MARK: Generated accessors for parameters
extension Section {

    @objc(addParametersObject:)
    @NSManaged public func addToParameters(_ value: Parameter)

    @objc(removeParametersObject:)
    @NSManaged public func removeFromParameters(_ value: Parameter)

    @objc(addParameters:)
    @NSManaged public func addToParameters(_ values: NSSet)

    @objc(removeParameters:)
    @NSManaged public func removeFromParameters(_ values: NSSet)

}
