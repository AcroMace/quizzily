//
//  SettingsTableViewController.swift
//  Quizzily
//
//  Created by Andy Cho on 2015-03-25.
//  Copyright (c) 2015 Andy Cho. All rights reserved.
//

import UIKit

/**
    Displays settings - the screen seen when tapping the cog icon from `SetsTableViewController`
*/
class SettingsTableViewController: UITableViewController {

    //
    // MARK: - UI elements
    //

    /// Label of the logo to change the colour with the theme
    @IBOutlet weak var quizzilyLogoLabel: UILabel!

    /// Slider to change the number of questions in each game
    @IBOutlet weak var questionsPerGameSlider: UISlider!

    /// Label that describes how many questions are in each game
    @IBOutlet weak var questionsPerGameLabel: UILabel!

    /// Slider to change the number of answers in a quiz
    @IBOutlet weak var numberOfAnswersSlider: UISlider!

    /// Label that describes how many answers are displayed in a quiz
    @IBOutlet weak var numberOfAnswersLabel: UILabel!

    /// Label that describes what theme is being used
    @IBOutlet weak var themeLabel: UILabel!

    //
    // MARK: - Constants
    //

    /**
        Enum that describes the index of each section

        - QuestionsPerGame: Section that contains the `questionsPerGameSlider`
        - NumberOfChoices:  Section that contains the `numberOfAnswersSlider`
        - SectionTheme:     Section that contains the theme selector
        - Feedback:         Section that contains the Smooch cell and the rate option
        - Reset:            Section that contains the option to delete all sets
        - Info:             Section that contains the licenses option
    */
    fileprivate enum Section: Int {
        case questionsPerGame = 0
        case numberOfChoices = 1
        case sectionTheme = 2
        case feedback = 3
        case reset = 4
        case info = 5
    }

    //
    // MARK: - UIView
    //

    /// A reference to the Smooch view controller
    fileprivate let smoochViewController = Smooch.newConversationViewController()

    /**
        Sets the sliders
    */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the questions
        let questionsPerGame = Settings.QuestionsPerGame.get()
        questionsPerGameSlider.value = Float(questionsPerGame)
        questionsPerGameLabel.text = questionsPerGame.description

        // Set the answers
        let numberOfAnswers = Settings.NumberOfAnswers.get()
        numberOfAnswersSlider.value = Float(numberOfAnswers)
        numberOfAnswersLabel.text = numberOfAnswers.description
    }

    /**
        Sets the theme
    */
    override func viewWillAppear(_ animated: Bool) {
        themeLabel.text = Theme.get()
        quizzilyLogoLabel.textColor = Color.getPrimary()
        questionsPerGameSlider.minimumTrackTintColor = Color.getPrimary()
        numberOfAnswersSlider.minimumTrackTintColor = Color.getPrimary()
    }

    /**
        Set the actions for pressing the different rows
    */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Selected the reset sets option
        tableView.deselectRow(at: indexPath, animated: true)

        if indexPath.section == Section.feedback.rawValue && indexPath.row == 0 {
            // FEEDBACK - Give feedback
            if self.navigationController != nil {
                smoochViewController?.navigationController?.isNavigationBarHidden = true
                self.navigationController!.pushViewController(smoochViewController!, animated: true)
            }
        } else if indexPath.section == Section.feedback.rawValue && indexPath.row == 1 {
            // FEEDBACK - Rate the app
            if let appStoreUrl = URL(string: Constants.Settings.AppStoreURL) {
                UIApplication.shared.openURL(appStoreUrl)
            }
        } else if indexPath.section == Section.reset.rawValue && indexPath.row == 0 {
            // RESET - Delete all sets
            let alert = UIAlertController(title: "Warning", message: "Are you sure you want to delete all the sets in the game?", preferredStyle: .alert)
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (_: UIAlertAction) -> Void in
                QuizletHandler.deleteAllSets()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_: UIAlertAction) -> Void in
                // Do nothing
            }
            alert.addAction(cancelAction)
            alert.addAction(deleteAction)
            present(alert, animated: true) {
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }

    /**
        Save the questions per game when the value is changed
    */
    @IBAction func questionsPerGameSliderValueChanged(_ sender: AnyObject) {
        let roundedValue = round(questionsPerGameSlider.value)
        let roundedValueAsInt = Int(roundedValue)
        Settings.QuestionsPerGame.set(roundedValueAsInt)
        questionsPerGameSlider.value = roundedValue
        questionsPerGameLabel.text = roundedValueAsInt.description
    }

    /**
        Save the answers per game in a quiz when the value is changed
    */
    @IBAction func numberOfAnswersValueChanged(_ sender: AnyObject) {
        let roundedValue = round(numberOfAnswersSlider.value)
        let roundedValueAsInt = Int(roundedValue)
        Settings.NumberOfAnswers.set(roundedValueAsInt)
        numberOfAnswersSlider.value = roundedValue
        numberOfAnswersLabel.text = roundedValueAsInt.description
    }

}
