//
//  InterfaceController.swift
//  Quote of the day WatchKit Extension
//
//  Created by Mahmoud Alsamman on 21/07/2020.
//  Copyright © 2020 Mahmoud Alsamman. All rights reserved.
//

import WatchKit


class InterfaceController: WKInterfaceController {
    
    lazy var data = QuotesData.shared
    
    @IBOutlet weak var quoteText: WKInterfaceLabel!
    @IBOutlet weak var quoteAuthor: WKInterfaceLabel!
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }
    
    override func willActivate() {
        super.willActivate()
        updateViewWithNewQuote()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
    
    @IBAction func tapped(_ sender: Any) {
        updateViewWithNewQuote()
    }
    
    private func updateViewWithNewQuote() {
        data.getRandomQuote { [weak self] quote in
            DispatchQueue.main.async {
                self?.quoteText.setText(quote.text)
                self?.quoteAuthor.setText(quote.author)
            }
        }
    }
    
}
