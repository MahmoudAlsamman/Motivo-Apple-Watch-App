//
//  ComplicationController.swift
//  Quote of the day WatchKit Extension
//
//  Created by Mahmoud Alsamman on 27/07/2020.
//  Copyright © 2020 Mahmoud Alsamman. All rights reserved.
//

import ClockKit

class ComplicationController: NSObject, CLKComplicationDataSource {
    
    let manager = QuotesDataManager.shared
    
    // Define whether complication data is visible when Watch is locked.
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }
    
    // MARK: Register Placeholder
    
    // presents the placeholder for the complications
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        handler(createTemplate(for: complication))
    }
    
    // MARK: Provide Data
    
    //presents provided data on the complication at a specific time - in our case is current time
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        let currentTime = Date()
        handler(createTimelineEntry(for: complication, and: currentTime))
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        
        let fiveMinutes = 5.0 * 60.0
        let twentyFourHours = 24.0 * 60.0 * 60.0
        
        // Create an array to hold the timeline entries.
        var entries = [CLKComplicationTimelineEntry]()
        
        // Calculate the start and end dates.
        var current = date.addingTimeInterval(fiveMinutes)
        let endDate = date.addingTimeInterval(twentyFourHours)
        
        // Create a timeline entry for every five minutes from the starting time.
        // Stop once you reach the limit or the end date.
        while (current.compare(endDate) == .orderedAscending) &&
                (entries.count < limit) {
            guard let timeline = createTimelineEntry(for: complication, and: current) else { return }
            entries.append(timeline)
            current = current.addingTimeInterval(fiveMinutes)
        }
        handler(entries)
    }
    
    //MARK: Helpers
    
    // Creates the correct template according to the complication's family
    private func createTemplate(for complication: CLKComplication) -> CLKComplicationTemplate? {
        let quote = manager.getRandomShortQuote()
        switch complication.family {
        case .modularLarge:
            return createModularLargeTemplate(with: quote)
        case .utilitarianLarge:
            return createUtilitarianLargeTemplate(with: quote)
        case .graphicBezel:
            return createGraphicBezelTemplate(with: quote)
        case .graphicRectangular:
            return createGraphicRectangularTemplate(with: quote)
        case .graphicCircular, .modularSmall, .utilitarianSmall, .utilitarianSmallFlat, .circularSmall, .graphicCorner, .extraLarge, .graphicExtraLarge:
            return nil
        @unknown default:
            fatalError("*** Unknown Complication Family ***")
        }
    }
    
    // Creates the timeline entry for a specified date for the complication's family
    private func createTimelineEntry(for complication: CLKComplication, and date: Date) -> CLKComplicationTimelineEntry? {
        guard let template = createTemplate(for: complication) else {
            return nil
        }
        let entry = CLKComplicationTimelineEntry(date: date, complicationTemplate: template)
        return entry
    }
    
    //MARK: - Create Templates
    
    private func createModularLargeTemplate(with quote: String) -> CLKComplicationTemplate {
        // Set providers for the template
        let  header = CLKSimpleTextProvider(text: "")
        let quote = CLKTextProvider(format: quote)
        // Create template user providers
        let template = CLKComplicationTemplateModularLargeStandardBody()
        template.headerTextProvider = header
        template.body1TextProvider = quote
        return template
    }
    
    private func createUtilitarianLargeTemplate(with quote: String) -> CLKComplicationTemplate {
        // Set providers for the template
        let quote =  CLKSimpleTextProvider(text: quote)
        // Create the template using the providers.
        let template = CLKComplicationTemplateUtilitarianLargeFlat()
        template.textProvider = quote
        return template
    }
    
    private func createGraphicRectangularTemplate(with quote: String) -> CLKComplicationTemplate {
        // Set providers for the template
        let  header = CLKSimpleTextProvider(text: "")
        let quote =  CLKSimpleTextProvider(text: quote)
        // Create the template using the providers.
        let template = CLKComplicationTemplateGraphicRectangularStandardBody()
        template.headerTextProvider = header
        template.body1TextProvider = quote
        return template
    }
    
    private func createGraphicBezelTemplate(with quote: String) -> CLKComplicationTemplate {
        // Set providers for the template
        let circularImage = CLKFullColorImageProvider(fullColorImage: UIImage(named: "Complication/Graphic Circular")!)
        let quote =  CLKSimpleTextProvider(text: quote)
        // Create a graphic circular template with an image provider.
        let circle = CLKComplicationTemplateGraphicCircularImage()
        circle.imageProvider = circularImage
        let template = CLKComplicationTemplateGraphicBezelCircularText()
        template.textProvider = quote
        template.circularTemplate = circle
        return template
    }
}
