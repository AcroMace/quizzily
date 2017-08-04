//
//  AddSetTableViewController.swift
//  Quizzily
//
//  Created by Andy Cho on 2015-03-22.
//  Copyright (c) 2015 Andy Cho. All rights reserved.
//

import UIKit

/**
    The screen shown when the + button is first pressed
*/
class AddSetTableViewController: PullDownTableViewController {

    /// A reference to the search bar shown at the top
    @IBOutlet weak var searchBar: UISearchBar!

    /// Search results to display in the table
    var searchResults = [QuestionSetTemp]()
    /// The set selected from the results to show the definition for
    var selectedResult: QuestionSetTemp?
    /// Set to true after a search is done
    var didSearch = false

    /// The height of the cell that displays the sets
    let setCellHeight: CGFloat = 64
    /// The height of the cell that displays the placeholder Emoji cell when no results are found or before a search is performed
    let emptySetSearchCellHeight: CGFloat = 200

    /**
        Themes the search bar
    */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Control the search bar from this view controller
        searchBar.delegate = self

        // Disable the search bar borders
        searchBar.setBackgroundImage(UIImage(), for: UIBarPosition.any, barMetrics: .default)

        // Set the search bar's background colour
        searchBar.backgroundColor = Color.getPrimary()

        // Disable the table cell separators
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }

    /**
        Automatically raises the keyboard for searching
    */
    override func viewDidAppear(_ animated: Bool) {
        searchBar.becomeFirstResponder()
    }

    //
    // MARK: - Table view data source
    //

    /**
        There are no separate sections
    */
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    /**
        Either count the number of results or show the placeholder cell
    */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Show the empty results cell
        if searchResults.count == 0 {
            return 1
        }

        // Re-enable the table cell separators
        tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine

        // Show the search results
        return searchResults.count
    }

    /**
        Choose between the placeholder cells and the set cells
    */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if searchResults.count == 0 {
            if didSearch { // No search result found
                if let cell = tableView.dequeueReusableCell(withIdentifier: "EmptySearchCell") as? EmojiTextTableViewCell {
                    cell.emojiLabel.text = Emoji.Error.string()
                    return cell
                }
            } else {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "NoSearchCell") as? EmojiTextTableViewCell {
                    cell.emojiLabel.text = Emoji.PointUp.string()
                    return cell
                }
            }
        } else { // There are search results
            if let cell = tableView.dequeueReusableCell(withIdentifier: "SetCell") as? QuestionSetTableViewCell {
                let set = searchResults[indexPath.row]
                cell.titleLabel.text = set.title
                cell.authorLabel.text = set.creator
                return cell
            }
        }

        print("ERROR: Could not dequeue any cells for searching")
        return UITableViewCell()
    }

    /**
        Get the height of the different types of cells
    */
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if searchResults.count == 0 {
            return emptySetSearchCellHeight
        } else {
            return setCellHeight
        }
    }

    /**
        Display the set when the user taps on it
    */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Search results do not exist
        if searchResults.count == 0 {
            return
        }

        // Search results exist
        let set = searchResults[indexPath.row]
        if set.cards.count == 0 {
            QuizletHandler.downloadSet(set.id, success: { (tempSet: QuestionSetTemp) -> Void in
                set.cards = tempSet.cards
                self.selectedResult = set
                // Need to segue here as downloadSet is asynchronous
                self.performSegue(withIdentifier: "selectTempSet", sender: self)
            })
        } else {
            self.selectedResult = set
            performSegue(withIdentifier: "selectTempSet", sender: self)
        }
    }

    //
    // MARK: - Navigation
    //

    /**
        Transition to the temporary set view
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectTempSet" {
            if let questionsTempTableViewController = segue.destination as? QuestionsTempTableViewController {
                questionsTempTableViewController.selectedSet = selectedResult
            }
        }
    }

}

extension AddSetTableViewController: UISearchBarDelegate {

    /**
        Search Quizlet when the user presses search and has entered text in the search bar
    */
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }
        QuizletHandler.searchSets(query, success: { [weak self] set in
            guard let `self` = self else { return }
            self.didSearch = true
            self.searchResults = set
            self.tableView.reloadData()
            searchBar.resignFirstResponder()
        })
    }

}
