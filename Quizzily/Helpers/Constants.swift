//
//  Constants.swift
//  Quizzily
//
//  Created by Andy Cho on 2015-03-26.
//  Copyright (c) 2015 Andy Cho. All rights reserved.
//

import Foundation
import UIKit

/**
    A global struct that contains the list of constants used by the app
*/
struct Constants {

    /// Quizlet configuration
    struct Quizlet {
        /// The client ID of Quizzily for Quizlet
        static let ClientId = Bundle.main.infoDictionary?["QuizletKey"] as! String
    }

    /// Smooch configuration
    struct Smooch {
        /// The AppToken of Quizzily for Smooch
        static let Token = Bundle.main.infoDictionary?["SmoochKey"] as? String
    }

    /// Some of the text used in the app
    struct Text {
        /// The text shown on `SetsTableViewController` when the user has no points
        static let NoPoints = "Hello there"
        /// The text shown on `SetsTableViewController` when the user has no streak
        static let NoStreak = "Press play to get started! :D"
        /// The text shown on `SetsTableViewController` when the user has no sets
        static let NoSets = "You have no sets to play the game with! You should add some! :)"
        /// The text shown on `QuestionsTableViewController` when the set has no description
        static let NoDescription = "No description"
    }

    /// The icons in Font Awesome
    struct FontAwesome {
        /// The cog icon used for settings
        static let Cog = "\u{f013}"
    }

    /// The numbers used in the `Game`
    struct Game {
        /// Value of getting one quiz question correct
        static let QuizOneCorrectValue = 100
        /// Value of getting one true/false question correct
        static let TrueFalseOneCorrectValue = 30
        /// Least number of questions per game
        static let MinQuestions = 3
        /// Default total number of questions per game
        static let DefaultMaxQuestions = 7
        // Default total number of answers on the screen
        static let DefaultNumberOfAnswers = 4
        // Number of retries for getting a unique answer
        static let MaxUniqueRetry = 5
        // Maximum leeway time before breaking the streak
        static let MaxStreakHours: Double = 36
        /// Seconds to wait before transitioning to the next question on a quiz if answered correctly
        static let SecondsToNextQuestionIfCorrect = 1.0
        /// Seconds to wait before transitioning to the next question on a quiz if answered incorrectly
        static let SecondsToNextQuestionIfIncorrect = 3.0
    }

    /// Constants needed in Settings
    struct Settings {
        /// The URL for the review page of Quizzily in the App Store
        static let AppStoreURL = "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=982813634&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software"
    }
}
