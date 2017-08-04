//
//  QuestionsSettingsTableViewController.swift
//  Quizzily
//
//  Created by Andy Cho on 2015-11-07.
//  Copyright © 2015 Andy Cho. All rights reserved.
//

import UIKit

/**
    Displays set-specific settings
*/
class QuestionsSettingsTableViewController: UITableViewController {

    /// The switch that displays the term/definition flip toggle
    @IBOutlet weak var flipSwitch: UISwitch!

    /// The set selected for the settings
    var selectedSet: QuestionSet?

    /**
        Sets the title and the state of the switch
    */
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Set Settings"

        // Set the term/definition flip toggle value
        if let flipTermAndDefinition = selectedSet?.flipTermAndDefinition {
            flipSwitch.isOn = flipTermAndDefinition
        }
    }

    /**
        Sets the theme of the toggle
    */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        flipSwitch.onTintColor = Color.getPrimary()
    }

    /**
        Reset the selection when a cell is tapped
    */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    /**
        Called when the term / definition flip toggle is changed.
        Saves the change to the database.
    */
    @IBAction func flipSwitchValueChanged(_ sender: AnyObject) {
        selectedSet?.flipTermAndDefinition = flipSwitch.isOn
        _ = QuizletHandler.saveChanges()
    }

}
