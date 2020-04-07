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
    static let sh: MWCoreDataManager = MWCoreDataManager()
    
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
    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func deleteAllData(entity: String) {
        let managedContext = self.persistentContainer.viewContext
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
    
    private func fetchData<T: NSManagedObject>(sortDescriptors: [NSSortDescriptor]? = nil) -> [T]? {
        let managedContext = self.persistentContainer.viewContext
        let fetch: NSFetchRequest<T> = T.fetchRequest() as! NSFetchRequest<T>
        fetch.sortDescriptors = sortDescriptors
        do {
            let genres = try managedContext.fetch(fetch)
            return genres
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}

extension MWCoreDataManager {
    func saveGenre(id: Int64, name: String) {
        let managedContext = self.persistentContainer.viewContext
        let newGenre = Genre(context: managedContext)
        newGenre.id = id
        newGenre.name = name
        self.save(context: managedContext)
    }
    
    func deleteAllGenres() {
        self.deleteAllData(entity: "Genre")
    }
    
    func fetchGenres() -> [Genre]? {
        self.fetchData(sortDescriptors: [NSSortDescriptor(key: "id", ascending: true)])
    }
}

extension MWCoreDataManager {
    func saveMovie(id: Int64, title: String, releaseDate: String?, posterPath: String?, genreIds: [Int64]) {
        let managedContext = self.persistentContainer.viewContext
        let newMovie = Movie(context: managedContext)
        newMovie.id = id
        newMovie.title = title
        newMovie.releaseDate = releaseDate
        newMovie.posterPath = posterPath
        if let genres = self.fetchGenres() {
            genres
                .filter { genreIds.contains($0.id) }
                .forEach { newMovie.addToGenres($0) }
        }
        self.save(context: managedContext)
    }
    
    func deleteAllMovies() {
        self.deleteAllData(entity: "Movie")
    }
    
    func fetchMovies() -> [Movie]? {
        self.fetchData()
    }
}

extension MWCoreDataManager {
    func saveSection(name: String, movies: [MWMovie]) {
        let managedContext = self.persistentContainer.viewContext
        let newSection = Section(context: managedContext)
        newSection.name = name
        var movieIds: [Int64] = []
        for movie in movies {
            movieIds.append(movie.id)
        }
        if let sectionMovies = self.fetchMovies() {
            sectionMovies
                .filter { movieIds.contains($0.id) }
                .forEach { newSection.addToMovies($0) }
        }
        self.save(context: managedContext)
    }
    
    func deleteAllSections() {
        self.deleteAllData(entity: "Section")
    }
    
    func fetchSections() -> [Section]? {
        self.fetchData()
    }
}
