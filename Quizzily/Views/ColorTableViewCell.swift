//
//  ColorTableViewCell.swift
//  Quizzily
//
//  Created by Andy Cho on 2015-07-03.
//  Copyright (c) 2015 Andy Cho. All rights reserved.
//

import UIKit

/**
    Displays colours that can be chosen for the theme
*/
class ColorTableViewCell: UITableViewCell {

    static let reuseIdentifier = "ColorCell"

    /// The circle with the colour displayed
    @IBOutlet weak var colorView: UIView!
    /// The label that has the name of the colour
    @IBOutlet weak var colorLabel: UILabel!

}
