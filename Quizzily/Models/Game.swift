//
//  Game.swift
//  Quizzily
//
//  Created by Andy Cho on 2015-06-07.
//  Copyright (c) 2015 Andy Cho. All rights reserved.
//

import Foundation

/**
    General representation of a game where an answer is picked from a set of questions
    and a user attempts to guess the correct matching between the answer and the question
*/
class Game {

    //
    // MARK: - Internal state
    //

    /// List of `QuestionSet` to draw questions from
    fileprivate var sets = [QuestionSet]()

    /// Current question - in `[0, MaxQuestions)`
    fileprivate(set) var questionNumber: Int = 0

    /// Number of answers per question
    fileprivate(set) var numberOfAnswers: Int

    /// Amount of questions guessed correctly
    fileprivate var totalCorrect: Int = 0

    /// Cards that were already used in game
    fileprivate var usedCards = [String]()

    /// Current `GameQuestion` being played
    fileprivate var gameQuestion: GameQuestion?

    /// List of `Question` used in the game
    fileprivate(set) var usedQuestions = [GameQuestion]()

    //
    // MARK: - Public functions
    //

    /**
        Sets the list of `QuestionSet` to choose the questions from

        - parameter sets: A list of `QuestionSet` to choose the cards from
        - parameter numberOfAnswers: Number of answers that should be returned for each question
        - returns: An unstarted `Game` at question 0

        - note: Must invoke `getNextQuestion()` to get the first question
    */
    init(sets: [QuestionSet], numberOfAnswers: Int) {
        self.sets = sets
        self.numberOfAnswers = numberOfAnswers
    }

    /**
        Public accessor to get the number of questions answered correctly

        - returns: The number of questions answered correctly
    */
    func getScore() -> Int {
        return totalCorrect
    }

    /**
        Gets the next `GameQuestion` to be played, if available

        - returns: A `GameQuestion` object with a randomly generated question from the sets
        - warning: Returns `nil` if all questions have been played

        **Side effects**

        - Increments the `questionNumber`
        - Sets the last practiced date for the set the `GameQuestion` is chosen from
        - Sets the current `gameQuestion`
    */
    func getNextQuestion() -> GameQuestion? {
        let currentSet = sets[getRandomNumber(sets.count)]             // Select a random set
        let questions = currentSet.cards.allObjects as? [QuestionCard] // Array of all cards in the set

        // Bail if no questions are available
        if questions == nil {
            print("ERROR: No QuestionCards found in set: " + currentSet.title)
            return nil // Change to Exception on update
        }

        // Construct a question
        questionNumber += 1
        gameQuestion = createGameQuestion(questionNumber, setName: currentSet.title, questions: questions!, flip: currentSet.flipTermAndDefinition)

        // Set the set's last practiced time to the current time
        currentSet.lastPracticed = Date()
        return gameQuestion
    }

    /**
        Submit an answer for the game

        - parameter answerIndex: The index of the answer given by the user, between `[1, numberOfAnswers]`
        - returns: A tuple with `answerWasCorrect` (a boolean that states whether or not the answer was correct) and `correctAnswer` (the index of the correct answer)

        **Side effects**

        - If the answer is true, `totalCorrect` is incremented
    */
    func giveAnswer(_ answerIndex: Int) -> (answerWasCorrect: Bool, correctAnswer: Int)? {
        // Check if the answer was already given
        if gameQuestion == nil || gameQuestion!.alreadyAnswered() {
            return nil // Raise exception in new one
        }

        // Check if the answer was correct
        let answerWasCorrect = gameQuestion!.answer(answerIndex)
        let correctAnswer = gameQuestion!.correctAnswer
        if answerWasCorrect {
            totalCorrect += 1
        }
        usedQuestions.append(gameQuestion!)
        gameQuestion = nil
        return (answerWasCorrect, correctAnswer)
    }

    /**
        Reset the game to play again with the same initial configuration
    */
    func reset() {
        questionNumber = 0
        totalCorrect = 0
        usedCards = [String]()
        usedQuestions = [GameQuestion]()
        gameQuestion = nil
    }

    //
    // MARK: - Private functions
    //

    /**
        Create a GameQuestion given the available questions

        - parameter questionNumber: Current question number to set for the `GameQuestion` object
        - parameter setName: Name of the set the card is drawn from
        - parameter questions: Set of `QuestionCard` to choose the answers from
        - parameter flip: Flip the term/definition if this is set to true
        - returns: A `GameQuestion` with the given configurations

        **Side effects**

        - Sets the `correctAnswer` to the index of the correct answer
        - Adds the term of the correct answer to `usedCards`
    */
    fileprivate func createGameQuestion(_ questionNumber: Int, setName: String, questions: [QuestionCard], flip: Bool) -> GameQuestion {
        // Select numberOfAnswers questions in the set
        let selectedQuestionNumbers = getArrayOfRandomNumbers(questions.count)
        // Select the index of the correct answer
        var correctAnswer = getRandomNumber(numberOfAnswers)

        // Try to get unique cards
        var correctCard = questions[selectedQuestionNumbers[correctAnswer]]
        var tries = 0
        while tries < Constants.Game.MaxUniqueRetry && usedCards.contains(correctCard.term) {
            correctAnswer = getRandomNumber(numberOfAnswers)
            correctCard = questions[selectedQuestionNumbers[correctAnswer]]
            tries += 1
        }

        // Reset used cards if retries maxed out
        if tries == Constants.Game.MaxUniqueRetry {
            usedCards = [String]()
        }
        usedCards.append(correctCard.term)

        // Get the strings for all possible answers
        var answerStrings = [String]()
        for randomNumber in selectedQuestionNumbers {
            let answer = flip ? questions[randomNumber].definition : questions[randomNumber].term
            answerStrings.append(answer)
        }

        // Construct the GameQuestion and return it
        let question = flip ? correctCard.term : correctCard.definition
        return GameQuestion(setName: setName, question: question, answers: answerStrings, correctAnswer: correctAnswer)
    }

    /**
        Get an array of unique random integers

        - parameter max: Numbers generated are in `[0, max)`
        - returns: A unique array of random integers of length `numberOfAnswers`
    */
    fileprivate func getArrayOfRandomNumbers(_ max: Int) -> [Int] {
        var numberArray = [Int]()
        for _ in 0 ..< numberOfAnswers {
            var generatedNumber = getRandomNumber(max)
            while numberArray.contains(generatedNumber) {
                generatedNumber = getRandomNumber(max)
            }
            numberArray.append(generatedNumber)
        }
        return numberArray
    }

    /**
        Get a random integer in `[0, max)`

        - parameter max: Number generated is in `[0, max)`
    */
    fileprivate func getRandomNumber(_ max: Int) -> Int {
        return Int(arc4random_uniform(UInt32(max)))
    }

}
