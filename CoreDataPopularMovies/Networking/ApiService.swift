//
//  ApiService.swift
//  CoreDataPopularMovies
//
//  Created by Val Po on 02.02.2023.
//

import Foundation

final class ApiService {
    private var dataTask: URLSessionDataTask?
    
    
    // MARK: - Ger popular movies data
    func getPopularMoviesData(completion: @escaping (Result<MoviesData, Error>) -> Void) {
        let popularMoviesURL = "https://api.themoviedb.org/3/movie/popular?api_key=4e0be2c22f7268edffde97481d49064a&language=en-US&page=1"
        guard let url = URL(string: popularMoviesURL) else { return }
        
        // Create URL Session - work on the background
        dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            // Handle error
            if let error = error {
                completion(.failure(error))
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            
            // Response
            guard let response = response as? HTTPURLResponse else {
                // Handle empty response
                print("Empty response")
                return
            }
            print("Response status code: \(response.statusCode)")
            
            guard let data = data else {
                // Handle empty data
                print("Empty Data")
                return
            }
            do {
                // Parse the data
                let jsonData = try JSONDecoder().decode(MoviesData.self, from: data)
                // Back to the main thread
                DispatchQueue.main.async {
                    completion(.success(jsonData))
                }
            } catch let error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        dataTask?.resume()
    }
    
    // MARK: - Get image data
    func getImageDatafrom(url: URL, comletion: @escaping (Data) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                // Handle empty error
                print("Empty error")
                return
            }
            
            DispatchQueue.main.async {
                comletion(data)
            }
        }.resume()
    }
}
