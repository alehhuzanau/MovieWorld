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
    
    func getParameters() -> [String : String] {
        var result: [String : String] = [:]
        if let allObjects = self.parameters?.allObjects as? [Parameter] {
            allObjects.forEach { parameter in
                guard let key = parameter.key, let value = parameter.value else { return }
                result[key] = value
            }
        }
        
        return result
    }
}
