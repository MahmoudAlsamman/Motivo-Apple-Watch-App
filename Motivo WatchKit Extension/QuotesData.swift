//
//  NetworkService.swift
//  Quote of the day WatchKit Extension
//
//  Created by Mahmoud Alsamman on 21/07/2020.
//  Copyright © 2020 Mahmoud Alsamman. All rights reserved.
//

import Foundation
import WatchKit

class QuotesData {
    
    private var long = [Quote]()
    private var short = [Quote]()
    
    static let shared = QuotesData()
    
    private init() { }
    
    func fetchNewQuotes(completion: @escaping (Result<QuotesResponse,Error>) -> (Void)) {
        
        guard let url = URL(string: "https://motivo---motivational-quotes.firebaseio.com/quotes.json") else {return}
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { (data, _, error) in
            if let error = error {
                completion(.failure(error))
            }
            
            if let data = data {
                do {
                    let quotes = try JSONDecoder().decode(QuotesResponse.self, from: data)
                    self.long = quotes.long
                    self.short = quotes.short
                    completion(.success(quotes))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    func getRandomQuote(compltion: @escaping (Quote)->()) {
        if long.isEmpty {
            fetchNewQuotes { result in
                switch result {
                case .failure(let error):
                    compltion(Quote(text: error.localizedDescription))
                case .success(let quote):
                    compltion(quote.long.randomElement()!)
                }
            }
        } else {
            compltion(long.randomElement()!)
        }
    }
    
    func getRandomShortQuote() -> String {
        let random =  short.randomElement()
        let quote = random?.text
        return quote ?? "Yes you can"
    }
}

 struct QuotesResponse: Codable {
    var long: [Quote]
    var short: [Quote]
    
    enum CodingKeys: String, CodingKey {
        case long = "longQuotes"
        case short = "shortQuotes"
    }
}

