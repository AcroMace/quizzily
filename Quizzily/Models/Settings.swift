//
//  Settings.swift
//  Quizzily
//
//  Created by Andy Cho on 2015-07-04.
//  Copyright (c) 2015 Andy Cho. All rights reserved.
//

import Foundation

/**
    A class to manage user accessible settings saved in `NSUserDefaults`
*/
class Settings {

    /// Convenience reference to the standard `NSUserDefaults`
    fileprivate static let defaults = UserDefaults.standard

    /**
        Amount of questions to play in each `Game`
    */
    class QuestionsPerGame {

        /**
            Set the amount of questions to play

            - parameter questions: The number of questions to play
        */
        class func set(_ questions: Int) {
            defaults.set(questions, forKey: "questionsPerGame")
        }

        /**
            Get the amount of questions to play

            - returns: The number of questions to play
        */
        class func get() -> Int {
            let questionsPerGame: Int = defaults.integer(forKey: "questionsPerGame")
            return questionsPerGame > 0 ? questionsPerGame : Constants.Game.DefaultMaxQuestions
        }

    }

    /**
        Number of answers a quiz should contain
    */
    class NumberOfAnswers {

        /**
            Set the number of answers a question should display

            - parameter answers: The number of answers that should appear
        */
        class func set(_ answers: Int) {
            defaults.set(answers, forKey: "numberOfAnswers")
        }

        /**
            Get the number of answers a question should display

            - returns: The number of answers that should appear
        */
        class func get() -> Int {
            let numberOfChoices: Int = defaults.integer(forKey: "numberOfAnswers")
            return numberOfChoices > 0 ? numberOfChoices : Constants.Game.DefaultNumberOfAnswers
        }

    }

}
