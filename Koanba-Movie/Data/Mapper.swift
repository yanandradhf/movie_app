//
//  Mapper.swift
//  Koanba-Movie
//
//  Created by Yanandra Dhafa on 10/07/24.
//

import Foundation

struct GenreMapper {
    static func map(dto: GenreDTO) -> Genre {
        return Genre(id: dto.id, name: dto.name)
    }
    
    static func map(dtoList: [GenreDTO]) -> [Genre] {
        return dtoList.map { map(dto: $0) }
    }
}

struct MovieMapper {
    static func map(dto: MovieDTO, genres: [Genre]) -> Movie {
        let genreNames = dto.genreIds.compactMap { genreId in
            genres.first { $0.id == genreId }?.name
        }
        return Movie(
            id: dto.id,
            title: dto.title,
            overview: dto.overview ?? "",
            releaseDate: dto.releaseDate ?? "",
            posterPath: dto.posterPath ?? "",
            genreNames: genreNames
        )
    }
    
    static func map(dtoList: [MovieDTO], genres: [Genre]) -> [Movie] {
        return dtoList.map { map(dto: $0, genres: genres) }
    }
}

struct MovieDetailMapper {
    static func map(dto: MovieDetailDTO) -> MovieDetail {
        let genres = dto.genres?.compactMap { Genre(id: $0.id, name: $0.name) } ?? []
        
        return MovieDetail(
            id: dto.id,
            backdropPath: dto.backdropPath,
            releaseDate: dto.releaseDate,
            runtime: dto.runtime,
            posterPath: dto.posterPath,
            overview: dto.overview,
            title: dto.title,
            genres: genres
        )
    }
}

struct CastMapper {
    static func map(dto: CastDTO) -> Cast {
        return Cast(
            name: dto.name ?? "",
            profilePath: dto.profilePath ?? ""
        )
    }
    
    static func map(dtoList: [CastDTO]) -> [Cast] {
        return dtoList.map { map(dto: $0) }
    }
}
