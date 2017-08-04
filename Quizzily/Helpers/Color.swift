//
//  Color.swift
//  Quizzily
//
//  Created by Andy Cho on 2015-05-15.
//  Copyright (c) 2015 Andy Cho. All rights reserved.
//

import Foundation

//
// MARK: - Enumerators
//

/**
 All possible shades of themes supported
 */
fileprivate enum Shade: String {
    case pink = "Pink"
    case red = "Red"
    case amber = "Amber"
    case lightGreen = "Light Green"
    case teal = "Teal"
    case indigo = "Indigo"
    case brown = "Brown"
    case blueGrey = "Blue Grey"
}

/**
 The categories of colour - mostly changes in darkness
 */
fileprivate enum Category {
    case primary
    case accentLight
    case accentDark
    case answerLight
    case answerDark
}

/**
    A class of static methods designed to be used to enable easy access to colour constants
    across different themes
*/
class Color {

    /// Cache the theme so that it doesn't have to be fetched for each view
    fileprivate static var theme: Shade?

    //
    // MARK: - Public functions
    //

    /**
        Gets the current primary colour

        - parameter color: Optionally override the `Theme` by passing in the name of the `Theme`
        - returns: A `UIColor` instance for the primary colour of the current theme or the one optionally specified by the `color` parameter
    */
    static func getPrimary(_ color: String? = nil) -> UIColor {
        if color == nil {
            theme = Shade(rawValue: Theme.get())
            return get(Category.primary)
        } else {
            let shade = Shade(rawValue: color!)!
            return get(shade, category: Category.primary)
        }
    }

    /**
        Gets the current light accent colour

        - returns: A `UIColor` instance for the light accent colour of the current theme
    */
    static func getAccentLight() -> UIColor {
        return get(Category.accentLight)
    }

    /**
        Gets the current dark accent colour

        - parameter color: Optionally override the `Theme` by passing in the name of the `Theme`
        - returns: A `UIColor` instance for the dark accent colour of the current theme or the one optionally specified by the `color` parameter
    */
    static func getAccentDark(_ color: String? = nil) -> UIColor {
        if color == nil {
            theme = Shade(rawValue: Theme.get())
            return get(Category.accentDark)
        } else {
            let shade = Shade(rawValue: color!)!
            return get(shade, category: Category.accentDark)
        }
    }

    /**
        Gets the current light answer cell colour

        - returns: A `UIColor` instance for the light answer cell colour of the current theme
    */
    static func getAnswerLight() -> UIColor {
        return get(Category.answerLight)
    }

    /**
        Gets the current dark answer cell colour

        - returns: A `UIColor` instance for the dark answer cell colour of the current theme
    */
    class func getAnswerDark() -> UIColor {
        return get(Category.answerDark)
    }

    /**
        Gets the colour to use for correct answers

        - returns: A `UIColor` instance for the correct answer colour
    */
    class func getAnswerCorrect() -> UIColor {
        return ColorValues.Answer.Correct
    }

    /**
        Gets the colour to use for incorrect answers

        - returns: A `UIColor` instance for the incorrect answer colour
    */
    class func getAnswerIncorrect() -> UIColor {
        return ColorValues.Answer.Incorrect
    }

    //
    // MARK: - Private static functions
    //

    /**
     Get a `UIColor` given the shade and the category
     
     - parameter shade: A `Color.Shade` enum
     - parameter category: A `Color.Category` enum
     - returns: A `UIColor` instance
     
     - note: This should not be called often as we should be using the `get` that gets the `shade` automatically from the `Theme`
     */
    fileprivate static func get(_ shade: Shade, category: Category) -> UIColor {
        return ColorValues.Colors[shade]![category]!
    }

    // Returns a UIColor for the current theme given the category
    /**
     Get a `UIColor` for the current theme given the category
     
     - parameter category: A `Color.Category` enum
     - returns: A `UIColor` instance
     
     **Side effects**
     
     - Sets the global `theme` private static variable if not set before
     */
    fileprivate static func get(_ category: Category) -> UIColor {
        ensureThemeExists()
        return get(theme!, category: category)
    }

    /**
     Sets the global `theme` private static variable if not set before
     */
    fileprivate class func ensureThemeExists() {
        if theme == nil {
            theme = Shade(rawValue: Theme.get())
        }
    }

}

//
// MARK: - Constants
//

/// Holds the initialized UIColor constants
fileprivate struct ColorValues {

    /// Colours of the cells for `Correct` and `Incorrect` answers
    fileprivate struct Answer {
        static let Correct = UIColor(hex: 0x8BC34A)
        static let Incorrect = UIColor(hex: 0xF44336)
    }

    /**
     Dictionary of dictionaries - use `Colors[shade][category]` to get a `UIColor`

     *General color structures*

     - `Primary` [700]: Background, text, navigation bar
     - `AccentLight` [100]: End of game text - same as `AnswerDark`
     - `AccentDark` [800]: Buttons
     - `AnswerLight` [50]: Answer cells
     - `AnswerDark` [100]: Answer cells
     */
    fileprivate static let Colors: [Shade: [Category: UIColor]] = [
        Shade.pink: [
            Category.primary: UIColor(hex: 0xC2185B),
            Category.accentLight: UIColor(hex: 0xF8BBD0),
            Category.accentDark: UIColor(hex: 0xAD1457),
            Category.answerLight: UIColor(hex: 0xFCE4EC),
            Category.answerDark: UIColor(hex: 0xF8BBD0)
        ],
        Shade.red: [
            Category.primary: UIColor(hex: 0xD32F2F),
            Category.accentLight: UIColor(hex: 0xFFCDD2),
            Category.accentDark: UIColor(hex: 0xB71C1C),
            Category.answerLight: UIColor(hex: 0xFFEBEE),
            Category.answerDark: UIColor(hex: 0xFFCDD2)
        ],
        Shade.amber: [
            Category.primary: UIColor(hex: 0xFFA000),
            Category.accentLight: UIColor(hex: 0xFFECB3),
            Category.accentDark: UIColor(hex: 0xFF8F00),
            Category.answerLight: UIColor(hex: 0xFFF8E1),
            Category.answerDark: UIColor(hex: 0xFFECB3)
        ],
        Shade.lightGreen: [
            Category.primary: UIColor(hex: 0x689F38),
            Category.accentLight: UIColor(hex: 0xDCEDC8),
            Category.accentDark: UIColor(hex: 0x558B2F),
            Category.answerLight: UIColor(hex: 0xF1F8E9),
            Category.answerDark: UIColor(hex: 0xDCEDC8)
        ],
        Shade.teal: [
            Category.primary: UIColor(hex: 0x00796B),
            Category.accentLight: UIColor(hex: 0xC8E6C9),
            Category.accentDark: UIColor(hex: 0x00695C),
            Category.answerLight: UIColor(hex: 0xE8F5E9),
            Category.answerDark: UIColor(hex: 0xC8E6C9)
        ],
        Shade.indigo: [
            Category.primary: UIColor(hex: 0x1976D2),
            Category.accentLight: UIColor(hex: 0xBBDEFB),
            Category.accentDark: UIColor(hex: 0x1565C0),
            Category.answerLight: UIColor(hex: 0xE3F2FD),
            Category.answerDark: UIColor(hex: 0xBBDEFB)
        ],
        Shade.brown: [
            Category.primary: UIColor(hex: 0x6D4C41),
            Category.accentLight: UIColor(hex: 0xD7CCC8),
            Category.accentDark: UIColor(hex: 0x5D4037),
            Category.answerLight: UIColor(hex: 0xEFEBE9),
            Category.answerDark: UIColor(hex: 0xD7CCC8)
        ],
        Shade.blueGrey: [
            Category.primary: UIColor(hex: 0x607D8B),
            Category.accentLight: UIColor(hex: 0xCFD8DC),
            Category.accentDark: UIColor(hex: 0x546E7A),
            Category.answerLight: UIColor(hex: 0xECEFF1),
            Category.answerDark: UIColor(hex: 0xCFD8DC)
        ]
    ]

}
