//
//  Parameter+CoreDataProperties.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 4/26/20.
//  Copyright © 2020 Clevertec. All rights reserved.
//
//

import Foundation
import CoreData

extension Parameter {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Parameter> {
        return NSFetchRequest<Parameter>(entityName: "Parameter")
    }

    @NSManaged public var key: String?
    @NSManaged public var value: String?
    @NSManaged public var section: Section?

}
