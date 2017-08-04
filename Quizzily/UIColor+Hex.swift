//
//  UIColor+Hex.swift
//  Quizzily
//
//  Created by Andy Cho on 2017-08-04.
//  Copyright © 2017 Andy Cho. All rights reserved.
//

import Foundation

//
// MARK: - UIColor extension
//

/**
 Extension for UIColor to enable initializing with a hex value
 */
extension UIColor {

    /**
     Initialize `UIColor` with hex
     
     - parameter hex: Hexadecimal representation of a number as an Integer in the form of `0xffffff`
     - returns: A `UIColor` instance
     
     - note: From Rudolf Adamkovic (http://stackoverflow.com/questions/24263007/how-to-use-hex-colour-values-in-swift-ios)
     */
    convenience init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }

}
