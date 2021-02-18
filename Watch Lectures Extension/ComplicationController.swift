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
        case .graphicRectangular:
            complicationTemplate = graphicRectangularTemplate
        case .graphicBezel:
            complicationTemplate = graphicBezelTemplate
        case .graphicCorner:
            complicationTemplate = graphicCornerTemplate
        case .utilitarianSmall:
            complicationTemplate = utilitySmallTemplate
        case .utilitarianSmallFlat:
            complicationTemplate = utilitySmallFlatTemplate
        case .utilitarianLarge:
            complicationTemplate = utilityLargeTemplate
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
        case .graphicRectangular:
            handler(graphicRectangularTemplate)
        case .graphicBezel:
            handler(graphicBezelTemplate)
        case .graphicCorner:
            handler(graphicCornerTemplate)
        case .utilitarianSmall:
            handler(utilitySmallTemplate)
        case .utilitarianSmallFlat:
            handler(utilitySmallFlatTemplate)
        case .utilitarianLarge:
            handler(utilityLargeTemplate)
        default:
            handler(nil)
        }
    }
    
    private var todayLecture: Lecture? {
        let delegate = WKExtension.shared().delegate as? ExtensionDelegate
        let lectureDay = delegate?.lectureDays.first(where: { $0.date.isToday })
        let lecture = lectureDay?.lectures.first(where: { $0.toDate > Date() })
        return lecture
    }
    
    private func imageProvider(named: String) -> CLKImageProvider {
        let image = UIImage(named: named)!
        let imageProvider = CLKImageProvider(onePieceImage: image)
        imageProvider.tintColor = .main
        return imageProvider
    }
    
    private func fullColorImageProvider(named: String) -> CLKFullColorImageProvider {
        let image = UIImage(named: named)!
        let imageProvider = CLKFullColorImageProvider(fullColorImage: image)
        return imageProvider
    }
    
    private var circularSmallTemplate: CLKComplicationTemplateCircularSmallSimpleImage {
        let template = CLKComplicationTemplateCircularSmallSimpleImage()
        template.imageProvider = imageProvider(named: "Complication/Circular")
        return template
    }
    
    private var modularSmallTemplate: CLKComplicationTemplateModularSmallSimpleImage {
        let template = CLKComplicationTemplateModularSmallSimpleImage()
        template.imageProvider = imageProvider(named: "Complication/Modular")
        return template
    }
    
    private var extraLargeTemplate: CLKComplicationTemplateExtraLargeSimpleImage {
        let template = CLKComplicationTemplateExtraLargeSimpleImage()
        template.imageProvider = imageProvider(named: "Complication/Extra Large")
        return template
    }
    
    private var graphicCircularTemplate: CLKComplicationTemplateGraphicCircularImage {
        let template = CLKComplicationTemplateGraphicCircularImage()
        template.imageProvider = fullColorImageProvider(named: "Complication/Graphic Circular")
        return template
    }
    
    private var modularLargeTemplate: CLKComplicationTemplateModularLargeStandardBody {
        let template = CLKComplicationTemplateModularLargeStandardBody()
        if let lecture = todayLecture {
            template.headerTextProvider = CLKSimpleTextProvider(text: lecture.subject)
            template.body1TextProvider = CLKSimpleTextProvider(text: "\(lecture.fromDate.shortHour)-\(lecture.toDate.shortHour)")
            template.body2TextProvider = CLKSimpleTextProvider(text: lecture.classroom)
        } else {
            template.headerTextProvider = CLKSimpleTextProvider(text: Translation.Watch.noLectures.localized)
            template.body1TextProvider = CLKSimpleTextProvider(text: Date().formattedDay)
            template.body2TextProvider = nil
        }
        return template
    }
    
    private var graphicRectangularTemplate: CLKComplicationTemplateGraphicRectangularStandardBody {
        let template = CLKComplicationTemplateGraphicRectangularStandardBody()
        if let lecture = todayLecture {
            template.headerTextProvider = CLKSimpleTextProvider(text: lecture.subject)
            template.body1TextProvider = CLKSimpleTextProvider(text: "\(lecture.fromDate.shortHour)-\(lecture.toDate.shortHour)")
            template.body2TextProvider = CLKSimpleTextProvider(text: lecture.classroom)
        } else {
            template.headerTextProvider = CLKSimpleTextProvider(text: Translation.Watch.noLectures.localized)
            template.body1TextProvider = CLKSimpleTextProvider(text: Date().formattedDay)
            template.body2TextProvider = nil
        }
        return template
    }
    
    private var graphicBezelTemplate: CLKComplicationTemplateGraphicBezelCircularText {
        let template = CLKComplicationTemplateGraphicBezelCircularText()
        template.circularTemplate = graphicCircularTemplate
        if let lecture = todayLecture {
            template.textProvider = CLKSimpleTextProvider(text: "\(lecture.fromDate.shortHour)-\(lecture.toDate.shortHour) \(lecture.classroom)")
        } else {
            template.textProvider = CLKSimpleTextProvider(text: Translation.Watch.noLecturesToday.localized)
        }
        return template
    }
    
    private var graphicCornerTemplate: CLKComplicationTemplateGraphicCornerTextImage {
        let template = CLKComplicationTemplateGraphicCornerTextImage()
        template.imageProvider = fullColorImageProvider(named: "Complication/Graphic Corner")
        if let lecture = todayLecture {
            template.textProvider = CLKSimpleTextProvider(text: "\(lecture.fromDate.shortHour)  \(lecture.classroom)")
        } else {
            template.textProvider = CLKSimpleTextProvider(text: Translation.Watch.noLectures.localized)
        }
        return template
    }
    
    private var utilitySmallTemplate: CLKComplicationTemplateUtilitarianSmallSquare {
        let template = CLKComplicationTemplateUtilitarianSmallSquare()
        template.imageProvider = imageProvider(named: "Complication/Utilitarian")
        return template
    }
    
    private var utilitySmallFlatTemplate: CLKComplicationTemplateUtilitarianSmallFlat {
        let template = CLKComplicationTemplateUtilitarianSmallFlat()
        if let lecture = todayLecture {
            template.textProvider = CLKSimpleTextProvider(text: "\(lecture.fromDate.shortHour) \(lecture.classroom)")
        } else {
            template.textProvider = CLKSimpleTextProvider(text: Translation.Watch.noLectures.localized)
        }
        return template
    }
    
    private var utilityLargeTemplate: CLKComplicationTemplateUtilitarianLargeFlat {
        let template = CLKComplicationTemplateUtilitarianLargeFlat()
        template.imageProvider = imageProvider(named: "Utility Large")
        if let lecture = todayLecture {
            template.textProvider = CLKSimpleTextProvider(text: "\(lecture.fromDate.shortHour)-\(lecture.toDate.shortHour) \(lecture.classroom)")
        } else {
            template.textProvider = CLKSimpleTextProvider(text: Translation.Watch.noLectures.localized)
        }
        return template
    }
    
}
