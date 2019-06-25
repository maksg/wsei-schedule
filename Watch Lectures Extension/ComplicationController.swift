//
//  ComplicationController.swift
//  Watch Lectures Extension
//
//  Created by Maksymilian Galas on 19/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import ClockKit

private extension UIColor {
    static var main: UIColor { UIColor(named: "Main")! }
}

class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.forward, .backward])
    }
    
    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        let complicationTemplate: CLKComplicationTemplate?
        switch complication.family {
        case .circularSmall:
            let template = CLKComplicationTemplateCircularSmallSimpleImage()
            template.imageProvider = imageProvider(named: "Complication/Circular")
            complicationTemplate = template
        case .modularSmall:
            let template = CLKComplicationTemplateModularSmallSimpleImage()
            template.imageProvider = imageProvider(named: "Complication/Modular")
            complicationTemplate = template
        case .extraLarge:
            let template = CLKComplicationTemplateExtraLargeSimpleImage()
            template.imageProvider = imageProvider(named: "Complication/Extra Large")
            complicationTemplate = template
        case .graphicCircular:
            let template = CLKComplicationTemplateGraphicCircularImage()
            let image = UIImage(named: "Complication/Graphic Circular")!
            template.imageProvider = CLKFullColorImageProvider(fullColorImage: image)
            complicationTemplate = template
        default:
            complicationTemplate = nil
        }
        
        guard let template = complicationTemplate else {
            handler(nil)
            return
        }
        
        let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
        handler(timelineEntry)
    }
    
    func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries prior to the given date
        handler(nil)
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after to the given date
        handler(nil)
    }
    
    // MARK: - Placeholder Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        switch complication.family {
        case .circularSmall:
            let template = CLKComplicationTemplateCircularSmallSimpleImage()
            template.imageProvider = imageProvider(named: "Complication/Circular")
            handler(template)
        case .modularSmall:
            let template = CLKComplicationTemplateModularSmallSimpleImage()
            template.imageProvider = imageProvider(named: "Complication/Modular")
            handler(template)
        case .extraLarge:
            let template = CLKComplicationTemplateExtraLargeSimpleImage()
            template.imageProvider = imageProvider(named: "Complication/Extra Large")
            handler(template)
        case .graphicCircular:
            let template = CLKComplicationTemplateGraphicCircularImage()
            let image = UIImage(named: "Complication/Graphic Circular")!
            template.imageProvider = CLKFullColorImageProvider(fullColorImage: image)
            handler(template)
        default:
            handler(nil)
        }
    }
    
    private func imageProvider(named: String) -> CLKImageProvider {
        let imageProvider = CLKImageProvider(onePieceImage: UIImage(named: named)!)
        imageProvider.tintColor = .main
        return imageProvider
    }
    
}
