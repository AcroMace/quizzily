//
//  Streak.swift
//  Quizzily
//
//  Created by Andy Cho on 2015-07-04.
//  Copyright (c) 2015 Andy Cho. All rights reserved.
//

import Foundation

/**
    Keep track of how many days in a row the player has played a `Game`
*/
class Streak {

    /// Convenience reference to the standard `NSUserDefaults`
    fileprivate static let defaults = UserDefaults.standard

    //
    // MARK: - Public static functions
    //

    /**
        Played every time a `Game` is played to update the streak

        **Side effects**

        - Update the number of `Game`s played
        - Set the `streakStartDate` if not currently on a streak
        - Set the `lastPlayedDate`
    */
    class func playedGame() {
        // Increase the number of games played
        NumberOfGamesPlayed.increment()
        increment()
    }

    /**
        Get the current streak in days

        - returns: The current streak in days

        - note: This is called whenever the user opens the app

        **Side effects**

        - Resets the streak if the user hasn't played in a long time
    */
    class func get() -> Int {
        checkIfBroken()

        // Set the streak date
        let streakStartDate = defaults.object(forKey: "streakStartDate") as? Date
        let lastPlayedDate = defaults.object(forKey: "lastPlayedDate") as? Date

        if streakStartDate == nil || lastPlayedDate == nil {
            return 0
        } else {
            // Adding 1 since at least 1 game has been played
            // but the Double->Int conversion rounds down
            let streak = Int(secondsToDays(lastPlayedDate!.timeIntervalSince(streakStartDate!))) + 1
            return streak > 0 ? streak : 0
        }
    }

    /**
        An internal check to see if a streak was broken

        **Side effects**

        - Resets dates to `nil` if it was
    */
    class func checkIfBroken() {
        // Set the streak date
        let currentDate = Date()
        let streakStartDate = defaults.object(forKey: "streakStartDate") as? Date
        let lastPlayedDate = defaults.object(forKey: "lastPlayedDate") as? Date

        // Check for broken streaks
        if streakStartDate == nil || lastPlayedDate == nil {
            // First game played (ever or after streak has been broken)
            resetTo(nil)
        } else if secondsToHours(currentDate.timeIntervalSince(lastPlayedDate!)) > Constants.Game.MaxStreakHours {
            // Broke the streak (case on startup before playing game)
            resetTo(nil)
        } else if currentDate.timeIntervalSince(lastPlayedDate!) < 0 {
            // Travelled back in time
            resetTo(nil)
        }
    }

    //
    // MARK: - Private static functions
    //

    /**
        Add to a streak after a game

        **Side effects**

        - Sets the streak to 1 day if the streak was broken
        - Sets the `streakStartDate` to the current time if no streak exists
        - Sets the `lastPlayedDate` to the current time
    */
    fileprivate class func increment() {
        // Set the streak date
        let currentDate = Date()
        let streakStartDate = defaults.object(forKey: "streakStartDate") as? Date
        let lastPlayedDate = defaults.object(forKey: "lastPlayedDate") as? Date

        // Set the time of the last game played
        defaults.set(currentDate, forKey: "lastPlayedDate")

        // Check for broken streaks
        checkIfBroken()
        if streakStartDate == nil || lastPlayedDate == nil {
            // First game played (ever or after streak has been broken)
            resetTo(currentDate)
        }
    }

    /**
        Reset both streak dates to the provided date

        - parameter date: Optional `NSDate` instance to set the `streakStartDate` and the `lastPlayedDate`

        - note: The `date` parameter can be `nil` to clear out the dates in the event that a streak was broken
    */
    fileprivate class func resetTo(_ date: Date?) {
        defaults.set(date, forKey: "streakStartDate")
        defaults.set(date, forKey: "lastPlayedDate")
        defaults.synchronize()
    }

    //
    // MARK: - Number of games played
    //

    /**
        Internal class inside `Streak` to keep track of the number of games played
    */
    fileprivate class NumberOfGamesPlayed {

        /**
            Increment the number of games played
        */
        class func increment() {
            defaults.set(get() + 1, forKey: "numberOfGamesPlayed")
        }

        /**
            Get the number of games played

            - note: Returns 0 if not set before
        */
        fileprivate class func get() -> Int {
            return defaults.integer(forKey: "numberOfGamesPlayed")
        }

    }

    //
    // MARK: - Private helper methods
    //

    /**
        Convert seconds to hours

        - parameter seconds: Amount of seconds to convert
        - returns: The seconds in hours
    */
    fileprivate class func secondsToHours(_ seconds: Double) -> Double {
        return seconds / 60 / 60
    }

    /**
        Convert seconds to days

        - parameter seconds: Amount of seconds to convert
        - returns: The seconds in days
    */
    fileprivate class func secondsToDays(_ seconds: Double) -> Double {
        return seconds / 60 / 60 / 24
    }

}
