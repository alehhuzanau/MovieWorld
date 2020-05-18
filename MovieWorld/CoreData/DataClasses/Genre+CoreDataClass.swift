//
//  Genre+CoreDataClass.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 3/17/20.
//  Copyright © 2020 Clevertec. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Genre)
public class Genre: NSManagedObject {

    func getGenre() -> MWGenre {
        return MWGenre(id: Int(self.id), name: self.name ?? "")
    }
}
