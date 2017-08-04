//
//  QuestionsTempTableViewController.swift
//  Quizzily
//
//  Created by Andy Cho on 2015-03-23.
//  Copyright (c) 2015 Andy Cho. All rights reserved.
//

import UIKit

/**
    Temporarily display a set from Quizlet before the user decides whether or not they want to save it
*/
class QuestionsTempTableViewController: PullDownTableViewController {

    /// Segue when a user taps on a term
    static let showTermDefinitionSegueIdentifier = "showTermDefinition"

    /// A temporary instance of a QuestionSet
    var selectedSet: QuestionSetTemp?
    /// A temporary instance of a QuestionCard to display when the user taps a card
    var selectedQuestion: QuestionCardTemp?

    /// Displays a description of the set
    @IBOutlet weak var descriptionText: UITextView!
    /// Tapped by the user to save the set to the local database
    @IBOutlet weak var saveButton: UIBarButtonItem!

    /**
        Set the title, description, and decide whether or not the save button should be enabled
    */
    override func viewDidLoad() {
        super.viewDidLoad()

        title = selectedSet?.title

        // Set the description
        var description = selectedSet!.setDescription
        description = description.isEmpty ? Constants.Text.NoDescription : description

        descriptionText.isSelectable = true
        descriptionText.text = description
        descriptionText.isSelectable = false
        descriptionText.scrollRangeToVisible(NSRange(location: 0, length: 0))

        // Disable the save button if the set has already been downloaded
        if QuizletHandler.setExists(with: selectedSet!.id) {
            disableSaveButton()
        }
    }

    /**
        Save the set to the local database when the save button is tapped
    */
    @IBAction func tapSaveButton(_ sender: AnyObject) {
        QuizletHandler.saveTempSet(selectedSet!)
        disableSaveButton()
    }

    /**
        Disable the save button if the set already exists in the local database
    */
    func disableSaveButton() {
        saveButton.title = "Saved"
        saveButton.isEnabled = false
    }

    //
    // MARK: - Table view data source
    //

    /**
        Should display every card in the set
    */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedSet!.cards.count
    }

    /**
        Set the term and definition of each card
    */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> QuestionCardTableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: QuestionCardTableViewCell.reuseIdentifier, for: indexPath) as? QuestionCardTableViewCell else {
            print("ERROR: Could not dequeue QuestionCell")
            return QuestionCardTableViewCell()
        }

        cell.termLabel.text = selectedSet!.cards[indexPath.row].term
        cell.definitionLabel.text = selectedSet!.cards[indexPath.row].definition
        return cell
    }

    /**
        When the user taps a card, should transition to the TermDefinitionViewController
    */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedQuestion = selectedSet!.cards[indexPath.row]
        performSegue(withIdentifier: QuestionsTempTableViewController.showTermDefinitionSegueIdentifier, sender: self)
    }

    //
    // MARK: - Navigation
    //

    /**
        Display the definition of a card when it is tapped
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == QuestionsTempTableViewController.showTermDefinitionSegueIdentifier {
            guard let termDefinitionViewController = segue.destination as? TermDefinitionViewController else { return }
            termDefinitionViewController.term = selectedQuestion?.term
            termDefinitionViewController.definition = selectedQuestion?.definition
        }
    }

}
