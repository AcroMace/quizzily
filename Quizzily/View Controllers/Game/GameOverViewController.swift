//
//  GameOverViewController.swift
//  Quizzily
//
//  Created by Andy Cho on 2015-03-19.
//  Copyright (c) 2015 Andy Cho. All rights reserved.
//

import UIKit

/**
    Screen shown when the player finishes a game
*/
class GameOverViewController: UIViewController {

    //
    // MARK: - Constants
    //

    static let playQuizAgainSegueIdentifier = "playQuizAgain"
    static let playTrueFalseAgainSegueIdentifier = "playTrueFalseAgain"
    static let reviewQuestionsSegueIdentifier = "reviewQuestions"
    static let unwindToMainMenuSegueIdentifier = "unwindToMainMenu"

    //
    // MARK: - Initialization variables
    //

    /// The game that was played
    var game: Game?

    /// The type of the game that was played
    var gameType: String?

    //
    // MARK: - UI elements
    //

    /// The text displayed above the points
    @IBOutlet weak var abovePointsLabel: UILabel!

    /// Displays the points earned
    @IBOutlet weak var pointsLabel: UILabel!

    /// The text displayed below the points
    @IBOutlet weak var belowPointsLabel: UILabel!

    /// The smaller light text displayed below the points
    @IBOutlet weak var descriptionText: UITextView!

    /// Back button on the bottom bar to return to the main menu
    @IBOutlet weak var backButton: UIButton!

    /// Review button on the bottom bar to review incorrect answers
    @IBOutlet weak var reviewButton: UIButton!

    /// Play again button on the bottom bar to play the game again with the same configuration
    @IBOutlet weak var playAgainButton: UIButton!

    //
    // MARK: - UIView
    //

    /**
        When the player finishes the game:

        1. Set the custom back button
        2. Set the theme
        3. Add to the streak
        4. Add points
        5. Set the text
    */
    override func viewDidLoad() {
        super.viewDidLoad()

        changeBackButton()  // Use a custom back button
        setColours()        // Set the correct colours
        Streak.playedGame() // Add to the streak

        // Calculate and add the points earned
        let (points, totalCorrect, streak, allCorrect): (Int, Int, Int, Bool) = calculatePoints()
        Points.add(points)

        // Change the text
        let (abovePoints, belowPoints, description) = getLabelText(points, totalCorrect: totalCorrect, streak: streak, allCorrect: allCorrect)
        abovePointsLabel.text = abovePoints
        pointsLabel.text = "\(points)"
        belowPointsLabel.text = belowPoints
        setDescriptionText(description)

        // Save changes
        QuizletHandler.saveChanges()
    }

    /**
        Play the game again when the play again button is tapped
    */
    @IBAction func playAgainButtonTapped(_ sender: AnyObject) {
        if gameType == "Quiz" {
            performSegue(withIdentifier: GameOverViewController.playQuizAgainSegueIdentifier, sender: self)
        } else if gameType == "TrueFalse" {
            performSegue(withIdentifier: GameOverViewController.playTrueFalseAgainSegueIdentifier, sender: self)
        }
    }

    /**
        Exit to the main menu
    */
    func unwindToMainMenu() {
        performSegue(withIdentifier: GameOverViewController.unwindToMainMenuSegueIdentifier, sender: self)
    }

    /**
        Either restart the game or display the review screen
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == GameOverViewController.playQuizAgainSegueIdentifier {
            // Restart the quiz
            guard let gameViewController = segue.destination as? GameViewController else { return }
            game?.reset() // Reset the game
            gameViewController.game = game
            self.popOffOldViewControllers()
        } else if segue.identifier == GameOverViewController.playTrueFalseAgainSegueIdentifier {
            // Restart the true/false game
            guard let trueFalseViewController = segue.destination as? TrueFalseViewController else { return }
            game?.reset()
            trueFalseViewController.game = game
            self.popOffOldViewControllers()
        } else if segue.identifier == GameOverViewController.reviewQuestionsSegueIdentifier {
            // Show the review screen
            if let navController = segue.destination as? UINavigationController {
                if let gameReviewController = navController.topViewController as? GameReviewTableViewController {
                    gameReviewController.game = game
                }
            }
        }
    }

    /**
        Delete the middle controllers

        - First one is the root view controller (SetsTableViewController)
        - Cannot delete the last one (current one) as it results in the navigation bar becoming missing, but this will not result in cumulating view controller leaks as it gets deleted if Played Again is pressed again
    */
    func popOffOldViewControllers() {
        let navigationControllerCount = navigationController?.viewControllers.count
        let gameViewRange = 1...navigationControllerCount!-2
        navigationController?.viewControllers.removeSubrange(gameViewRange)
    }

    //
    // MARK: - `viewDidLoad` helpers
    //

    /**
        Change the back button so that pressing it takes you back to the main menu
    */
    fileprivate func changeBackButton() {
        navigationItem.hidesBackButton = true
        let customBack = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.stop, target: self, action: #selector(GameOverViewController.unwindToMainMenu))
        navigationItem.leftBarButtonItem = customBack
    }

    /**
        Set the colours for the view
    */
    fileprivate func setColours() {
        self.view.backgroundColor = Color.getPrimary()
        descriptionText.textColor = Color.getAccentLight()
        backButton.backgroundColor = Color.getAccentDark()
        reviewButton.backgroundColor = Color.getAccentDark()
        playAgainButton.backgroundColor = Color.getAccentDark()
    }

    /**
        Calculate the points earned and return related variables

        - returns: A tuple with `points` (the amount of points earned), `totalCorrect` (amount of questions correct in the game), and `allCorrect` (`true` if all questions were answered correctly)
    */
    fileprivate func calculatePoints() -> (points: Int, totalCorrect: Int, streak: Int, allCorrect: Bool) {
        let totalCorrect = game!.getScore()
        let streak = Streak.get()
        let allCorrect = totalCorrect == Settings.QuestionsPerGame.get()

        // Calculate the points
        let oneCorrectValue = gameType == "Quiz" ? Constants.Game.QuizOneCorrectValue : Constants.Game.TrueFalseOneCorrectValue
        var points = oneCorrectValue * totalCorrect
        points *= streak                                              // Streak multiplier
        points *= (allCorrect ? getAllCorrectBonus(totalCorrect) : 1) // All questions correct multiplier

        return (points, totalCorrect, streak, allCorrect)
    }

    /**
        Get the points multiplier based on the number of questions correct when all questions were answered correctly

        - parameter questionsCorrect: The number of questions answered correctly

        - returns: Multiplier for the points received
    */
    fileprivate func getAllCorrectBonus(_ questionsCorrect: Int) -> Int {
        if questionsCorrect >= 50 {
            return 5
        } else if questionsCorrect >= 20 {
            return 3
        } else if questionsCorrect >= 7 {
            return 2
        }
        return 1
    }

    /**
        Get the text to put for the:

        - Above points label
        - Below points label
        - Description text

        and return it as a tuple of the 3 texts

        - parameter points:       The total amount of points earned
        - parameter totalCorrect: The total questions answered correctly
        - parameter streak:       New streak after the game
        - parameter allCorrect:   Whether or not all questions were answered correctly

        - returns: Tuple with the text to put above the points, the text to put below the points, and the text to put for the description
    */
    fileprivate func getLabelText(_ points: Int, totalCorrect: Int, streak: Int, allCorrect: Bool) -> (String, String, String) {
        // Labels above and below the amout of points
        var abovePoints = "Yay! You got"
        var belowPoints = "points :)"

        // Number of questions correct
        var questionsCorrectText = String(totalCorrect)
        if allCorrect {
            questionsCorrectText = "All"
        } else if totalCorrect == 0 {
            questionsCorrectText = "No"
        }

        // Format the description text
        let questionText = "\(questionsCorrectText) question" + (totalCorrect == 1 ? "" : "s") +  " correct!"
        let streakText = "\(streak) day streak!"
        var descriptionText = "\(questionText)\n\n\(streakText)"

        // Adjust text if no questions correct
        if points == 0 {
            abovePoints = "Oh no! You got"
            belowPoints = "points"
            descriptionText = "Better luck next time! :D"
        }

        return (abovePoints, belowPoints, descriptionText)
    }

    /**
        Set the description text without losing formatting

        - parameter description: The text to set the `descriptionText` to
    */
    fileprivate func setDescriptionText(_ description: String) {
        descriptionText.isSelectable = true
        descriptionText.text = description
        descriptionText.isSelectable = false
    }

}
