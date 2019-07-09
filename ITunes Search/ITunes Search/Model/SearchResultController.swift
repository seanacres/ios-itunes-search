//
//  SearchResultController.swift
//  ITunes Search
//
//  Created by Sean Acres on 7/9/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import Foundation

class SearchResultController {
    
    enum NetworkError: Error {
        case otherError
        case badData
        case noDecode
        case noEncode
        case badResponse
    }
    
    let baseURL = URL(string: "https://itunes.apple.com/search")!
    var searchResults: [SearchResult] = []
    
    func performSearch(searchTerm: String, resultType: ResultType, completion: @escaping (NetworkError?) -> Void) {
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = [URLQueryItem(name: "term", value: searchTerm),
                          URLQueryItem(name: "entity", value: resultType.rawValue)]
 
        guard let requestURL = urlComponents?.url else { return }
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                NSLog("error fetching data with: \(error)")
                completion(.otherError)
                return
            }
            
            guard let data = data else {
                NSLog("no data")
                completion(.badData)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let searchResults = try decoder.decode(SearchResults.self, from: data)
                self.searchResults = searchResults.results
                completion(nil)
            } catch {
                NSLog("decoding failed: \(error)")
                completion(.noDecode)
            }
        }.resume()
    }
}
