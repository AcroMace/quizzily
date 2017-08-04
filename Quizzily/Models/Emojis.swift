//
//  Emojis.swift
//  Quizzily
//
//  Created by Andy Cho on 2015-07-16.
//  Copyright (c) 2015 Andy Cho. All rights reserved.
//

import Foundation

/**
    A class that provides Emojis to use where graphic assets are absent
*/
enum Emoji {
    case happyFace
    case sadFace
    case neutralFace
    case PointUp
    case PointLeft
    case PointRight
    case Celebrate
    case Error

    //
    // MARK: - Public methods
    //

    /**
     Get an Emoji string for the type specified

     - returns: An Emoji as a `String`
     */
    func string() -> String {
        let listToUse: [String]
        switch self {
        case .happyFace:
            listToUse = Emoji.faceHappy
        case .sadFace:
            listToUse = Emoji.faceSad
        case .neutralFace:
            return Emoji.faceNeutral
        case .PointUp:
            listToUse = Emoji.pointUp
        case .PointLeft:
            listToUse = Emoji.pointLeft
        case .PointRight:
            listToUse = Emoji.pointRight
        case .Celebrate:
            listToUse = Emoji.celebrate
        case .Error:
            listToUse = Emoji.error
        }
        return getRandomFromArray(listToUse)
    }

    /**
        Gets a random `String` from an array of `String`s

        - parameter array: An array of `String`s
        - returns: A single `String` picked from the array
    */
    fileprivate func getRandomFromArray(_ array: [String]) -> String {
        return array[Int(arc4random_uniform(UInt32(array.count)))]
    }

}

//
// MARK: - Emoji warehouse
//

extension Emoji {

    /// A list of Emojis that are pointing up
    fileprivate static let pointUp = ["👆", "☝️", "👆🏻", "☝🏻", "👆🏼", "☝🏼", "👆🏽", "☝🏽", "☝🏾", "👆🏾", "☝🏿", "👆🏿"]

    /// A list of Emojis that are pointing right
    fileprivate static let pointRight = ["👉", "👉🏻", "👉🏼", "👉🏽", "👉🏾", "👉🏿"]

    /// A list of Emojis that are pointing left
    fileprivate static let pointLeft = ["👈", "👈🏻", "👈🏼", "👈🏽", "👈🏾", "👈🏿"]

    /// A list of Emojis that are celebrating
    fileprivate static let celebrate = ["🎉", "🎊", "🎓", "💃", "💃🏻", "💃🏼", "💃🏽", "💃🏾", "💃🏿", "👯", "🙌", "🙌🏻", "🙌🏼", "🙌🏽", "🙌🏾", "🙌🏿", "👏", "👏🏻", "👏🏼", "👏🏽", "👏🏾", "👏🏿", "👍", "👍🏻", "👍🏼", "👍🏽", "👍🏾", "👍🏿", "👌", "👌🏻", "👌🏼", "👌🏽", "👌🏾", "👌🏿", "✌️", "✌🏻", "✌🏼", "✌🏽", "✌🏾", "✌🏿", "🐵"]

    /// A list of Emojis to show in the event of an error
    fileprivate static let error = ["😅", "😐", "😞", "😳", "🙈", "🙉", "🙊"]

    /// A list of Emojis that look happy
    fileprivate static let faceHappy = ["😄", "😃", "😊", "😀", "😆", "😎", "😄", "😊", "😋", "☺️"]

    /// A list of Emojis that look sad
    fileprivate static let faceSad = ["😣", "😥", "😒", "😓", "😔", "😖", "😲", "😞", "😟", "😢", "😭", "😦", "😧", "😨", "😩", "😬", "😰", "😱", "😳", "😵", "😡", "😠"]

    /// The only neutral looking Emoji I could find
    fileprivate static let faceNeutral = "😐"

}
