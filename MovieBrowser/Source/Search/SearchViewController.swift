//
//  SearchViewController.swift
//  MovieBrowser
//
//  Created by Brian Broom on 3/9/22.
//  Copyright © 2022 Lowe's Home Improvement. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
  
  @IBOutlet var tableView: UITableView!
  @IBOutlet var searchBar: UISearchBar!
  @IBOutlet var activityIndicator: UIActivityIndicatorView!
  
  let inputDateFormatter = DateFormatter()
  let outputDateFormatter = DateFormatter()
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    inputDateFormatter.locale = Locale(identifier: "en_US_POSIX")
    inputDateFormatter.dateFormat = "yyyy-MM-dd"
    
    outputDateFormatter.locale = Locale.current
    outputDateFormatter.dateStyle = .long
  }
  
  var searchResults = [Movie]() {
    didSet {
      tableView.reloadData()
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    if let selectedIndexPath = tableView.indexPathForSelectedRow {
      tableView.deselectRow(at: selectedIndexPath, animated: true)
    }
  }
  
  @IBAction func searchButtonTapped() {
    
    if let searchText = searchBar?.text {
      if searchText.isEmpty {
        showEmptySearchError()
        return
      }
      
      searchResults = [Movie]()
      activityIndicator.startAnimating()
      
      Network.fetchMovies(matching: searchText) { result in
        self.activityIndicator.stopAnimating()
        
        switch result {
          case .failure(let error):
            print("Failure: \(error)")
            self.showNetworkError()
          case .success(let list):
            self.searchResults = list
        }
      }
    }
  }
  
  private func showNetworkError() {
    let alertController = UIAlertController(title: "Error", message: "Please try again later.", preferredStyle: .alert)
    let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(okButton)
    present(alertController, animated: true, completion: nil)
  }
  
  private func showEmptySearchError() {
    let alertController = UIAlertController(title: "Error", message: "Please enter a search term and try again.", preferredStyle: .alert)
    let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(okButton)
    present(alertController, animated: true, completion: nil)
  }
  
  @IBSegueAction func makeMovieDetailViewController(_ coder: NSCoder) -> MovieDetailViewController? {
    if let selectedRow = tableView.indexPathForSelectedRow?.row {
      return MovieDetailViewController(movie: searchResults[selectedRow], coder: coder)
    }
    return nil
  }
}

extension SearchViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    searchButtonTapped()
  }
}

extension SearchViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return searchResults.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    // There is a lot of logic here - I'd want to break this out into a VM like object to do the transformations
    // that would enable this part to be better tested, and result in simple bindings there, such as
    // cell.releaseDateLabel.text = cellViewModel.releaseDate
    // cell.ratingLabel.text = cellViewModel.rating
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieResultCell
    let movie = searchResults[indexPath.row]
    
    if let releaseDate = movie.releaseDate,
       let parsedDate = inputDateFormatter.date(from: releaseDate) {
      cell.releaseDateLabel.text = outputDateFormatter.string(from: parsedDate)
    } else {
      cell.releaseDateLabel.text = "Not available"
    }
    
    cell.titleLabel.text = movie.title
    
    if let rating = movie.voteAverage {
      cell.ratingLabel.text = String(format: "%0.1f", rating)
    } else {
      cell.ratingLabel.text = "N/A"
    }
    
    return cell
  }
  
  
  
}
