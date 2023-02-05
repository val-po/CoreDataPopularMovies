//
//  SplashScreenViewController.swift
//  CoreDataPopularMovies
//
//  Created by Val Po on 02.02.2023.
//

import UIKit

final class SplashScreenViewController: UIViewController {
    
    private var apiService = ApiService()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadPopularMoviesData()
    }
    
    private func loadPopularMoviesData() {
        // Fetch data from ther server
        apiService.getPopularMoviesData { [weak self] result in
            switch result {
            case .success(let listOf):
                // Save Data to Core Data
                CoreDataManager.shared.saveDataOf(movies: listOf.movies)
                self?.perform(#selector(self?.mainScreen))
            case .failure(let error):
                self?.showAlertWith(title: "Not connect", message: "Please check your internet connection or try again later.")
                print("Error processing json data: \(error)")
            }
        }
    }
    
    // MARK: - Alert message
    func showAlertWith(title: String, message: String, style: UIAlertController.Style = .alert) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let action = UIAlertAction(title: "Ok", style: .default) { (action) in
            self.dismiss(animated: true)
        }
        alertController.addAction(action)
        present(alertController, animated: true)
    }

    // Perform a transition to the main screen
    @objc func mainScreen() {
        performSegue(withIdentifier: "movieList", sender: self)
    }
}

