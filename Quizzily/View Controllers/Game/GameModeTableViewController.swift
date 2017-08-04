//
//  GameModeTableViewController.swift
//  Quizzily
//
//  Created by Andy Cho on 2015-10-13.
//  Copyright © 2015 Andy Cho. All rights reserved.
//

import UIKit

/**
    Enables the user to choose between different game modes
*/
class GameModeTableViewController: UITableViewController {

    static let playQuizSegueIdentifier = "playQuiz"
    static let playTrueFalseSegueIdentifier = "playTrueFalse"

    /// The sets to give to the game
    var sets: [QuestionSet]?

    /// Displays the title of the quiz game mode
    @IBOutlet weak var quizTitleLabel: UILabel!

    /// Displays the title of the true false game mode
    @IBOutlet weak var trueFalseTitleLabel: UILabel!

    /**
        Sets the theme for the game mode titles
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        quizTitleLabel.textColor = Color.getAccentDark()
        trueFalseTitleLabel.textColor = Color.getAccentDark()
    }

    //
    // MARK: - Navigation
    //

    /**
        Starts either a quiz game or a true/false game, passing the configurations and the sets selected
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == GameModeTableViewController.playQuizSegueIdentifier {
            // Start a quiz
            guard let gameViewController = segue.destination as? GameViewController else { return }
            gameViewController.game = Game(sets: sets!, numberOfAnswers: Settings.NumberOfAnswers.get())
        } else if segue.identifier == GameModeTableViewController.playTrueFalseSegueIdentifier {
            // Start a True/False game
            guard let trueFalseViewController = segue.destination as? TrueFalseViewController else { return }
            trueFalseViewController.game = Game(sets: sets!, numberOfAnswers: 2)
        }
    }

}
