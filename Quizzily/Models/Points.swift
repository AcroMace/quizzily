//
//  Points.swift
//  Quizzily
//
//  Created by Andy Cho on 2015-07-04.
//  Copyright (c) 2015 Andy Cho. All rights reserved.
//

import Foundation

/**
    An interface to add and get points to display on the main screen
*/
class Points {

    //
    // MARK: - Public functions
    //

    /**
        Get the number of points the user currently has

        - returns: The amount of points the user has
    */
    class func get() -> Int {
        // TODO: The points should not be stored in NSUserDefaults
        let defaults = UserDefaults.standard
        let points = defaults.object(forKey: "points") as? Int
        if points == nil {
            reset()
            return 0
        }
        return points!
    }

    // Add points to the number of points
    /**
        Add points to the current number of points

        - parameter points: Amount of points to add to the current amount
        - returns: The new amount of points
    */
    class func add(_ points: Int) -> Int {
        let newPoints = get() + points
        set(newPoints)
        return newPoints
    }

    //
    // MARK: - Private functions
    //

    /**
        Set the number of points directly

        - parameter points: The new amount of points the user should have
    */
    fileprivate class func set(_ points: Int) {
        let defaults = UserDefaults.standard
        defaults.set(points, forKey: "points")
        defaults.synchronize()
    }

    /**
        Set the number of points to 0
    */
    fileprivate class func reset() {
        set(0)
    }

}
