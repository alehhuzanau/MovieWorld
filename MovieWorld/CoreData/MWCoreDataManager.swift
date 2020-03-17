//
//  MWCoreDataManager.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 3/17/20.
//  Copyright © 2020 Clevertec. All rights reserved.
//

import Foundation
import CoreData

class MWCoreDataManager {
    static let s: MWCoreDataManager = MWCoreDataManager()
    
    private let documentsDirectory: URL
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MovieWorldCoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
    
    private init() {
        let docUrls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        if docUrls.count > 0 {
            self.documentsDirectory = docUrls[0]
        } else {
            fatalError("not found documentDirectory")
        }
    }
    
    func saveContext() {
        let context = self.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension MWCoreDataManager {
    private func save(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func deleteAllData(entity: String) {
        let managedContext = MWCoreDataManager.s.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        do
        {
            let results = try managedContext.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData: NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Delete all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }
}

extension MWCoreDataManager {
    func saveGenre(id: Int64, name: String) {
        let managedContext = MWCoreDataManager.s.persistentContainer.viewContext
        let newGenre = Genre(context: managedContext)
        newGenre.id = Int64(id)
        newGenre.name = name
        self.save(context: managedContext)
    }
    
    func deleteAllGenres() {
        self.deleteAllData(entity: "Genre")
    }
    
    func fetchGenres() -> [Genre]? {
        let managedContext = MWCoreDataManager.s.persistentContainer.viewContext
        let fetch: NSFetchRequest<Genre> = Genre.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetch.sortDescriptors = [sortDescriptor]
        do {
            let genres = try managedContext.fetch(fetch)
            return genres
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}
