//
//  Generated by gentranslations.swift on 18/12/2019.
//

final class Translation {
    
    enum Schedule: String {
        case title = "schedule.title"
        case today = "schedule.today"
        case tomorrow = "schedule.tomorrow"
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
    
    enum SignIn: String {
        case login = "sign_in.login"
        case password = "sign_in.password"
        case signIn = "sign_in.sign_in"
        case signOut = "sign_in.sign_out"
        case title = "sign_in.title"
        case privacyMessage = "sign_in.privacy_message"
    }
    
    enum Watch: String {
        case noLectures = "watch.no_lectures"
        case noLecturesToday = "watch.no_lectures_today"
        case today = "watch.today"
    }
    
    enum Widget: String {
        case next = "widget.next"
        case noLecturesToday = "widget.no_lectures_today"
        case noNextLectures = "widget.no_next_lectures"
        case today = "widget.today"
        case tomorrow = "widget.tomorrow"

        enum About: String {
            case nextLecture = "widget.about.next_lecture"
            case nextTwoLectures = "widget.about.next_two_lectures"
        }
    }
    
}

