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
    
    lazy var context = { self.persistentContainer.viewContext }()
    
    private init() {
        let docUrls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        if docUrls.count > 0 {
            self.documentsDirectory = docUrls[0]
        } else {
            fatalError("not found documentDirectory")
        }
    }
    
    func saveContext() {
        if self.context.hasChanges {
            do {
                try self.context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension MWCoreDataManager {
    private func deleteAllData(entity: String, predicateFormat: String? = nil) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        if let format = predicateFormat {
            let predicate = NSPredicate(format: format)
            fetchRequest.predicate = predicate
        }
        do
        {
            let results = try self.context.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData: NSManagedObject = managedObject as! NSManagedObject
                self.context.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Delete all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }
    
    private func fetchData<T: NSManagedObject>(sortDescriptors: [NSSortDescriptor]? = nil) -> [T]? {
        let fetch: NSFetchRequest<T> = T.fetchRequest() as! NSFetchRequest<T>
        fetch.sortDescriptors = sortDescriptors
        do {
            let results = try self.context.fetch(fetch)
            return results
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}

extension MWCoreDataManager {
    func saveGenre(id: Int64, name: String) {
        let newGenre = Genre(context: self.context)
        newGenre.id = id
        newGenre.name = name
        self.saveContext()
    }
    
    func deleteAllGenres() {
        self.deleteAllData(entity: "Genre")
    }
    
    func fetchGenres() -> [Genre]? {
        self.fetchData(sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)])
    }
}

extension MWCoreDataManager {
    func saveMovie(from movie: MWMovie, imageData image: Data?) {
        if let ids = self.fetchMovies()?.map({ $0.id }), ids.contains(movie.id) { return }
        let newMovie = Movie.getMovie(from: movie)
        newMovie.image = image
        self.saveContext()
    }
    
    func deleteAllMovies() {
        self.deleteAllData(entity: "Movie")
    }
    
    func fetchMovies() -> [Movie]? {
        self.fetchData()
    }
}

extension MWCoreDataManager {
    func saveSection(sectionUrl: MWSection, movies: [MWMovie] = []) {
        let newSection = Section(context: self.context)
        newSection.name = sectionUrl.name
        newSection.urlPath = sectionUrl.url
        sectionUrl.parameters.forEach { parameter in
            let newParameter = Parameter(context: self.context)
            newParameter.key = parameter.key
            newParameter.value = parameter.value
            newSection.addToParameters(newParameter)
        }
        let movieIds: [Int64] = movies.map { $0.id }
        if let sectionMovies = self.fetchMovies() {
            sectionMovies
                .filter { movieIds.contains($0.id) }
                .forEach { newSection.addToMovies($0) }
        }
        self.saveContext()
    }
    
    func deleteAllSections() {
        self.deleteAllData(entity: "Section")
    }
    
    func deleteSection(name: String) {
        self.deleteAllData(entity: "Section", predicateFormat: "name == '\(name)'")
    }
    
    func fetchSections() -> [Section]? {
        self.fetchData()
    }
}
