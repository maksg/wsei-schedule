//
//  Generated by gentranslations.swift on 22/07/2021.
//

enum Translation: String {

    enum SignIn: String {
        case username = "sign_in.username"
        case password = "sign_in.password"
        case signIn = "sign_in.sign_in"
        case signOut = "sign_in.sign_out"
        case title = "sign_in.title"
        case privacyMessage = "sign_in.privacy_message"
    }

    enum Schedule: String {
        case title = "schedule.title"
        case noLectures = "schedule.no_lectures"
    }

    enum ScheduleHistory: String {
        case title = "schedule_history.title"
    }

    enum Grades: String {
        case title = "grades.title"
    }
    
    enum Settings: String {
        enum Games: String {
            case header = "settings.games.header"
        }
        
        enum Support: String {
            case donate = "settings.support.donate"
            case header = "settings.support.header"
        }

        enum ThankYouAlert: String {
            case title = "settings.thank_you_alert.title"
            case message = "settings.thank_you_alert.message"
            case dismiss = "settings.thank_you_alert.dismiss"
        }
        
        case title = "settings.title"
    }

    enum Premium: String {
        enum Grades: String {
            case title = "premium.grades.title"
            case content = "premium.grades.content"
        }

        enum ScheduleHistory: String {
            case title = "premium.schedule_history.title"
            case content = "premium.schedule_history.content"
        }

        enum ComingSoon: String {
            case title = "premium.coming_soon.title"
            case content = "premium.coming_soon.content"
        }

        case title = "premium.title"
        case buy = "premium.buy"
        case restore = "premium.restore"
    }
    
    enum Watch: String {
        case noLectures = "watch.no_lectures"
        case noLecturesToday = "watch.no_lectures_today"

        enum Complications: String {
            case schedule = "watch.complications.schedule"
            case upcomingLecture = "watch.complications.upcoming_lecture"
        }
    }
    
    enum Widget: String {
        case next = "widget.next"
        case noLecturesToday = "widget.no_lectures_today"
        case noNextLectures = "widget.no_next_lectures"

        enum About: String {
            case nextLecture = "widget.about.next_lecture"
            case nextTwoLectures = "widget.about.next_two_lectures"
        }
    }

    enum Accessibility {
        enum Schedule: String {
            case subject = "accessibility.schedule.subject"
            case time = "accessibility.schedule.time"
            case to = "accessibility.schedule.to"
            case classroom = "accessibility.schedule.classroom"
            case code = "accessibility.schedule.code"
            case lecturer = "accessibility.schedule.lecturer"
            case comments = "accessibility.schedule.comments"
            case upcomingLecturesList = "accessibility.schedule.upcoming_lectures_list"
        }

        enum ScheduleHistory: String {
            case list = "accessibility.schedule_history.list"
        }

        enum Grades: String {
            case list = "accessibility.grades.list"
            case subject = "accessibility.grades.subject"
            case lectureForm = "accessibility.grades.lecture_form"
            case lecturer = "accessibility.grades.lecturer"
            case grade = "accessibility.grades.grade"
            case ects = "accessibility.grades.ects"
        }

        enum Settings: String {
            case profilePhoto = "accessibility.settings.profile_photo"
            case name = "accessibility.settings.name"
            case indexNumber = "accessibility.settings.index_number"
            case courseName = "accessibility.settings.course_name"
        }
    }

    enum Error: String {
        case unknown = "error.unknown"
    }

    case wseiSchedule = "wsei_schedule"
    
}

