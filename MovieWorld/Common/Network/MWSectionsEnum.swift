//
//  MWSectionsEnum.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 5/2/20.
//  Copyright © 2020 Clevertec. All rights reserved.
//

import Foundation

enum MWSectionsEnum {
    case nowPlaying
    case popularMovies
    case topRatedMovies
    case upcomingMovies
    case paramountMovies
    case disasterMovies
    case postApocalyptic
    case sonyMovies
    case aboutKillers
    case joaquinPhoenix
    case parentChildRelationships
    case cyberpunkMovies

    func getSection() -> MWSection {
        switch self {
        case .nowPlaying:
            return MWSection(name: "Now Playing", url: MWURLPaths.nowPlayingMovies)
        case .popularMovies:
            return MWSection(name: "Popular Movies", url: MWURLPaths.popularMovies)
        case .topRatedMovies:
            return MWSection(name: "Top Rated Movies", url: MWURLPaths.topRatedMovies)
        case .upcomingMovies:
            return MWSection(name: "Upcoming Movies", url: MWURLPaths.upcomingMovies)
        case .paramountMovies:
            return MWSection(
                name: "Paramount Movies",
                url: MWURLPaths.discoverMovie,
                parameters: ["with_companies": "4"])
        case .disasterMovies:
            return MWSection(
                name: "Disaster movies",
                url: MWURLPaths.discoverMovie,
                parameters: ["with_keywords": "5096"])
        case .postApocalyptic:
            return MWSection(
                name: "Post-apocalyptic movies",
                url: MWURLPaths.discoverMovie,
                parameters: ["with_keywords": "4458"])
        case .sonyMovies:
            return MWSection(
                name: "Sony movies",
                url: MWURLPaths.discoverMovie,
                parameters: ["with_companies": "34"])
        case .aboutKillers:
            return MWSection(
                name: "Movies about killers",
                url: MWURLPaths.discoverMovie,
                parameters: ["with_keywords": "232384"])
        case .joaquinPhoenix:
            return MWSection(
                name: "Movies with Joaquin Phoenix",
                url: MWURLPaths.discoverMovie,
                parameters: ["with_people": "73421"])
        case .parentChildRelationships:
            return MWSection(
                name: "Movies about parent-child relationships",
                url: MWURLPaths.discoverMovie,
                parameters: ["with_keywords": "970"])
        case .cyberpunkMovies:
            return MWSection(
                name: "Cyberpunk movies",
                url: MWURLPaths.discoverMovie,
                parameters: ["with_keywords": "12190"])
        }
    }
}
