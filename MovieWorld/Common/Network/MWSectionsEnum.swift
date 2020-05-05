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
        }
    }
}
