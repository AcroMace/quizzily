//
//  ReviewTableViewCell.swift
//  Quizzily
//
//  Created by Andy Cho on 2015-07-15.
//  Copyright (c) 2015 Andy Cho. All rights reserved.
//

import UIKit

/**
    A cell that displays the definition and correct/incorrect answers after a game ends
*/
class ReviewTableViewCell: UITableViewCell {

    static let reuseIdentifier = "ReviewCell"

    /// Displays the question
    @IBOutlet weak var definitionLabel: UILabel!
    /// Displays the correct answer
    @IBOutlet weak var correctAnswerLabel: UILabel!
    /// Displays the incorrect answer
    @IBOutlet weak var givenAnswerLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
        definitionLabel.textColor = Color.getPrimary()
    }

}
