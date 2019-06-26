//
//  ComplicationController.swift
//  Watch Lectures Extension
//
//  Created by Maksymilian Galas on 19/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import WatchKit
import ClockKit

private extension UIColor {
    static var main: UIColor { UIColor(named: "Main")! }
}

class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([])
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
            complicationTemplate = circularSmallTemplate
        case .modularSmall:
            complicationTemplate = modularSmallTemplate
        case .extraLarge:
            complicationTemplate = extraLargeTemplate
        case .graphicCircular:
            complicationTemplate = graphicCircularTemplate
        case .modularLarge:
            complicationTemplate = modularLargeTemplate
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
            handler(circularSmallTemplate)
        case .modularSmall:
            handler(modularSmallTemplate)
        case .extraLarge:
            handler(extraLargeTemplate)
        case .graphicCircular:
            handler(graphicCircularTemplate)
        case .modularLarge:
            handler(modularLargeTemplate)
        default:
            handler(nil)
        }
    }
    
    private func imageProvider(named: String) -> CLKImageProvider {
        let imageProvider = CLKImageProvider(onePieceImage: UIImage(named: named)!)
        imageProvider.tintColor = .main
        return imageProvider
    }
    
    private var circularSmallTemplate: some CLKComplicationTemplate {
        let template = CLKComplicationTemplateCircularSmallSimpleImage()
        template.imageProvider = imageProvider(named: "Complication/Circular")
        return template
    }
    
    private var modularSmallTemplate: some CLKComplicationTemplate {
        let template = CLKComplicationTemplateModularSmallSimpleImage()
        template.imageProvider = imageProvider(named: "Complication/Modular")
        return template
    }
    
    private var extraLargeTemplate: some CLKComplicationTemplate {
        let template = CLKComplicationTemplateExtraLargeSimpleImage()
        template.imageProvider = imageProvider(named: "Complication/Extra Large")
        return template
    }
    
    private var graphicCircularTemplate: some CLKComplicationTemplate {
        let template = CLKComplicationTemplateGraphicCircularImage()
        let image = UIImage(named: "Complication/Graphic Circular")!
        template.imageProvider = CLKFullColorImageProvider(fullColorImage: image)
        return template
    }
    
    private var modularLargeTemplate: some CLKComplicationTemplate {
        let delegate = WKExtension.shared().delegate as? ExtensionDelegate
        let template = CLKComplicationTemplateModularLargeStandardBody()
        if let lectureDay = delegate?.lectureDays.first(where: { $0.date.isToday }), let lecture = lectureDay.lectures.first(where: { $0.toDate > Date() }) {
            template.headerTextProvider = CLKSimpleTextProvider(text: lecture.subject)
            template.body1TextProvider = CLKSimpleTextProvider(text: "\(lecture.fromDate.shortHour)-\(lecture.toDate.shortHour)")
            template.body2TextProvider = CLKSimpleTextProvider(text: lecture.classroom)
        } else {
            template.headerTextProvider = CLKSimpleTextProvider(text: Translation.Watch.noLectures.localized)
            template.body1TextProvider = CLKSimpleTextProvider(text: Translation.Watch.today.localized)
            template.body2TextProvider = nil
        }
        return template
    }
    
}
