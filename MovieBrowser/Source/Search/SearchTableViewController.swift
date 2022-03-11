//
//  SearchViewController.swift
//  SampleApp
//
//  Created by Struzinski, Mark on 2/19/21.
//  Copyright © 2021 Lowe's Home Improvement. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController {
  
  var searchResults = [Movie]()
  var searchBar: UISearchBar?
  var searchButton: UIButton?
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return 1
    default:
      return searchResults.count
    }
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0:
      let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchCell
      searchBar = cell.searchBar
      searchButton = cell.searchButton
      searchButton?.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
      cell.separatorInset = UIEdgeInsets.zero
      return cell
      
    default:
      let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieResultCell
      let movie = searchResults[indexPath.row]
      cell.titleLabel.text = movie.title
      cell.releaseDateLabel.text = movie.releaseDate
      if let rating = movie.voteAverage {
        cell.ratingLabel.text = String(format: "%0.1f", rating)
      } else {
        cell.ratingLabel.text = "N/A"
      }
      
      return cell
    }
  }

  @objc func buttonTapped() {
    
    if let searchText = searchBar?.text {
      if searchText.isEmpty {
        showEmptySearchError()
      }
      
      Network.fetchMovies(matching: searchText) { result in
        switch result {
        case .failure(let error):
          print("Failure: \(error)")
          self.showNetworkError()
        case .success(let list):
          print("Success")
          self.searchResults = list
          self.tableView.reloadData()
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
