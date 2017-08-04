//
//  QuestionSetTableViewCell.swift
//  Quizzily
//
//  Created by Andy Cho on 2015-03-20.
//  Copyright (c) 2015 Andy Cho. All rights reserved.
//

import UIKit

/**
    Displays the sets on the SetsTableViewController
*/
class QuestionSetTableViewCell: UITableViewCell {

    /// Displays the name of the set
    @IBOutlet weak var titleLabel: UILabel!
    /// Displays the author of the set and the number of cards in the set
    @IBOutlet weak var authorLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
        titleLabel.textColor = Color.getPrimary()
    }

}
