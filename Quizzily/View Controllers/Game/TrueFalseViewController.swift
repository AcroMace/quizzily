//
//  TrueFalseViewController.swift
//  Quizzily
//
//  Created by Andy Cho on 2015-10-15.
//  Copyright © 2015 Andy Cho. All rights reserved.
//

import UIKit
import MDCSwipeToChoose

/**
    Displays the true/false game
*/
class TrueFalseViewController: UIViewController {

    //
    // MARK: - UI Elements
    //

    /// The false button on the bottom left of the screen
    @IBOutlet weak var falseButton: UIButton!

    /// The true button on the bottom right of the screen
    @IBOutlet weak var trueButton: UIButton!

    /// Displays the smiley
    @IBOutlet weak var smileyLabel: UILabel!

    /// The text at the top of the smiley
    @IBOutlet weak var smileyTopLabel: UILabel!

    /// The text at the bottom of the smiley
    @IBOutlet weak var smileyBottomLabel: UILabel!

    //
    // MARK: - State variables
    //

    /// Reference to an initialized game to fetch the questions from
    var game: Game?

    /// Reference to the card at the top to faciliate the use of the buttons
    var topCardView: UIView?

    //
    // MARK: - Constants
    //

    static let secondsToNextQuestion = 0.5

    //
    // MARK: - UIView
    //

    /**
        Sets the background colour, customize the back button, and themes the true/false buttons
    */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Background colour
        self.view.backgroundColor = Color.getPrimary()

        // Set the back button
        navigationItem.hidesBackButton = true
        let customBack = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.stop, target: self, action: #selector(TrueFalseViewController.unwindToMainMenu))
        navigationItem.leftBarButtonItem = customBack

        // Round and add shadows to the true/false buttons
        prettifyButtons()
    }

    /**
        Displays the first question
    */
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        displayNextQuestion(delay: 0)
    }

    /**
        Exit to the main menu
    */
    func unwindToMainMenu() {
        // Confirm that the user wants to exit
        let alert = UIAlertController(title: "Quit Game", message: "Are you sure you want to quit this game? :(", preferredStyle: .alert)
        let quitAction = UIAlertAction(title: "Quit", style: .default) { (_: UIAlertAction) -> Void in
            // Save changes
            QuizletHandler.saveChanges()
            // Segue back
            self.performSegue(withIdentifier: "unwindToMainMenu", sender: self)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (_: UIAlertAction) -> Void in
        }
        alert.addAction(cancelAction)
        alert.addAction(quitAction)
        present(alert, animated: true, completion: nil)
    }

    //
    // MARK: - Navigation
    //

    /**
        Move to the game over screen if all questions have been played
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gameOver" {
            if let gameOverViewController = segue.destination as? GameOverViewController {
                gameOverViewController.game = game
                gameOverViewController.gameType = "TrueFalse"
            }
        }
    }

    //
    // MARK: - Helper methods
    //

    /**
        Get the next question and display the card

        - parameter delay: The duration to wait before displaying the next question

        - precondition: The game must not be over
        - postcondition: The current question number is incremented
    */
    func displayNextQuestion(delay: Double) {
        // Get the next question
        let currentQuestion: GameQuestion? = game!.getNextQuestion()
        guard currentQuestion != nil else {
            print("ERROR: Could not get the next question")
            return
        }

        createCard(term: currentQuestion!.question, definition: currentQuestion!.answers[0], delay: delay)
    }

    /**
        Create a card from the question and display it

        - parameter term:       The term of the card
        - parameter definition: The definition of the card
        - parameter delay:      Amount of time to wait before displaying the card
    */
    func createCard(term: String, definition: String, delay: Double) {
        // Set the swipe view options
        let options = MDCSwipeToChooseViewOptions()
        options.delegate = self
        options.likedText = "True"
        options.likedColor = Color.getAccentDark("Teal")
        options.nopeText = "False"
        options.nopeColor = Color.getPrimary("Red")

        // Set the sizing
        let margin: CGFloat = 20
        let bottomMargin: CGFloat = 142
        let finalCardFrame = CGRect(x: margin, y: margin, width: self.view.bounds.width - margin * 2, height: self.view.bounds.height - bottomMargin)
        let initialCardFrame = CGRect(x: finalCardFrame.minX, y: finalCardFrame.minY + 1000, width: finalCardFrame.width, height: finalCardFrame.height)

        // Create the view and add it
        let view = TrueFalseCardView(frame: initialCardFrame, term: term, definition: definition, options: options)
        view.backgroundColor = UIColor.white
        self.view.addSubview(view)

        // Animate in the card
        UIView.animate(withDuration: 0.3, delay: delay, options: UIViewAnimationOptions.curveEaseOut, animations: {
            view.frame = finalCardFrame
        }, completion: { _ in
            // Animation complete
            self.resetSmileyLabel()
            self.topCardView = view
        })
    }

    /**
        Set the smiely label to a happy or sad face

        - parameter answerWasCorrect: True if the answer was correct, false if incorrect
        - parameter answer: True if the correct answer was true, false if it was false
    */
    func setSmileyEmotion(answerWasCorrect: Bool, answer: Bool) {
        // The top label + smiley face
        if answerWasCorrect {
            smileyTopLabel.text = "Correct!"
            smileyLabel.text = Emoji.happyFace.string()
        } else {
            smileyTopLabel.text = "Incorrect"
            smileyLabel.text = Emoji.sadFace.string()
        }
        // The bottom label
        if answer {
            smileyBottomLabel.text = "The answer was true"
        } else {
            smileyBottomLabel.text = "The answer was false"
        }
    }

    /**
        Reset the smiley label to its original state
    */
    func resetSmileyLabel() {
        smileyTopLabel.text = "Swipe \(Emoji.pointRight.string()) if true"
        smileyLabel.text = Emoji.neutralFace.string()
        smileyBottomLabel.text = "Swipe \(Emoji.pointLeft.string()) if false"
    }

    /**
        Move to the game over screen
    */
    func gameOver() {
        self.performSegue(withIdentifier: "gameOver", sender: self)
    }

    /**
        Round the buttons and add a drop shadow
    */
    func prettifyButtons() {
        // Round the true/false buttons
        falseButton.layer.cornerRadius = falseButton.frame.height / 2
        trueButton.layer.cornerRadius = trueButton.frame.height / 2

        // Put a drop shadow on the buttons
        falseButton.layer.shadowColor = UIColor.black.cgColor
        falseButton.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        falseButton.layer.shadowOpacity = 0.3
        trueButton.layer.shadowColor = UIColor.black.cgColor
        trueButton.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        trueButton.layer.shadowOpacity = 0.3
    }

}

extension TrueFalseViewController: MDCSwipeToChooseDelegate {

    /**
        Simulate a left swipe when the false button is tapped
    */
    @IBAction func falseButtonTapped(_ sender: AnyObject) {
        if let topCard = topCardView {
            topCard.mdc_swipe(.left)
        }
    }

    /**
        Simulate a right swipe when the true button is tapped
    */
    @IBAction func trueButtonTapped(_ sender: AnyObject) {
        if let topCard = topCardView {
            topCard.mdc_swipe(.right)
        }
    }

    /**
        Always allow a swipe in either direction
    */
    func view(_ view: UIView, shouldBeChosenWith shouldBeChosenWithDirection: MDCSwipeDirection) -> Bool {
        return true
    }

    /**
        This is called when a user swipes the view fully left or right.
        Gives the answer to the game, then choose between a happy or sad smiley
    */
    func view(_ view: UIView, wasChosenWith wasChosenWithDirection: MDCSwipeDirection) {
        guard let `game` = game else { return }

        // Find out if the user has answered true or false
        var givenAnswer: Int
        if wasChosenWithDirection == MDCSwipeDirection.left {
            givenAnswer = 1 // Answered false
        } else {
            givenAnswer = 0 // Answered true
        }

        // Check if the answer was correct
        guard let answer = game.giveAnswer(givenAnswer) else { return }
        setSmileyEmotion(answerWasCorrect: answer.answerWasCorrect, answer: answer.correctAnswer == 0)

        if game.questionNumber == Settings.QuestionsPerGame.get() {
            Timer.scheduledTimer(
                timeInterval: TrueFalseViewController.secondsToNextQuestion,
                target: self,
                selector: #selector(TrueFalseViewController.gameOver),
                userInfo: nil,
                repeats: false)
        } else {
            if answer.answerWasCorrect {
                displayNextQuestion(delay: TrueFalseViewController.secondsToNextQuestion)
            } else {
                displayNextQuestion(delay: TrueFalseViewController.secondsToNextQuestion * 2)
            }
        }
    }

}
