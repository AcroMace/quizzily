//
//  QuestionCardTableViewCell.swift
//  Quizzily
//
//  Created by Andy Cho on 2015-03-16.
//  Copyright (c) 2015 Andy Cho. All rights reserved.
//

import UIKit

/**
    Displays a card in the QuestionsTableViewController
*/
class QuestionCardTableViewCell: UITableViewCell {

    /// Displays the term
    @IBOutlet weak var termLabel: UILabel!
    /// Displays the definition of the term
    @IBOutlet weak var definitionLabel: UILabel!

    static let reuseIdentifier = "QuestionCell"

    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
        termLabel.textColor = Color.getPrimary()
    }

}
