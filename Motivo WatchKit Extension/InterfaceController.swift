//
//  InterfaceController.swift
//  Quote of the day WatchKit Extension
//
//  Created by Mahmoud Alsamman on 21/07/2020.
//  Copyright © 2020 Mahmoud Alsamman. All rights reserved.
//

import WatchKit


class InterfaceController: WKInterfaceController {
    
    let manager = QuotesManager.shared
    
    @IBOutlet weak var quoteText: WKInterfaceLabel!
    @IBOutlet weak var quoteAuthor: WKInterfaceLabel!
    
    override func willActivate() {
        super.willActivate()
        updateViewWithNewQuote()
    }
    
    @IBAction func tapped(_ sender: Any) {
        updateViewWithNewQuote()
    }
    
    private func updateViewWithNewQuote() {
        manager.getLongQuote { [weak self] quote in
            DispatchQueue.main.async {
                self?.quoteText.setText(quote.text)
                self?.quoteAuthor.setText(quote.author)
            }
        }
    }
    
}
