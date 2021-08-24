//
//  InterfaceController.swift
//  Quote of the day WatchKit Extension
//
//  Created by Mahmoud Alsamman on 21/07/2020.
//  Copyright © 2020 Mahmoud Alsamman. All rights reserved.
//

import WatchKit

class InterfaceController: WKInterfaceController {
    
    // MARK: - Properties
    
    let quotesManager = QuotesDataManager.shared

    @IBOutlet var quoteTextLabel: WKInterfaceLabel!
    @IBOutlet var quoteAuthorLabel: WKInterfaceLabel!

    // MARK: - LifeCycle
    
    override func willActivate() {
        super.willActivate()
        updateViewWithNewQuote()
    }
    
    // MARK: - Methods

    @IBAction func tapped(_: Any) {
        updateViewWithNewQuote()
    }

    private func updateViewWithNewQuote() {
        quotesManager.getLongQuote { [weak self] quote in
            self?.quoteTextLabel.setText(quote?.text)
            self?.quoteAuthorLabel.setText(quote?.author)
        }
    }
}
