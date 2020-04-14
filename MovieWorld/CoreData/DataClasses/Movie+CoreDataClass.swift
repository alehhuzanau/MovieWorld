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
