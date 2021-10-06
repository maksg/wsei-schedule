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

    // MARK: Providers
    
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

    private func subjectTextProvider(lecture: Lecture) -> CLKSimpleTextProvider {
        CLKSimpleTextProvider(text: lecture.subject)
    }

    private func classroomTextProvider(lecture: Lecture) -> CLKSimpleTextProvider {
        CLKSimpleTextProvider(text: lecture.classroom)
    }

    private func timeTextProvider(lecture: Lecture) -> CLKSimpleTextProvider {
        CLKSimpleTextProvider(text: "\(lecture.fromDate.shortHour)-\(lecture.toDate.shortHour)")
    }

    private func shortTimeAndClassroomProvider(lecture: Lecture) -> CLKSimpleTextProvider {
        CLKSimpleTextProvider(text: "\(lecture.fromDate.shortHour) \(lecture.classroom)")
    }

    private func timeAndClassroomProvider(lecture: Lecture) -> CLKSimpleTextProvider {
        CLKSimpleTextProvider(text: "\(lecture.fromDate.shortHour)-\(lecture.toDate.shortHour) \(lecture.classroom)")
    }

    private var formattedDayTextProvider: CLKSimpleTextProvider {
        CLKSimpleTextProvider(text: Date().formattedDay)
    }

    private var noLecturesTextProvider: CLKSimpleTextProvider {
        CLKSimpleTextProvider(text: Translation.Watch.noLectures.localized)
    }

    // MARK: Templates
    
    private var circularSmallTemplate: CLKComplicationTemplateCircularSmallSimpleImage {
        let imageProvider = imageProvider(named: "Complication/Circular")
        return CLKComplicationTemplateCircularSmallSimpleImage(imageProvider: imageProvider)
    }
    
    private var modularSmallTemplate: CLKComplicationTemplateModularSmallSimpleImage {
        let imageProvider = imageProvider(named: "Complication/Modular")
        return CLKComplicationTemplateModularSmallSimpleImage(imageProvider: imageProvider)
    }
    
    private var extraLargeTemplate: CLKComplicationTemplateExtraLargeSimpleImage {
        let imageProvider = imageProvider(named: "Complication/Extra Large")
        return CLKComplicationTemplateExtraLargeSimpleImage(imageProvider: imageProvider)
    }
    
    private var graphicCircularTemplate: CLKComplicationTemplateGraphicCircularImage {
        let imageProvider = fullColorImageProvider(named: "Complication/Graphic Circular")
        return CLKComplicationTemplateGraphicCircularImage(imageProvider: imageProvider)
    }
    
    private var modularLargeTemplate: CLKComplicationTemplateModularLargeStandardBody {
        if let lecture = todayLecture {
            let headerTextProvider = subjectTextProvider(lecture: lecture)
            let body1TextProvider = timeTextProvider(lecture: lecture)
            let body2TextProvider = classroomTextProvider(lecture: lecture)

            return CLKComplicationTemplateModularLargeStandardBody(
                headerTextProvider: headerTextProvider,
                body1TextProvider: body1TextProvider,
                body2TextProvider: body2TextProvider
            )
        } else {
            let headerTextProvider = noLecturesTextProvider
            let body1TextProvider = formattedDayTextProvider

            return CLKComplicationTemplateModularLargeStandardBody(
                headerTextProvider: headerTextProvider,
                body1TextProvider: body1TextProvider
            )
        }
    }
    
    private var graphicRectangularTemplate: CLKComplicationTemplateGraphicRectangularStandardBody {
        if let lecture = todayLecture {
            let headerTextProvider = subjectTextProvider(lecture: lecture)
            let body1TextProvider = timeTextProvider(lecture: lecture)
            let body2TextProvider = classroomTextProvider(lecture: lecture)

            return CLKComplicationTemplateGraphicRectangularStandardBody(
                headerTextProvider: headerTextProvider,
                body1TextProvider: body1TextProvider,
                body2TextProvider: body2TextProvider
            )
        } else {
            let headerTextProvider = noLecturesTextProvider
            let body1TextProvider = formattedDayTextProvider

            return CLKComplicationTemplateGraphicRectangularStandardBody(
                headerTextProvider: headerTextProvider,
                body1TextProvider: body1TextProvider
            )
        }
    }
    
    private var graphicBezelTemplate: CLKComplicationTemplateGraphicBezelCircularText {
        let circularTemplate = graphicCircularTemplate
        let textProvider: CLKSimpleTextProvider

        if let lecture = todayLecture {
            textProvider = timeAndClassroomProvider(lecture: lecture)
        } else {
            textProvider = noLecturesTextProvider
        }

        return CLKComplicationTemplateGraphicBezelCircularText(
            circularTemplate: circularTemplate,
            textProvider: textProvider
        )
    }
    
    private var graphicCornerTemplate: CLKComplicationTemplateGraphicCornerTextImage {
        let imageProvider = fullColorImageProvider(named: "Complication/Graphic Corner")
        let textProvider: CLKSimpleTextProvider

        if let lecture = todayLecture {
            textProvider = shortTimeAndClassroomProvider(lecture: lecture)
        } else {
            textProvider = noLecturesTextProvider
        }

        return CLKComplicationTemplateGraphicCornerTextImage(
            textProvider: textProvider,
            imageProvider: imageProvider
        )
    }
    
    private var utilitySmallTemplate: CLKComplicationTemplateUtilitarianSmallSquare {
        let imageProvider = imageProvider(named: "Complication/Utilitarian")
        return CLKComplicationTemplateUtilitarianSmallSquare(imageProvider: imageProvider)
    }
    
    private var utilitySmallFlatTemplate: CLKComplicationTemplateUtilitarianSmallFlat {
        let textProvider: CLKSimpleTextProvider

        if let lecture = todayLecture {
            textProvider = shortTimeAndClassroomProvider(lecture: lecture)
        } else {
            textProvider = noLecturesTextProvider
        }

        return CLKComplicationTemplateUtilitarianSmallFlat(textProvider: textProvider)
    }
    
    private var utilityLargeTemplate: CLKComplicationTemplateUtilitarianLargeFlat {
        let imageProvider = imageProvider(named: "Utility Large")
        let textProvider: CLKSimpleTextProvider

        if let lecture = todayLecture {
            textProvider = timeAndClassroomProvider(lecture: lecture)
        } else {
            textProvider = noLecturesTextProvider
        }

        return CLKComplicationTemplateUtilitarianLargeFlat(
            textProvider: textProvider,
            imageProvider: imageProvider
        )
    }

    // MARK: - Descriptors

    func getComplicationDescriptors(handler: @escaping ([CLKComplicationDescriptor]) -> Void) {
        let scheduleSupportedFamilies: [CLKComplicationFamily] = [
            .modularSmall,
            .utilitarianSmall,
            .circularSmall,
            .extraLarge,
            .graphicCircular,
        ]

        let scheduleDescriptor = CLKComplicationDescriptor(
            identifier: "ScheduleDescriptor",
            displayName: Translation.Watch.Complications.schedule.localized,
            supportedFamilies: scheduleSupportedFamilies
        )

        let upcomingLectureSupportedFamilies: [CLKComplicationFamily] = [
            .modularLarge,
            .utilitarianSmallFlat,
            .utilitarianLarge,
            .graphicCorner,
            .graphicBezel,
            .graphicRectangular
        ]

        let upcomingLectureDescriptor = CLKComplicationDescriptor(
            identifier: "UpcomingLectureDescriptor",
            displayName: Translation.Watch.Complications.upcomingLecture.localized,
            supportedFamilies: upcomingLectureSupportedFamilies
        )

        handler([scheduleDescriptor, upcomingLectureDescriptor])
    }
    
}
