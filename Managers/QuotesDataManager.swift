//
//  QuotesDataManager.swift
//  Quote of the day WatchKit Extension
//
//  Created by Mahmoud Alsamman on 02/12/2020.
//  Copyright © 2020 Mahmoud Alsamman. All rights reserved.
//

import Foundation

class QuotesDataManager: APIClient {
    
    private var longQuotes: [Quote] = []
    private var shortQuotes: [Quote] = []

    static let shared = QuotesDataManager()
    private init() {}

    func updateQuotes(completion: @escaping (Result<QuotesResponse, Error>) -> Void) {
        fetchQuotes { [weak self] result in
            guard let self = self else { return }
            let finalResult: Result<QuotesResponse, Error>
            switch result {
            case let .success(quotes):
                self.longQuotes = quotes.longQuotes
                self.shortQuotes = quotes.shortQuotes
                finalResult = .success(quotes)
            case let .failure(error):
                finalResult = .failure(error)
                print(error)
            }
            DispatchQueue.main.async {
                completion(finalResult)
            }
        }
    }

    func getLongQuote(completion: @escaping (Quote?) -> Void) {
        guard longQuotes.isEmpty else {
            completion(longQuotes.randomElement())
            return
        }
        updateQuotes { result in
            switch result {
            case let .failure(error):
                completion(Quote(text: error.localizedDescription))
            case let .success(quote):
                completion(quote.longQuotes.randomElement())
            }
        }
    }

    func getRandomShortQuote() -> String {
        let random = shortQuotes.randomElement()
        let quote = random?.text
        return quote ?? "You can do it!"
    }
}
