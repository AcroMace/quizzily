//
//  GameViewController.swift
//  Quizzily
//
//  Created by Andy Cho on 2015-03-16.
//  Copyright (c) 2015 Andy Cho. All rights reserved.
//

import UIKit

/**
    Displays the quiz game
*/
class GameViewController: UIViewController {

    //
    // MARK: - Initialization parameters
    //

    /// Reference to the current game being played
    var game: Game?

    /// Array of possible answers - initialized by viewDidLoad
    var answers: [String]?

    //
    // MARK: - Indices of the answers
    //

    /// Index of the correct answer - set to green
    var correctAnswer: Int?

    /// Index of the incorrect answer, if applicable - set to red
    var incorrectAnswer: Int?

    //
    // MARK: - Timer
    //

    /// Timer before transitioning to the next view
    var segueTimer: Timer?

    /// Destination of the segue - need a reference to restart the timer
    var segueDestination: Selector?

    //
    // MARK: - UI Elements
    //

    /// The view with the name of the set and the question
    @IBOutlet weak var headerView: UIView!

    /// Displays the name of the set
    @IBOutlet weak var setNameText: UITextView!

    /// Displays the question
    @IBOutlet weak var questionText: UITextView!

    /// The table with the possible answers
    @IBOutlet weak var answerTable: UITableView!

    /// The height constraint fo the answer table - used to resize after setting the answers
    @IBOutlet weak var answerTableHeightConstraint: NSLayoutConstraint!

    /// Invisible button used to segue to the next question
    @IBOutlet weak var invisibleNextQuestionButton: UIButton!

    //
    // MARK: - UIView
    //

    /**
        Gets a question, and then:

        1. Sets the title
        2. Hides the invisible button
        3. Sets the theme
        4. Initializes the back button action
        5. Sets the text for the question
        6. Formats the answer table
    */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Get a question
        let currentQuestion: GameQuestion? = game!.getNextQuestion()
        if currentQuestion == nil {
            print("Somehow could not get a question")
            return
        }

        // Set the title of the navigation bar
        title = "Question \(game!.questionNumber)"

        // Make the invisible segue button invisible
        invisibleNextQuestionButton.setTitleColor(UIColor.clear, for: UIControlState())

        // Set the header view colour
        headerView.backgroundColor = Color.getPrimary()

        // Use a custom back button
        navigationItem.hidesBackButton = true
        let customBack = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.stop, target: self, action: #selector(GameViewController.unwindToMainMenu))
        navigationItem.leftBarButtonItem = customBack

        // Setup the views
        setSetTitle(currentQuestion!.setName)                    // Set the set name
        setQuestionTextWithFormatting(currentQuestion!.question) // Set the question
        answers = currentQuestion!.answers                       // Set the answers for the tableview

        // Set the answerTable delegates
        answerTable.delegate = self
        answerTable.dataSource = self

        // Disable scrolling when the entire table can be displayed on screen
        answerTable.alwaysBounceVertical = false

        // Set the correct size for the answerTable
        let tallAnswerSize = CGSize(width: answerTable.contentSize.width, height: CGFloat.greatestFiniteMagnitude)
        answerTableHeightConstraint.constant = answerTable.sizeThatFits(tallAnswerSize).height
    }

    /**
        Scroll up to the top of the question if the height exceeds the height the header
    */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        questionText.scrollRangeToVisible(NSRange(location: 0, length: 0))
    }

    //
    // MARK: - Initialization helper functions
    //

    /**
        Changes the set name text.
        Removes the text if there is only one set.
    */
    func setSetTitle(_ title: String) {
        setNameText.isSelectable = true
        setNameText.textContainer.maximumNumberOfLines = 1
        setNameText.textContainer.lineBreakMode = NSLineBreakMode.byTruncatingTail
        setNameText.text = title
        setNameText.isSelectable = false
    }

    /**
        Changes the question text
    */
    func setQuestionTextWithFormatting(_ text: String) {
        // Font is reset on setting the text if selectable is false
        questionText.isSelectable = true
        questionText.text = text
        questionText.sizeToFit()
        questionText.isSelectable = false
        // Scroll to the top of the textview
        questionText.scrollRangeToVisible(NSRange(location: 0, length: 0))
    }

    //
    // MARK: - Navigation
    //

    /**
        Either moves to the next question or moves to the game over screen.
        Must set the game type when moving to the game over screen.
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "nextQuestion" {
            // Move to the next question
            if let quizViewController = segue.destination as? GameViewController {
                quizViewController.game = game
            }
        } else if segue.identifier == "gameOver" {
            // Display the game over screen
            if let gameOverViewController = segue.destination as? GameOverViewController {
                gameOverViewController.game = game
                gameOverViewController.gameType = "Quiz"
            }
        }
    }

    /**
        Starts the seque timer.
        Transitions after SecondsToNextQuestionIfCorrect if the time is not specified
    */
    func segueTimerStart(_ secondsToNextQuestion: TimeInterval = Constants.Game.SecondsToNextQuestionIfCorrect) {
        if segueDestination != nil {
            segueTimer = Timer.scheduledTimer(
                timeInterval: secondsToNextQuestion,
                target: self,
                selector: segueDestination!,
                userInfo: nil,
                repeats: false)
        }
    }

    /**
        Move to the next question
    */
    @objc func nextQuestion() {
        self.performSegue(withIdentifier: "nextQuestion", sender: self)
    }

    /**
        Move to the game over screen
    */
    @objc func gameOver() {
        self.performSegue(withIdentifier: "gameOver", sender: self)
    }

    /**
        Exit to the main menu after the user confirms they want to exit
    */
    @objc func unwindToMainMenu() {
        // Stop the timer unless the user cancels the navigation
        segueTimer?.invalidate()
        // Confirm that the user wants to exit
        let alert = UIAlertController(title: "Quit Game", message: "Are you sure you want to quit this game? :(", preferredStyle: .alert)
        let quitAction = UIAlertAction(title: "Quit", style: .default) { (_: UIAlertAction) -> Void in
            // Save changes
            QuizletHandler.saveChanges()
            // Segue back
            self.performSegue(withIdentifier: "unwindToMainMenu", sender: self)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_: UIAlertAction) -> Void in
            // Restart the segue timer
            self.segueTimerStart()
        }
        alert.addAction(cancelAction)
        alert.addAction(quitAction)
        present(alert, animated: true, completion: nil)
    }

}

extension GameViewController: UITableViewDataSource, UITableViewDelegate {

    /**
        Display every answer
    */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return game!.numberOfAnswers
    }

    /**
        Sets the style of the cell.
        Reloading the table will set the correct/incorrect cell background colours if the index is set.
    */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = answerTable.dequeueReusableCell(withIdentifier: "AnswerCell") as? AnswerTableViewCell else {
            print("ERROR: Could not dequeue AnswerCell")
            return UITableViewCell()
        }

        guard let answerText = answers?[indexPath.row] else {
            print("ERROR: Possible errors not set")
            return UITableViewCell()
        }
        cell.answerLabel.text = answerText

        // Set the correct and incorrect table cell colour if necessary
        // Otherwise, alternate answer colours
        if indexPath.row == correctAnswer {
            cell.answerLabel.textColor = UIColor.white
            cell.backgroundColor = Color.getAnswerCorrect()
        } else if indexPath.row == incorrectAnswer {
            cell.answerLabel.textColor = UIColor.white
            cell.backgroundColor = Color.getAnswerIncorrect()
        } else if indexPath.row % 2 == 0 {
            cell.backgroundColor = Color.getAnswerLight()
        } else {
            cell.backgroundColor = Color.getAnswerDark()
        }

        return cell
    }

    /**
        The answer selected by the user is at `indexPath.row`.
        Gives the answer to the `Game`, highlights the correct/incorrect answers, then starts the timer to transition to the next screen.
    */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Answer given by the user
        // Button indices are [0, game.numberOfAnswers]
        let givenAnswer = indexPath.row

        // Return if the answer was already answered
        guard let answer = game?.giveAnswer(givenAnswer) else {
            return
        }

        // Set the correct and incorrect answers, then reload just those cells
        if !answer.answerWasCorrect {
            incorrectAnswer = givenAnswer
        }
        correctAnswer = answer.correctAnswer
        let correctAnswerIndex = indexPath.dropLast().appending(correctAnswer!)
        answerTable.reloadRows(at: [indexPath, correctAnswerIndex], with: .automatic)

        // Move to the next question
        let secondsToNextQuestion = answer.answerWasCorrect ? Constants.Game.SecondsToNextQuestionIfCorrect : Constants.Game.SecondsToNextQuestionIfIncorrect

        // Move to the game over screen if final question answered
        segueDestination = game!.questionNumber == Settings.QuestionsPerGame.get() ? #selector(GameViewController.gameOver) : #selector(GameViewController.nextQuestion)
        segueTimerStart(secondsToNextQuestion)
    }

}
