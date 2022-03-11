//
//  Network.swift
//  SampleApp
//
//  Created by Struzinski, Mark - Mark on 9/17/20.
//  Copyright © 2020 Lowe's Home Improvement. All rights reserved.
//

import UIKit

enum NetworkError: Error {
  case notFound
  case invalidURL
  case serverError
  case invalidData
}

class Network {
  private static let apiKey = "5885c445eab51c7004916b9c0313e2d3"
  private static let apiBaseURL = "api.themoviedb.org"
  private static let searchURL = "/3/search/movie"
  
  // I'd want to break this up, but the details would vary from team to team
  // The problem here is that this has to be duplicated for each network call, with most of it being
  // exact duplication. I'll outline the different pieces that I'd want to split out
  class func fetchMovies(matching searchTerm: String, completion: @escaping (Result<[Movie], NetworkError>) -> Void) {
    
    // Part One: The URL
    // This could be split out - either into a Request builder module, or maybe as part of the model itself
    // Should probably be built from a base request that would handle things like authentication that would be needed
    // on every request
    var components = URLComponents()
    components.scheme = "https"
    components.host = apiBaseURL
    components.path = searchURL
    let apiItem = URLQueryItem(name: "api_key", value: apiKey)
    let searchItem = URLQueryItem(name: "query", value: searchTerm)
    components.queryItems = [apiItem, searchItem]
    
    guard let url = components.url else {
      completion(.failure(.invalidURL))
      return
    }
    
    // end part one
        
    // Part Two: almost every JSON request will look exactly alike here
    // I'd want to pass in a URLSession object so that it could be mocked for testing
    URLSession.shared.dataTask(with: url) { data, response, error in
      
      guard error == nil,
            let data = data,
            let response = response as? HTTPURLResponse else {
              DispatchQueue.main.async {
                completion(.failure(.serverError))
              }
              return
            }
      
      if (300...599).contains(response.statusCode) {
        DispatchQueue.main.async {
          completion(.failure(.serverError))
        }
        return
      }
      
      do {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        // Part Three: This is the only variation for different requests. I've built this before as a generic
        // where you give it something like <T: Codable>
        // I'd want this piece to live in a seperate class so that I could pass in various JSON bits to test edge cases
        let movieList = try decoder.decode(MovieResponse.self, from: data)
        DispatchQueue.main.async {
          completion(.success(movieList.results))
        }
      } catch let error {
        print(error)
        DispatchQueue.main.async {
          completion(.failure(.invalidData))
        }
      }
      
    }.resume()
  }
  
  // I kind of cheated here - I used PostMan to pull the current value of their configuration
  // In a real app I'd want to actually make that call, and persist things like the base url and
  // options for poster size. The API docs said to cache results, and this could be considered
  // a very crude cache.
  class func fetchPosterImage(from: String, completion: @escaping (UIImage) -> Void) {
    var components = URLComponents(string: "https://image.tmdb.org/t/p/")
    let size = "/w500/"
    components?.path.append(size)
    components?.path.append(from)
      
    if let url = components?.url {
      URLSession.shared.dataTask(with: url) { data, response, error in
        if let data = data,
           let image = UIImage(data: data) {
          DispatchQueue.main.async {
            completion(image)
          }
        }
      }.resume()
    }
    
    
  }
}
