//
//  HomeViewModel.swift
//  Koanba-Movie
//
//  Created by Yanandra Dhafa on 10/07/24.
//

import Foundation
import Combine

class MoviesViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    @Published var hasError: Bool = false
     var cancellables = Set<AnyCancellable>()
    
   
    @Published var currentPage: Int = 1
    @Published var isFetchingMore: Bool = false
    
    private var genres: [Genre] = []
    
    
    func fetchMovies(query: String, page: Int) {
        isLoading = true
        isFetchingMore = true
        hasError = false
        let fetchGenresPublisher = NetworkManager.shared.fetchGenres()
            .map { GenreMapper.map(dtoList: $0.genres) }
            .handleEvents(receiveOutput: { [weak self] genres in
                self?.genres = genres
            })
            .eraseToAnyPublisher()
        
        let fetchMoviesPublisher = NetworkManager.shared.searchMovies(query: query, page: page)
            .eraseToAnyPublisher()
        
        Publishers.Zip(fetchGenresPublisher, fetchMoviesPublisher)
            .map { (genres, movieResponse) in
                MovieMapper.map(dtoList: movieResponse.results, genres: genres)
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                self?.isFetchingMore = false
                
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    self?.hasError = true 
                    if let savedMoviesData = UserDefaults.standard.data(forKey: "savedMovies") {
                        do {
                             let decoder = JSONDecoder()
                             let movies = try decoder.decode([Movie].self, from: savedMoviesData)
                            self?.movies = movies
                          } catch {
                          print("Error decoding saved movies data: \(error.localizedDescription)")
                        }
                     }
                  }
               }, receiveValue: { [weak self] movies in
                if page == 1 {
                    self?.movies = movies
                } else {
                    self?.movies.append(contentsOf: movies)
                }
                self?.saveMoviesToUserDefaults()
            })
            .store(in: &cancellables)
    }
     func saveMoviesToUserDefaults() {
        do {
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(movies)
            UserDefaults.standard.set(encodedData, forKey: "savedMovies")
        } catch {
            print("Error encoding movies data: \(error.localizedDescription)")
        }
    }
    
    func searchMoviesLocally(query: String) {
           if let savedMoviesData = UserDefaults.standard.data(forKey: "savedMovies") {
               do {
                   let decoder = JSONDecoder()
                   let movies = try decoder.decode([Movie].self, from: savedMoviesData)
                   let filteredMovies = movies.filter { $0.title.lowercased().contains(query.lowercased()) }
                   self.movies = filteredMovies
               } catch {
                   print("Error decoding saved movies data: \(error.localizedDescription)")
               }
           }
       }
    
}

