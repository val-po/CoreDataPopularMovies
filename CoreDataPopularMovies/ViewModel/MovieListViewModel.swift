//
//  MovieListViewModel.swift
//  CoreDataPopularMovies
//
//  Created by Val Po on 03.02.2023.
//

import UIKit
import CoreData

protocol UpdateTableViewDelegate: NSObjectProtocol {
    func reloadData(sender: MovieListViewModel)
}

final class MovieListViewModel: NSObject, NSFetchedResultsControllerDelegate {
    private let container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    private var fetchedResultController: NSFetchedResultsController<MoviesEntity>?
    
    weak var delegate: UpdateTableViewDelegate?
    
    // MARK: - Fetched results controller - retrieve data from Core Data
    func retrieveDataFromCoreData() {
        if let context = self.container?.viewContext {
            let request: NSFetchRequest<MoviesEntity> = MoviesEntity.fetchRequest()
            // Sort movies by rating
            request.sortDescriptors = [NSSortDescriptor(key: #keyPath(MoviesEntity.rate), ascending: false)]
            self.fetchedResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchedResultController?.delegate = self
            do {
                try self.fetchedResultController?.performFetch()
            } catch {
                print("Failed to initialize FetchedResultController: \(error.localizedDescription)")
            }
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.delegate?.reloadData(sender: self)
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        return fetchedResultController?.sections?[section].numberOfObjects ?? 0
    }
    
    func object(indexPath: IndexPath) -> MoviesEntity? {
        return fetchedResultController?.object(at: indexPath)
    }
}
