//
//  Theme.swift
//  Quizzily
//
//  Created by Andy Cho on 2015-07-04.
//  Copyright (c) 2015 Andy Cho. All rights reserved.
//

import Foundation

/**
    The name of the theme of the app chosen by the user.
    Actual logic of the theme is done in `Color`.

    - SeeAlso: `Color`
*/
class Theme {

    /**
        Get the name of the current theme

        - returns: The name of the current theme

        - note: Returns "Teal" if none exists
    */
    class func get() -> String {
        let theme = UserDefaults.standard.object(forKey: "theme") as? String
        if theme == nil {
            return "Teal"
        }
        return theme!
    }

    /**
        Set a new theme

        - parameter theme: The name of the new theme

        - warning: No validation is done to ensure that the name of the theme actually exists
    */
    class func set(_ theme: String) {
        let defaults = UserDefaults.standard
        defaults.set(theme, forKey: "theme")
        defaults.synchronize()
    }

}
