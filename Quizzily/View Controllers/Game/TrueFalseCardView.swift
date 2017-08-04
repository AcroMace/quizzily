//
//  TrueFalseCardView.swift
//  Quizzily
//
//  Created by Andy Cho on 2015-10-16.
//  Copyright © 2015 Andy Cho. All rights reserved.
//

import UIKit
import MDCSwipeToChoose

/**
    A card displayed in a true/false game
*/
class TrueFalseCardView: MDCSwipeToChooseView {

    //
    // MARK: - UI elements
    //

    /// Displays the term of the card
    var termLabel: UILabel!

    /// Displays the definition of the card
    var definitionText: UILabel!

    //
    // MARK: - Constants
    //

    /// Margin to add on all sides
    let margin: CGFloat = 20.0

    /// Margin to add just to the top
    let topMargin: CGFloat = 32.0

    //
    // MARK: - MDCSwipeToChoose
    //

    /**
        Creates the card and sets the text
    */
    init(frame: CGRect, term: String, definition: String, options: MDCSwipeToChooseViewOptions) {
        super.init(frame: frame, options: options)

        self.backgroundColor = UIColor.white
        addTerm(term)
        addDefinition(definition)
    }

    /**
        Sets the text of the term

        - parameter term: The term of the card to display
    */
    func addTerm(_ term: String) {
        let x = margin
        let y = topMargin
        let width = frame.width - margin * 2
        let height: CGFloat = 40
        let termFrame = CGRect(x: x, y: y, width: width, height: height)

        // Set the text
        self.termLabel = UILabel(frame: termFrame)
        self.termLabel.textAlignment = .center
        self.termLabel.textColor = Color.getAccentDark()
        self.termLabel.numberOfLines = 10
        self.termLabel.font = UIFont.systemFont(ofSize: 24)
        self.termLabel.text = term

        // Update the height
        let newHeight = self.termLabel.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)).height
        self.termLabel.frame = CGRect(x: x, y: y, width: width, height: newHeight)

        // Add the term
        self.addSubview(self.termLabel)
    }

    /**
        Sets the text of the definition

        - parameter definition: The definition of the card to display
    */
    func addDefinition(_ definition: String) {
        let x = margin
        let y = topMargin + termLabel.frame.height + margin
        let width = frame.width - margin * 2
        let height = frame.height - y - margin
        let definitionFrame = CGRect(x: x, y: y, width: width, height: height)

        // Set the text
        self.definitionText = UILabel(frame: definitionFrame)
        self.definitionText.textAlignment = .center
        self.definitionText.font = UIFont.systemFont(ofSize: 20)
        self.definitionText.numberOfLines = 10
        self.definitionText.text = definition

        // Update the height
        let newHeight = self.definitionText.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)).height
        self.definitionText.frame = CGRect(x: x, y: y, width: width, height: newHeight)

        // Add the definition
        self.addSubview(self.definitionText)
    }

    /**
        Required for all views
    */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

}
