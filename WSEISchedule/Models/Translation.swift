//
//  Generated by gentranslations.swift
//

enum Translation: String {

   enum Accessibility {

      enum Grades: String {
         case ects = "accessibility.grades.ects"
         case grade = "accessibility.grades.grade"
         case lectureForm = "accessibility.grades.lecture_form"
         case lecturer = "accessibility.grades.lecturer"
         case list = "accessibility.grades.list"
         case subject = "accessibility.grades.subject"
      }

      enum Schedule: String {
         case classroom = "accessibility.schedule.classroom"
         case code = "accessibility.schedule.code"
         case comments = "accessibility.schedule.comments"
         case lecturer = "accessibility.schedule.lecturer"
         case subject = "accessibility.schedule.subject"
         case time = "accessibility.schedule.time"
         case to = "accessibility.schedule.to"
         case upcomingLecturesList = "accessibility.schedule.upcoming_lectures_list"
      }

      enum ScheduleHistory: String {
         case list = "accessibility.schedule_history.list"
      }

      enum Settings: String {
         case courseName = "accessibility.settings.course_name"
         case indexNumber = "accessibility.settings.index_number"
         case name = "accessibility.settings.name"
         case profilePhoto = "accessibility.settings.profile_photo"
      }

   }

   enum Error: String {
      case unknown = "error.unknown"
   }

   enum Grades: String {
      case noGrades = "grades.no_grades"

      enum Semester: String {

         enum Status: String {
            case inProgress = "grades.semester.status.in_progress"
            case notPassed = "grades.semester.status.not_passed"
            case passed = "grades.semester.status.passed"
         }

         case summer = "grades.semester.summer"
         case winter = "grades.semester.winter"
      }

      case title = "grades.title"
   }

   enum MenuBar: String {
      case refresh = "menu_bar.refresh"
   }

   enum Premium: String {
      case buy = "premium.buy"

      enum ComingSoon: String {
         case content = "premium.coming_soon.content"
         case title = "premium.coming_soon.title"
      }

      enum Grades: String {
         case content = "premium.grades.content"
         case title = "premium.grades.title"
      }

      case restore = "premium.restore"

      enum ScheduleHistory: String {
         case content = "premium.schedule_history.content"
         case title = "premium.schedule_history.title"
      }

      case title = "premium.title"
   }

   enum Schedule: String {
      case noLectures = "schedule.no_lectures"
      case title = "schedule.title"
   }

   enum ScheduleHistory: String {
      case title = "schedule_history.title"
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
         case dismiss = "settings.thank_you_alert.dismiss"
         case message = "settings.thank_you_alert.message"
         case title = "settings.thank_you_alert.title"
      }

      case title = "settings.title"
   }

   enum SignIn: String {
      case privacyMessage = "sign_in.privacy_message"
      case signIn = "sign_in.sign_in"
      case signOut = "sign_in.sign_out"
      case title = "sign_in.title"
   }

   enum Watch: String {

      enum Complications: String {
         case schedule = "watch.complications.schedule"
         case upcomingLecture = "watch.complications.upcoming_lecture"
      }

      case noLectures = "watch.no_lectures"
      case noLecturesToday = "watch.no_lectures_today"
   }

   enum Widget: String {

      enum About: String {
         case nextLecture = "widget.about.next_lecture"
         case nextTwoLectures = "widget.about.next_two_lectures"
      }

      case next = "widget.next"
      case noLecturesToday = "widget.no_lectures_today"
      case noNextLectures = "widget.no_next_lectures"
   }

   case wseiSchedule = "wsei_schedule"

}
