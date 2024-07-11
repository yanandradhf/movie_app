//
//  DetailViewModel.swift
//  Koanba-Movie
//
//  Created by Yanandra Dhafa on 10/07/24.
//

import Foundation
import Combine

class MovieDetailViewModel: ObservableObject {
    
    @Published var movieDetail: MovieDetail?
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var cast: [Cast] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    func fetchMovieDetail(movieId: Int) {
        isLoading = true
        
        NetworkManager.shared.fetchMovieDetails(movieId: movieId)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.isLoading = false
                case .failure(let error):
                    self?.isLoading = false
                    self?.errorMessage = error.localizedDescription
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] movieDetail in
                self?.movieDetail = MovieDetailMapper.map(dto: movieDetail)
            }
            .store(in: &cancellables)
    }
    
    func fetchMovieCast(movieId: Int) {
        isLoading = true
        NetworkManager.shared.fetchMovieCast(movieId: movieId)
                  .sink { [weak self] completion in
                      switch completion {
                      case .finished:
                          self?.isLoading = false
                      case .failure(let error):
                          self?.isLoading = false
                          self?.errorMessage = error.localizedDescription
                          print(error.localizedDescription)
                      }
                  } receiveValue: { [weak self] castResponse in
                      self?.cast = CastMapper.map(dtoList: castResponse.cast )
                  }
                  .store(in: &cancellables)
          }
}
