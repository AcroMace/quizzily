//
//  AnswerTableViewCell.swift
//  Quizzily
//
//  Created by Andy Cho on 2015-06-20.
//  Copyright (c) 2015 Andy Cho. All rights reserved.
//

import UIKit

/**
    Displays the answer in a quiz
*/
class AnswerTableViewCell: UITableViewCell {

    /// Label that displays the answer
    @IBOutlet weak var answerLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
        answerLabel.textColor = Color.getPrimary()
    }

}
