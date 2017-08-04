//
//  LicenseViewController.swift
//  Quizzily
//
//  Created by Andy Cho on 2015-03-25.
//  Copyright (c) 2015 Andy Cho. All rights reserved.
//

import UIKit

/**
    Display a license
*/
class LicenseViewController: UIViewController {

    /// The content of the license
    var licenseText: String?

    /// The text view that displays the license
    @IBOutlet weak var licenseTextView: UITextView!

    /**
        Set the text of the license
    */
    override func viewDidLoad() {
        super.viewDidLoad()

        licenseTextView.text = licenseText
    }

    /**
        Scroll to the top if the license is too long to be displayed without scrolling
    */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        licenseTextView.scrollRangeToVisible(NSRange(location: 0, length: 0))
    }

}
