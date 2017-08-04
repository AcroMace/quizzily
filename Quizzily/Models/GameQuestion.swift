//
//  GameQuestion.swift
//  Quizzily
//
//  Created by Andy Cho on 2015-06-19.
//  Copyright (c) 2015 Andy Cho. All rights reserved.
//

import Foundation

/**
    Question model returned by `Game` when `getNextQuestion()` is called.
    Used to abstract away the internal model of the QuestionSet and QuestionCard.
*/
struct GameQuestion {

    //
    // MARK: - Public variables
    //

    /// Name of the set that the question was chosen from
    fileprivate(set) var setName: String

    /// Definition/question being asked
    fileprivate(set) var question: String

    /// Possible answers
    fileprivate(set) var answers: [String]

    /// The index of the correct answer
    fileprivate(set) var correctAnswer: Int

    /// Index of the answer provided
    fileprivate(set) var givenAnswer: Int?

    //
    // MARK: - Public functions
    //

    /**
        Create a `GameQuestion`

        - parameter setName: The name of the set to be displayed as a `String`
        - parameter question: The question to ask as a `String`
        - parameter answers: The list of answers to display as an array of `String`s
        - parameter correctAnswer: The index of the correct answer as an `Int`
        - returns: An initialized `GameQuestion`
    */
    init(setName: String, question: String, answers: [String], correctAnswer: Int) {
        self.setName = setName
        self.question = question
        self.answers = answers
        self.correctAnswer = correctAnswer
    }

    /**
        Answer the question

        - parameter givenAnswer: The index that the player thought was the correct answer
        - returns: `true` if the answer was correct, `false` if not

        **Side effects**

        - Sets the `givenAnswer` on the `GameQuestion` if the answer was not previously given
    */
    mutating func answer(_ givenAnswer: Int) -> Bool {
        if !alreadyAnswered() {
            self.givenAnswer = givenAnswer
        }
        return wasAnsweredCorrectly()
    }

    /**
        Check if the `GameQuestion` was already answered

        - returns: `true` if an answer was already provided, `false` if not
    */
    func alreadyAnswered() -> Bool {
        return givenAnswer != nil
    }

    /**
        Check if the answer was answered correctly

        - returns: `true` if the answer was answered correctly, `false` if not
    */
    func wasAnsweredCorrectly() -> Bool {
        return givenAnswer == correctAnswer
    }

}
