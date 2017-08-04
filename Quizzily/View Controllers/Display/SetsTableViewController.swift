//
//  SetsTableViewController.swift
//  Quizzily
//
//  Created by Andy Cho on 2015-03-16.
//  Copyright (c) 2015 Andy Cho. All rights reserved.
//

import UIKit
import CoreData

/**
    The first screen seen when opening the app.
    Displays the list of sets, the points, and the streak.
    Also gives the player the ability to start the game, go to settings, or add a set.
*/
class SetsTableViewController: PullDownTableViewController {

    /// Segue after the user selects a set
    static let selectCellSegueIdentifier = "selectSet"
    /// Segue after the user presses play
    static let playAllSegueIdentifier = "playGameWithAllSets"

    /// Displays the amount of points the user has
    @IBOutlet weak var pointsText: UILabel!
    /// Displays the user's current streak
    @IBOutlet weak var streakText: UILabel!
    /// The cog icon that brings the users to the general settings
    @IBOutlet weak var settingsButton: UIBarButtonItem!

    /// List of all sets in the local database
    var sets = [QuestionSet]()
    /// The set selected by the user to display
    var selectedSet: QuestionSet?

    /**
        Check if the streak is broken and make the settings button a cog
    */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the icon of the settings button
        settingsButton.title = NSString(string: Constants.FontAwesome.Cog) as String
        if let font = UIFont(name: "FontAwesome", size: 22.0) {
            settingsButton.setTitleTextAttributes([NSFontAttributeName: font], for: UIControlState())
            settingsButton.setTitlePositionAdjustment(UIOffsetMake(4, 0), for: .default)
        }

        // Check if the streak was broken while the app was off
        Streak.checkIfBroken()
    }

    /**
        Display all sets, get the amount of points the user has, and get the user's streak
    */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Reload sets
        // Putting this here so the sets are updated when the user returns to this screen after saving a set from Quizlet
        sets = QuizletHandler.getAllLocalSets().sorted(by: {(date1, date2) -> Bool in
            return date1.downloadedAt.timeIntervalSince1970 > date2.downloadedAt.timeIntervalSince1970
        })
        self.tableView.reloadData()

        // Get the amount of points
        let points = Points.get()
        if points == 0 {
            pointsText.text = Constants.Text.NoPoints
        } else {
            pointsText.text = "\(Points.get()) Points"
        }

        // Get the streak
        let streak = Streak.get()
        if streak == 0 {
            streakText.text = Constants.Text.NoStreak
        } else {
            streakText.text = "\(streak) day streak"
        }
    }

    /**
        When the user presses the Play button on the main screen, they should start a game with all sets included
    */
    @IBAction func playGameWithAllSets(_ sender: AnyObject) {
        if sets.count > 0 {
            performSegue(withIdentifier: SetsTableViewController.playAllSegueIdentifier, sender: self)
        } else {
            // If the user has no sets, ask the user to add more sets and transition to the Add Sets screen
            let alert = UIAlertController(title: "No sets", message: Constants.Text.NoSets, preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "Okay", style: .default) { (_: UIAlertAction) -> Void in
                self.performSegue(withIdentifier: "menuToSearch", sender: self)
            }
            alert.addAction(okayAction)
            present(alert, animated: true, completion: nil)
        }
    }

    /**
        Open the settings screen when the settings button is tapped
    */
    @IBAction func settingsButtonTapped(_ sender: AnyObject) {
        let settingsStoryboard = UIStoryboard(name: "Settings", bundle: nil)
        if let settingsViewController = settingsStoryboard.instantiateViewController(withIdentifier: "SettingsEntry") as? UINavigationController {
            navigationController?.present(settingsViewController, animated: true, completion: nil)
        }
    }

    /**
        Let other views unwind to this one
    */
    @IBAction func unwindToMainMenu(_ segue: UIStoryboardSegue) {

    }

    //
    // MARK: - Table view data source
    //

    /**
        Should display every set
    */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sets.count
    }

    /**
        Style the set cells
    */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> QuestionSetTableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SetCell") as? QuestionSetTableViewCell else {
            print("ERROR: Could not dequeue SetCell")
            return QuestionSetTableViewCell()
        }

        let set = sets[indexPath.row]
        cell.titleLabel.text = set.title
        cell.titleLabel.textColor = Color.getAccentDark()
        cell.authorLabel.text = "\(set.cards.count) cards from \(set.creator)"
        return cell
    }

    /**
        If a set is selected, display the cards in the set
    */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSet = sets[indexPath.row]
        performSegue(withIdentifier: SetsTableViewController.selectCellSegueIdentifier, sender: self)
    }

    /**
        Enable deleting sets
    */
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let set = sets[indexPath.row]
            QuizletHandler.deleteSet(set)

            sets.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    //
    // MARK: - Navigation
    //

    /**
        Either play a game with all sets or display the cards in the set
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SetsTableViewController.selectCellSegueIdentifier {
            guard let questionsTableViewController = segue.destination as? QuestionsTableViewController else { return }
            questionsTableViewController.selectedSet = selectedSet
        } else if segue.identifier == SetsTableViewController.playAllSegueIdentifier {
            guard let gameModeTableViewController = segue.destination as? GameModeTableViewController else { return }
            gameModeTableViewController.sets = sets as [QuestionSet]
        }
    }

}
