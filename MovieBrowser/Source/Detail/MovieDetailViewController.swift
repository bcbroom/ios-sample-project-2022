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
  
  // not called, but compiler complains if it's missing
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  init?(movie: Movie, coder: NSCoder) {
    self.selectedMovie = movie
    super.init(coder: coder)
  }
  
  override func viewDidLoad() {
    titleLabel.text = selectedMovie.title
    releaseDateLabel.text = selectedMovie.releaseDate
    descriptionTextView.text = selectedMovie.overview
    
    if let posterURL = selectedMovie.posterPath {
      Network.fetchPosterImage(from: posterURL) { image in
        self.posterImageView.image = image
      }
    }
    
    let exclusionRectConverted = posterImageView.bounds
    descriptionTextView.textContainer.exclusionPaths = [UIBezierPath(rect: exclusionRectConverted)]
  }
  
}
