//
//  InterfaceController.swift
//  Quote of the day WatchKit Extension
//
//  Created by Mahmoud Alsamman on 21/07/2020.
//  Copyright © 2020 Mahmoud Alsamman. All rights reserved.
//

import WatchKit


class InterfaceController: WKInterfaceController {
    
    let quotesManager = QuotesDataManager.shared
    
    @IBOutlet weak var quoteTextLabel: WKInterfaceLabel!
    @IBOutlet weak var quoteAuthorLabel: WKInterfaceLabel!
    
    override func willActivate() {
        super.willActivate()
        updateViewWithNewQuote()
    }
    
    @IBAction func tapped(_ sender: Any) {
        updateViewWithNewQuote()
    }
    
    private func updateViewWithNewQuote() {
        quotesManager.getLongQuote { [weak self] quote in
            self?.quoteTextLabel.setText(quote?.text)
            self?.quoteAuthorLabel.setText(quote?.author)
        }
    }
}
