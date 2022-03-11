//
//  MovieDetailViewController.swift
//  SampleApp
//
//  Created by Struzinski, Mark on 2/26/21.
//  Copyright © 2021 Lowe's Home Improvement. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
  
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var releaseDateLabel: UILabel!
  @IBOutlet var posterImageView: UIImageView!
  @IBOutlet var descriptionTextView: UITextView!
  
  private var selectedMovie: Movie
  private let inputDateFormatter = DateFormatter()
  private let outputDateFormatter = DateFormatter()
  
  // not called, but compiler complains if it's missing
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  init?(movie: Movie, coder: NSCoder) {
    self.selectedMovie = movie
    super.init(coder: coder)
    
    inputDateFormatter.locale = Locale(identifier: "en_US_POSIX")
    inputDateFormatter.dateFormat = "yyyy-MM-dd"
    
    outputDateFormatter.locale = Locale.current
    outputDateFormatter.dateStyle = .long
  }
  
  override func viewDidLoad() {
    titleLabel.text = selectedMovie.title
    releaseDateLabel.text = selectedMovie.releaseDate
    descriptionTextView.text = selectedMovie.overview
    
    // duplicated from Cell logic, but I'm not sure where it should end up
    // the parsing should probably live in the Network class, but that's setup with
    // static methods, so no good place for the formatters to live.
    if let releaseDate = selectedMovie.releaseDate,
       let parsedDate = inputDateFormatter.date(from: releaseDate) {
      releaseDateLabel.text = "Release Date: \(outputDateFormatter.string(from: parsedDate))"
    } else {
      releaseDateLabel.text = "Release Date not available"
    }
    
    if let posterURL = selectedMovie.posterPath {
      Network.fetchPosterImage(from: posterURL) { image in
        self.posterImageView.image = image
      }
    }
    
    let exclusionRectConverted = posterImageView.bounds
    descriptionTextView.textContainer.exclusionPaths = [UIBezierPath(rect: exclusionRectConverted)]
  }
  
}
