//
//  ThemeTableViewController.swift
//  Quizzily
//
//  Created by Andy Cho on 2015-07-03.
//  Copyright (c) 2015 Andy Cho. All rights reserved.
//

import UIKit

/**
    Displays a list of all themes and allows the user to pick between them
*/
class ThemeTableViewController: UITableViewController {

    /// A reference to the current theme - put a checkmark next to this theme
    fileprivate let currentTheme = Theme.get()

    /// A list of tuples of `name` (the name to display for the theme) and `color` (the `UIColor` representation of the primary colour of the theme)
    fileprivate let themes: [(name: String, color: UIColor)] = [
        ("Pink", Color.getPrimary("Pink")),
        ("Red", Color.getPrimary("Red")),
        ("Amber", Color.getPrimary("Amber")),
        ("Light Green", Color.getPrimary("Light Green")),
        ("Teal", Color.getPrimary("Teal")),
        ("Indigo", Color.getPrimary("Indigo")),
        ("Brown", Color.getPrimary("Brown")),
        ("Blue Grey", Color.getPrimary("Blue Grey"))
    ]

    //
    // MARK: - UITableView
    //

    /**
        Display every theme
    */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return themes.count
    }

    /**
        Set the cell's label, make the colour a circle, and colour the circle
    */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ColorTableViewCell.reuseIdentifier, for: indexPath) as? ColorTableViewCell

        guard cell != nil else {
            print("ERROR: Could not dequeue ColorCell")
            return UITableViewCell()
        }

        // Set the text and colour
        let themeText = themes[indexPath.row].name
        cell!.colorLabel.text = themes[indexPath.row].name
        cell!.colorView.layer.cornerRadius = cell!.colorView.frame.height/2
        cell!.colorView.backgroundColor = themes[indexPath.row].color

        // Check if the theme is currently selected
        if themeText == currentTheme {
            cell!.accessoryType = UITableViewCellAccessoryType.checkmark
        }

        return cell!
    }

    /**
        When a theme is chosen, change the navigation bar's appearance and go back to `SettingsTableViewController`
    */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Theme.set(themes[indexPath.row].name)

        // Main navigation bar
        UINavigationBar.appearance().barTintColor = Color.getPrimary()
        // Settings navigation bar
        self.navigationController?.navigationBar.barTintColor = Color.getPrimary()
        // Return to settings
        self.navigationController?.popViewController(animated: true)
    }

}
