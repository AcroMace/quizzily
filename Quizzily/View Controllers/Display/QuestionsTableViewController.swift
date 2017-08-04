//
//  QuestionsTableViewController.swift
//  Quizzily
//
//  Created by Andy Cho on 2015-03-16.
//  Copyright (c) 2015 Andy Cho. All rights reserved.
//

import UIKit
import CoreData

/**
    Displays the cards in the set and enables the user to play the game with only the cards in the set
*/
class QuestionsTableViewController: PullDownTableViewController {

    /// Segue when the user presses the play button
    static let playGameSegueIdentifier = "playGameWithOneSet"
    /// Segue when the user presses a term
    static let showDefinitionSegueIdentifier = "showTermDefinition"
    /// Segue when the user presses the settings icon
    static let showSettings = "setSettings"

    /// The set selected in the SetsTableViewController to display
    var selectedSet: QuestionSet?
    /// The cards to display
    var questions = [QuestionCard]()
    /// The card selected to show in full screen mode
    var selectedQuestion: QuestionCard?

    /// The description of the set
    @IBOutlet weak var descriptionLabel: UILabel!
    /// The settings button to change the settings of the set
    @IBOutlet weak var settingsButton: UIBarButtonItem!

    /**
        Ensures that a set is selected, and then:

        1. Sets the settings button to a cog
        2. Gets the cards in the set and displays them in alphabetical order
        3. Sets the title and description of the set
    */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Ensure that a set is selected
        guard selectedSet != nil else {
            print("ERROR: selectedSet is not defined")
            self.navigationController?.popToRootViewController(animated: true)
            return
        }

        // Set the icon of the settings button
        settingsButton.title = NSString(string: Constants.FontAwesome.Cog) as String
        if let font = UIFont(name: "FontAwesome", size: 22.0) {
            settingsButton.setTitleTextAttributes([NSAttributedStringKey.font: font], for: UIControlState())
            settingsButton.setTitlePositionAdjustment(UIOffsetMake(-4, 0), for: .default)
        }

        // Get the questions
        for card in selectedSet!.cards {
            if let question = card as? QuestionCard {
                questions.append(question)
            }
        }
        // Sort the questions alphabetically
        questions.sort(by: { $0.term < $1.term })

        // Set the title and description
        setSetText()
    }

    // Set the title and the description
    func setSetText() {
        // Set the title
        title = selectedSet?.title

        // Set the description
        var description = selectedSet!.setDescription
        description = description.isEmpty ? Constants.Text.NoDescription : description

        // Set the text and the correct size
        descriptionLabel.text = String(description)
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.frame.size = descriptionLabel.sizeThatFits(CGSize(width: descriptionLabel.frame.width, height: CGFloat.greatestFiniteMagnitude))

        // Get the new height of the header
        headerContainerView.frame.size = headerContainerView.sizeThatFits(CGSize(width: headerContainerView.frame.width, height: CGFloat.greatestFiniteMagnitude))
    }

    //
    // MARK: - Table view data source
    //

    /**
        Display every card in the set
    */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }

    /**
        Display the cards
    */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> QuestionCardTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: QuestionCardTableViewCell.reuseIdentifier, for: indexPath) as? QuestionCardTableViewCell

        guard cell != nil else {
            print("ERROR: Could not dequeue QuestionCell")
            return QuestionCardTableViewCell()
        }

        cell!.termLabel.text = questions[indexPath.row].term
        cell!.termLabel.textColor = Color.getAccentDark()
        cell!.definitionLabel.text = questions[indexPath.row].definition
        return cell!
    }

    /**
        Show the detailed view when tapping a card
    */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedQuestion = questions[indexPath.row]
        performSegue(withIdentifier: QuestionsTableViewController.showDefinitionSegueIdentifier, sender: self)
    }

    //
    // MARK: - Navigation
    //

    /**
        Either starts the game with the current set, shows the definition of a card, or displays the settings for the set
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == QuestionsTableViewController.playGameSegueIdentifier {
            // Start the game with the current set
            if let gameModeTableViewController = segue.destination as? GameModeTableViewController {
                if let selectedSet = selectedSet {
                    gameModeTableViewController.sets = [selectedSet]
                }
            }
        } else if segue.identifier == QuestionsTableViewController.showDefinitionSegueIdentifier {
            // Show the definition of the selected card
            if let termDefinitionViewController = segue.destination as? TermDefinitionViewController {
                termDefinitionViewController.term = selectedQuestion?.term
                termDefinitionViewController.definition = selectedQuestion?.definition
            }
        } else if segue.identifier == QuestionsTableViewController.showSettings {
            // Display the settings for the set
            if let questionsSettingsTableViewController = segue.destination as? QuestionsSettingsTableViewController {
                questionsSettingsTableViewController.selectedSet = selectedSet
            }
        }
    }

}
