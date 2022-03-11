//
//  Movie.swift
//  MovieBrowser
//
//  Created by Brian Broom on 3/7/22.
//  Copyright © 2022 Lowe's Home Improvement. All rights reserved.
//

import Foundation

struct MovieResponse: Codable {
  let page: Int?
  let results: [Movie]
  let totalResults: Int?
  let totalPages: Int?
}

struct Movie: Codable {
  let title: String?
  let releaseDate: String?
  let posterPath: String?
  let overview: String?
  let voteAverage: Double?
  
//  static func sample() -> Movie {
//    return Movie(title: "Fake Movie Name",
//                 relaseDate: Date(),
//                 imageURLString: "http://example.com/image/1234",
//                 descriptionText: "Morbi ullamcorper laoreet lacus, ac aliquet neque convallis ac. Nullam non risus iaculis, egestas tortor non, aliquet est. Cras vel dignissim sem. Nam vestibulum, libero eget varius imperdiet, leo quam sodales sem, quis hendrerit nisi magna non odio. Duis leo mauris, euismod sit amet tristique ut, dapibus sed justo. Vivamus sollicitudin arcu in ante faucibus rhoncus. Cras pretium libero sodales tellus cursus, eget ornare libero ornare. Nullam quis egestas sem. \n Etiam sem elit, sagittis sed neque sit amet, sollicitudin varius odio. Aliquam sollicitudin commodo justo, ac dictum neque porttitor et. Vivamus congue elit vitae imperdiet tempor. Fusce a metus placerat, posuere ipsum sed, rutrum magna. Nunc scelerisque condimentum augue, ac mattis risus aliquet ac. Pellentesque ut elit vitae dolor fringilla imperdiet. Vestibulum id nisl lectus.",
//                 rating: 9.3678976)
//  }
//
//  static func sampleList() -> [Movie] {
//    var results = [Movie]()
//    for _ in 0..<10 {
//      results.append(Movie.sample())
//    }
//    return results
//  }
}
