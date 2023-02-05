//
//  MoviesListViewController.swift
//  CoreDataPopularMovies
//
//  Created by Val Po on 03.02.2023.
//

import UIKit
import CoreData

final class MoviesListViewController: UIViewController, UpdateTableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel = MovieListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        tableView.dataSource = self
        tableView.delegate = self
        loadData()
    }
    
    private func loadData() {
        viewModel.retrieveDataFromCoreData()
    }
    
    func reloadData(sender: MovieListViewModel) {
        tableView.reloadData()
    }
    
    private func setNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barStyle = .black
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "movieSelected" {
            guard let detailVC = segue.destination as? MoviesDetailViewController else {
                return
            }
            guard let selectedMovieCell = sender as? UITableViewCell else { return }
            if let indexPath = tableView.indexPath(for: selectedMovieCell) {
                let selectedMovie = viewModel.object(indexPath: indexPath)
                detailVC.viewModel = MovieDetailViewModel(movieDetails: selectedMovie)
            }
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension MoviesListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let object = viewModel.object(indexPath: indexPath)
        if let movieCell = cell as? MoviesListTableViewCell {
            if let movie = object {
                movieCell.setCellWithValuesOf(movie)
            }
        }
        return cell
    }
}
