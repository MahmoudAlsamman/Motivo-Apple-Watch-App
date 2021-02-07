//
//  QuotesResponse.swift
//  Motivo WatchKit Extension
//
//  Created by Mahmoud Alsamman on 06/02/2021.
//  Copyright © 2021 Mahmoud Alsamman. All rights reserved.
//

struct QuotesResponse: Codable {
    var longQuotes: [Quote]
    var shortQuotes: [Quote]
}
