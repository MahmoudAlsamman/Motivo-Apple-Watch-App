//
//  APIClient.swift
//  Motivo WatchKit Extension
//
//  Created by Mahmoud Alsamman on 06/02/2021.
//  Copyright © 2021 Mahmoud Alsamman. All rights reserved.
//

import Foundation

protocol APIClient: AnyObject {
    func fetchQuotes(completion: @escaping (Result<QuotesResponse,Error>) -> Void)
}

extension APIClient {
    func fetchQuotes(completion: @escaping (Result<QuotesResponse,Error>) -> Void) {
        guard let url = URL(string: "https://motivo-8d3b1.firebaseio.com/quotes.json") else {
            assertionFailure("Invalid URL")
            return
        }
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { (data, _, error) in
            if let error = error {
                completion(.failure(error))
            }
            
            if let data = data {
                do {
                    let quotes = try JSONDecoder().decode(QuotesResponse.self, from: data)
                    completion(.success(quotes))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}
