//
//  MoviesDetailViewController.swift
//  CoreDataPopularMovies
//
//  Created by Val Po on 04.02.2023.
//

import UIKit

final class MoviesDetailViewController: UIViewController {
    
    @IBOutlet private var moviePoster: UIImageView!
    @IBOutlet private var movieTitle: UILabel!
    @IBOutlet private var movieRate: UILabel!
    @IBOutlet private var movieReleaseData: UILabel!
    @IBOutlet private var movieOverview: UILabel!
    
    var viewModel: MovieDetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    private func updateUI() {
        self.movieTitle.text = viewModel.title
        self.movieRate.text = viewModel.rate
        self.movieReleaseData.text = viewModel.year
        self.movieOverview.text = viewModel.overview
        self.moviePoster.setImageFromPath(viewModel.posterImage)
        viewsAttributes()
    }
    
    private func viewsAttributes() {
        movieRate.layer.masksToBounds = true
        movieRate.clipsToBounds = true
        
    }
}
