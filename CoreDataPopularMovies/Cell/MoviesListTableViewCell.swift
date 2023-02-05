//
//  MoviesListTableViewCell.swift
//  CoreDataPopularMovies
//
//  Created by Val Po on 03.02.2023.
//

import UIKit

final class MoviesListTableViewCell: UITableViewCell {
    
    @IBOutlet var movieTitle: UILabel!
    @IBOutlet var movieOverview: UILabel!
    @IBOutlet var movieRate: UILabel!
    @IBOutlet var moviewBackdrop: UIImageView!
    
    private var apiService = ApiService()
    private var urlString = ""
    
    // MARK: - Setup movie values
    func setCellWithValuesOf(_ movie: MoviesEntity) {
        updateUI(title: movie.title, rate: movie.rate, overview: movie.overview, backdrop: movie.backdropImage)
    }
    
    // MARK: - Update the UIViews
    private func updateUI(title: String?, rate: String?, overview: String?, backdrop: String?) {
        movieTitle.text = title
        movieRate.text = rate
        movieOverview.text = overview
        
        guard let backdropString = backdrop else { return }
        urlString = "https://image.tmdb.org/t/p/w300" + backdropString
        
        guard let backdropImageURL = URL(string: urlString) else {
            moviewBackdrop.image = UIImage(named: "noImageAvailable")
            return
        }
        
        // Before we donload the image we clear out the old one
        moviewBackdrop.image = nil
        
        apiService.getImageDatafrom(url: backdropImageURL) { [weak self] (data: Data) in
            if let image = UIImage(data: data) {
                self?.moviewBackdrop.image = image
            } else {
                self?.moviewBackdrop.image = UIImage(named: "noImageAvailable")
            }
        }
        viewsAttributes()
    }
    
    // MARK: - Views attributes
    private func viewsAttributes() {
        // Movie backdrop attributes
        moviewBackdrop.layer.cornerRadius = 20
        moviewBackdrop.layer.borderWidth = 0.8
        moviewBackdrop.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        moviewBackdrop.contentMode = .scaleAspectFill
        
        // Movie Rate attributes
        movieRate.layer.masksToBounds = true
        movieRate.layer.cornerRadius = 15
    }
}
