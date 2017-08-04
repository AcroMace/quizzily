//
//  TermDefinitionViewController.swift
//  Quizzily
//
//  Created by Andy Cho on 2015-03-21.
//  Copyright (c) 2015 Andy Cho. All rights reserved.
//

import UIKit

/**
    Displays a card in full screen mode
*/
class TermDefinitionViewController: UIViewController {

    /// Displays the term of the card
    @IBOutlet weak var termLabel: UILabel!
    /// Displays the definition of the card
    @IBOutlet weak var definitionLabel: UILabel!

    /// The term of the selected card
    var term: String?
    /// The definition of the selected card
    var definition: String?

    /**
        Sets the theme and the text, and then resizes the labels to fit
    */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the theme
        termLabel.textColor = Color.getAccentDark()

        // Set the text
        termLabel.text = term             // Set the term text
        definitionLabel.text = definition // Change the text of the definition

        // Resize the labels
        // TODO: Ensure that these stay on the screen even if the text is really long
        termLabel.sizeToFit()
        definitionLabel.sizeToFit()
    }

}
