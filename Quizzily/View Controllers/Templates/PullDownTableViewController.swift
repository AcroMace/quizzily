//
//  PullDownTableViewController.swift
//  Quizzily
//
//  Created by Andy Cho on 2015-05-15.
//  Copyright (c) 2015 Andy Cho. All rights reserved.
//

import UIKit

/**
    Template for scrollable table view controllers where dragging the view down shows nothing except the colour of the theme
*/
class PullDownTableViewController: UITableViewController {

    /// The view above the normal table view that is shown when dragging down from the top
    var pulldownView: UIView?

    /// The view at the top that contains information
    @IBOutlet weak var headerContainerView: UIView!

    /// The dark button in the `headerContainerView`
    @IBOutlet weak var playButton: UIButton!

    /**
        Make the empty area when pulling the table view down match the colour of the navbar
    */
    override func viewDidLoad() {
        super.viewDidLoad()

        var frame = self.tableView.bounds
        frame.origin.y = -frame.size.height
        pulldownView = UIView(frame: frame)
        updateTheme()
        self.tableView.insertSubview(pulldownView!, at: 0)
    }

    /**
        Update the theme when the view appears
    */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTheme()
    }

    /**
        Set the header and play button colours
    */
    fileprivate func updateTheme() {
        if pulldownView != nil {
            pulldownView!.backgroundColor = Color.getPrimary()
        }
        if headerContainerView != nil {
            headerContainerView.backgroundColor = Color.getPrimary()
        }
        if playButton != nil {
            playButton.backgroundColor = Color.getAccentDark()
        }
    }

}
