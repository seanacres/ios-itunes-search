//
//  SearchResultsTableViewController.swift
//  ITunes Search
//
//  Created by Sean Acres on 7/9/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import UIKit

class SearchResultsTableViewController: UITableViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let searchResultsController = SearchResultController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResultsController.searchResults.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath)
        let searchResult = searchResultsController.searchResults[indexPath.row]
        
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.creator

        return cell
    }
    
    @IBAction func segmentChanged(_ sender: Any) {
        
    }
    
}

extension SearchResultsTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text, searchTerm != "" else { return }
        
        var resultType: ResultType
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            resultType = .software
        case 1:
            resultType = .musicTrack
        case 2:
            resultType = .movie
        default:
            resultType = .software
        }
        
        searchResultsController.performSearch(searchTerm: searchTerm, resultType: resultType) { (error) in
            if let error = error {
                print("error performing search for software: \(error)")
            } else {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
        self.searchBar.endEditing(true)
    }
}
