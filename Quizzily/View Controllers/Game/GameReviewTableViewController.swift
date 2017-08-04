//
//  GameReviewTableViewController.swift
//  Quizzily
//
//  Created by Andy Cho on 2015-07-12.
//  Copyright (c) 2015 Andy Cho. All rights reserved.
//

import UIKit

/**
    Shows you a list of questions you answered incorrectly
*/
class GameReviewTableViewController: UITableViewController {

    // Segue when the user taps on a term
    static let showDefinitionSegueIdentifier = "showTermDefinition"

    /**
        Cell heights

        - Review:     A cell with the incorrect answer in it
        - AllCorrect: A placeholder cell when all questions were answered correctly
    */
    fileprivate enum CellHeight: CGFloat {
        case review = 116
        case allCorrect = 200
    }

    //
    // MARK: - State variables
    //

    /// The game that was just played
    var game: Game?

    /// List of questions that were answered incorrectly
    var incorrectAnswers = [GameQuestion]()

    /// The selected question to display in detail
    var selectedQuestion: GameQuestion?

    //
    // MARK: - UIViewController
    //

    /**
        Sets the list of incorrect answers
    */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Get the list of incorrect answers
        for question in game!.usedQuestions {
            if !question.wasAnsweredCorrectly() {
                incorrectAnswers.append(question)
            }
        }

        // Disable the table cell separators
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }

    //
    // MARK: - UITableView
    //

    /**
        Display all incorrect answers or show the placeholder cell
    */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if incorrectAnswers.count == 0 {
            return 1
        } else {
            tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
            return incorrectAnswers.count
        }
    }

    /**
        Choose the placeholder cell or display every wrong question
    */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if incorrectAnswers.count == 0 {
            // All answers correct
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AllCorrectCell", for: indexPath) as? EmojiTextTableViewCell else {
                print("ERROR: Could not dequeue AllCorrectCell")
                return UITableViewCell()
            }
            // Randomly choose between different emojis
            cell.emojiLabel.text = Emoji.Celebrate.string()
            return cell
        } else {
            // At least 1 answer incorrect
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ReviewTableViewCell.reuseIdentifier, for: indexPath) as? ReviewTableViewCell else {
                print("ERROR: Could not dequeue ReviewCell")
                return UITableViewCell()
            }
            // Get the question
            let gameQuestion = incorrectAnswers[indexPath.row]
            cell.definitionLabel.text = gameQuestion.question
            cell.givenAnswerLabel.text = gameQuestion.answers[gameQuestion.givenAnswer!]
            cell.correctAnswerLabel.text = gameQuestion.answers[gameQuestion.correctAnswer]
            return cell
        }
    }

    /**
        The placeholder cell needs to be set taller than the incorrect answers cell
    */
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if incorrectAnswers.count == 0 {
            return CellHeight.allCorrect.rawValue
        } else {
            return CellHeight.review.rawValue
        }
    }

    /**
        Display the term when a question is selected
    */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Search results do not exist
        if incorrectAnswers.count == 0 {
            return
        }

        tableView.deselectRow(at: indexPath, animated: true)
        selectedQuestion = incorrectAnswers[indexPath.row]
        performSegue(withIdentifier: GameReviewTableViewController.showDefinitionSegueIdentifier, sender: self)
    }

    /**
        Close the review view when the X button is tapped
    */
    @IBAction func closeViewTapped(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }

    //
    // MARK: - Navigation
    //

    // Show the definition in a TermDefinitionViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == GameReviewTableViewController.showDefinitionSegueIdentifier {
            if let termDefinitionViewController = segue.destination as? TermDefinitionViewController {
                if selectedQuestion != nil {
                    termDefinitionViewController.term = selectedQuestion!.answers[selectedQuestion!.correctAnswer]
                    termDefinitionViewController.definition = selectedQuestion!.question
                }
            }
        }
    }

}
