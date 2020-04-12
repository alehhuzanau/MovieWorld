//
//  Section+CoreDataClass.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 4/7/20.
//  Copyright © 2020 Clevertec. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Section)
public class Section: NSManagedObject {
    
    func getMovies() -> [Movie] {
        return self.movies?.allObjects as? [Movie] ?? []
    }
}
