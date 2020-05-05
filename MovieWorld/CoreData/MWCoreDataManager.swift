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

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MovieWorldCoreData")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })

        return container
    }()

    private(set) lazy var context: NSManagedObjectContext = self.persistentContainer.viewContext

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

// MARK: - general

extension MWCoreDataManager {
    private func deleteAllData(entity: String, predicateFormat: String? = nil) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        if let format = predicateFormat {
            let predicate = NSPredicate(format: format)
            fetchRequest.predicate = predicate
        }
        do {
            let results = try self.context.fetch(fetchRequest)
            for managedObject in results {
                guard let managedObjectData = managedObject as? NSManagedObject else { return }
                self.context.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Delete all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }

    private func fetchData<T: NSManagedObject>(sortDescriptors: [NSSortDescriptor]? = nil) -> [T]? {
        guard let fetch = T.fetchRequest() as? NSFetchRequest<T> else { return nil }
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

// MARK: - genres

extension MWCoreDataManager {
    func saveGenre(id: Int, name: String) {
        let newGenre = Genre(context: self.context)
        newGenre.id = Int64(id)
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

// MARK: - movies

extension MWCoreDataManager {
    func saveMovie(from movie: MWMovie, to section: Section) {
        let newMovie = Movie(context: self.context)
        newMovie.id = movie.id
        newMovie.title = movie.title
        newMovie.releaseDate = movie.releaseDate
        newMovie.posterPath = movie.posterPath
        if let genres = MWCoreDataManager.sh.fetchGenres() {
            genres
                .filter { movie.genres.contains($0.id) }
                .forEach { newMovie.addToGenres($0) }
        }
        newMovie.addToSection(section)
        self.saveContext()
    }

    func saveMovieImage(image: Data?, for movie: MWMovie) {
        guard let allMovies = self.fetchMovies() else { return }
        let filteredMovies = allMovies.filter({ $0.id == movie.id && $0.image == nil })
        filteredMovies.forEach { movie in
            movie.image = image
        }
        self.saveContext()
    }

    func deleteAllMovies() {
        self.deleteAllData(entity: "Movie")
    }

    func fetchMovies() -> [Movie]? {
        self.fetchData()
    }
}

// MARK: - sections

extension MWCoreDataManager {
    func saveSection(section: MWSection, movies: [MWMovie] = []) {
        self.deleteSection(name: section.name)
        let newSection = Section(context: self.context)
        newSection.name = section.name
        newSection.urlPath = section.url
        section.parameters.forEach {
            self.saveParameter(key: $0.key, value: $0.value, to: newSection)
        }
        movies.forEach { movie in
            self.saveMovie(from: movie, to: newSection)
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

// MARK: - parameters

extension MWCoreDataManager {
    func saveParameter(key: String, value: String, to section: Section) {
        let newParameter = Parameter(context: self.context)
        newParameter.key = key
        newParameter.value = value
        section.addToParameters(newParameter)
        self.saveContext()
    }

    func deleteAllParameters() {
        self.deleteAllData(entity: "Parameter")
    }

    func fetchParameters() -> [Section]? {
        self.fetchData()
    }
}
