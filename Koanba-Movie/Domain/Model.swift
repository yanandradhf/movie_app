//
//  PopularMovie.swift
//  Koanba-Movie
//
//  Created by Yanandra Dhafa on 10/07/24.
//

import Foundation

struct Genre {
    let id: Int
    let name: String
}

struct GenresResponseDTO: Codable {
    let genres: [GenreDTO]
}

struct GenreDTO: Codable {
    let id: Int
    let name: String
}

struct Movie : Codable {
    let id: Int
    let title: String
    let overview: String
    let releaseDate: String
    let posterPath: String
    let genreNames: [String]
}

struct MovieResponseDTO: Codable {
    let results: [MovieDTO]
}

struct MovieDTO: Codable {
    let id: Int
    let title: String
    let overview: String?
    let releaseDate: String?
    let posterPath: String?
    let backdropPath: String? 
    let genreIds: [Int]
    
    private enum CodingKeys: String, CodingKey {
        case id, title, overview
        case releaseDate = "release_date"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case genreIds = "genre_ids"
    }
}

struct MovieDetail  {
    let id: Int
    let backdropPath: String?
    let releaseDate: String?
    let runtime : Int?
    let posterPath : String?
    let overview: String?
    let title: String
    let genres: [Genre]
}

struct MovieDetailDTO: Codable {
    let id: Int
    let title: String
    let backdropPath: String?
    let releaseDate: String?
    let overview: String?
    let genres: [GenreDTO]?
    let posterPath : String?
    let runtime : Int?
    
    private enum CodingKeys: String, CodingKey {
        case id, title, overview,runtime,genres
        case releaseDate = "release_date"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
       
    }
}

struct Cast {
   
    let name: String
    let profilePath: String
 
}

struct CastResponseDTO: Codable {
    let cast: [CastDTO]
}

struct CastDTO: Codable {
    let name: String?
    let profilePath: String?
    
    
    private enum CodingKeys: String, CodingKey {
        case name
        case profilePath = "profile_path"
      
    }
}
