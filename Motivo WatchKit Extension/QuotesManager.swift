//
//  QuotesManager.swift
//  Quote of the day WatchKit Extension
//
//  Created by Mahmoud Alsamman on 21/07/2020.
//  Copyright © 2020 Mahmoud Alsamman. All rights reserved.
//

import Foundation
import WatchKit

struct QuotesResponse: Codable {
    var long: [Quote]
    var short: [Quote]
    
    enum CodingKeys: String, CodingKey {
        case long = "longQuotes"
        case short = "shortQuotes"
    }
}

class QuotesManager {
    
    private var long = [Quote]()
    private var short = [Quote]()
    
    static let shared = QuotesManager()
    
    private init() { }
    
    private func fetchQuotes(completion: @escaping (Result<QuotesResponse,Error>) -> Void) {
        
        guard let url = URL(string: "https://motivo-8d3b1.firebaseio.com/quotes.json") else { return }
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
    
    func getLongQuote(compltion: @escaping (Quote) -> Void) {
        if long.isEmpty {
            fetchQuotes() { result in
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
        let random = short.randomElement()
        let quote = random?.text
        return quote ?? "You can do it!"
    }
    
    func updateQuotes() {
        fetchQuotes { [weak self] _ in
            self?.updateTimelineEntries()
            self?.scheduleBackgroundRefreshTasks()
        }
    }
    
    private func updateTimelineEntries() {
        let server = CLKComplicationServer.sharedInstance()
        server.activeComplications?.forEach { server.reloadTimeline(for: $0) }
    }
    
    private func scheduleBackgroundRefreshTasks() {
        // Get the shared extension object.
        let watchExtension = WKExtension.shared()
        // updates after 8 hours.
        let targetUpdateTime = Date(timeIntervalSinceNow: 8 * 60 * 60)
        // Schedule the background refresh task.
        watchExtension.scheduleBackgroundRefresh(withPreferredDate: targetUpdateTime, userInfo: nil) { (error) in
            // Check for errors.
            if let error = error {
                print("*** background refresh error occurred: \(error.localizedDescription) ***")
                return
            }
            print("*** Background Task Completed Successfully! ***")
        }
    }
}
