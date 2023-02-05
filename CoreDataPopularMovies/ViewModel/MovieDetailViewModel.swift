//
//  MovieDetailViewModel.swift
//  CoreDataPopularMovies
//
//  Created by Val Po on 03.02.2023.
//

import UIKit

final class MovieDetailViewModel {
    let movieDetails: MoviesEntity?
    
    let title: String?
    let rate: String?
    let year: String?
    let overview: String?
    let posterImage: String?
    
    init(movieDetails: MoviesEntity?) {
        self.movieDetails = movieDetails
        self.title = movieDetails?.title
        self.rate = movieDetails?.rate
        self.year = MovieDetailViewModel.convertDateFormat(movieDetails?.year)
        self.overview = movieDetails?.overview
        self.posterImage = "https://image.tmdb.org/t/p/w300" + (movieDetails?.posterImage)!
        
    }
    
    private static func convertDateFormat(_ date: String?) -> String {
        var dateOutput = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let dateInput = date {
            if let newDate = dateFormatter.date(from: dateInput) {
                dateFormatter.dateFormat = "MMM d, yyyy"
                dateOutput = dateFormatter.string(from: newDate)
            }
        }
        return dateOutput
    }
}
