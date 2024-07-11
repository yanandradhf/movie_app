//
//  NetworkManager.swift
//  Koanba-Movie
//
//  Created by Yanandra Dhafa on 10/07/24.
//

import Foundation
import UIKit
import Combine

class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    private let baseURL = "https://api.themoviedb.org/3"
    private let apiKey = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyYTViZGQ4NGU0Zjc4OWE0OTIzY2RhMTU4MDczM2E5NSIsIm5iZiI6MTcyMDUzMTU1OC41MDkxOTIsInN1YiI6IjY2OGQzOTNjODVkMjFhZGUyYWFhNDVmMCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.yz32xKOyFdw22eO_U8p5YHfZpvQC4fq6Wz4TKvyISMw"
    private let session: URLSession = .shared
    
    private func createRequest(for endpoint: String, queryItems: [URLQueryItem]) -> URLRequest {
        var components = URLComponents(string: "\(baseURL)/\(endpoint)")!
        components.queryItems = queryItems
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(apiKey)"
        ]
        
        return request
    }
    
    func searchMovies(query: String, page: Int) -> AnyPublisher<MovieResponseDTO, Error> {
        let queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "include_adult", value: "false"),
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "page", value: "\(page)")
        ]
        
        let request = createRequest(for: "search/movie", queryItems: queryItems)
        
        return session.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: MovieResponseDTO.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    func fetchGenres() -> AnyPublisher<GenresResponseDTO, Error> {
        let queryItems = [URLQueryItem(name: "language", value: "en-US")]
        
        let request = createRequest(for: "genre/movie/list", queryItems: queryItems)
        
        return session.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: GenresResponseDTO.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func fetchMovieDetails(movieId: Int) -> AnyPublisher<MovieDetailDTO, Error> {
        let queryItems = [URLQueryItem(name: "language", value: "en-US")]
        
        let request = createRequest(for: "movie/\(movieId)", queryItems: queryItems)
        
        return session.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: MovieDetailDTO.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func fetchMovieCast(movieId: Int) -> AnyPublisher<CastResponseDTO, Error> {
        let queryItems = [URLQueryItem(name: "language", value: "en-US")]
        
        let request = createRequest(for: "movie/\(movieId)/credits", queryItems: queryItems)
        
        return session.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: CastResponseDTO.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
