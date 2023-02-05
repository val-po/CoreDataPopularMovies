//
//  CoreDataManager.swift
//  CoreDataPopularMovies
//
//  Created by Val Po on 03.02.2023.
//

import UIKit
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    
    init () {}
    
    private let container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    private let fetchRequest = NSFetchRequest<MoviesEntity>(entityName: "MoviesEntity")
    
    func saveDataOf(movies: [Movie]) {
        // Update Core Data with the new data from the server - Off the main thread
        self.container?.performBackgroundTask{ [weak self] (context) in
            self?.deleteObjectsfromCoreData(context: context)
            self?.saveDataToCoreData(movies: movies, context: context)
        }
    }
    
    // MARK: Save new data from the server to Core Data
    func saveDataToCoreData(movies: [Movie], context: NSManagedObjectContext) {
        context.perform {
            for movie in movies {
                let movieEntity = MoviesEntity(context: context)
                movieEntity.title = movie.title
                movieEntity.year = movie.year
                guard let rate = movie.rate else { return }
                movieEntity.rate = String(rate)
                movieEntity.posterImage = movie.posterImage
                movieEntity.backdropImage = movie.backdropImage
                movieEntity.overview = movie.overview
            }
            do {
                try context.save()
            } catch {
                fatalError("Failure to save context: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Delete Core Data objects
    func deleteObjectsfromCoreData(context: NSManagedObjectContext) {
        do {
            // Fetch Data
            let objects = try context.fetch(fetchRequest)
            // Delete Data
            _ = objects.map({ context.delete($0)})
            // Save Data
            try context.save()
        } catch {
            print("Deleting Error: \(error.localizedDescription)")
        }
    }
}
