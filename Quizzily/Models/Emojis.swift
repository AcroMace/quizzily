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
    case pointUp
    case pointLeft
    case pointRight
    case celebrate
    case error

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
            listToUse = Emoji.happyFaceEmojis
        case .sadFace:
            listToUse = Emoji.sadFaceEmojis
        case .neutralFace:
            return Emoji.neutralFaceEmoji
        case .pointUp:
            listToUse = Emoji.pointUpEmojis
        case .pointLeft:
            listToUse = Emoji.pointLeftEmojis
        case .pointRight:
            listToUse = Emoji.pointRightEmojis
        case .celebrate:
            listToUse = Emoji.celebrateEmojis
        case .error:
            listToUse = Emoji.errorEmojis
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
    fileprivate static let pointUpEmojis = ["👆", "☝️", "👆🏻", "☝🏻", "👆🏼", "☝🏼", "👆🏽", "☝🏽", "☝🏾", "👆🏾", "☝🏿", "👆🏿"]

    /// A list of Emojis that are pointing right
    fileprivate static let pointRightEmojis = ["👉", "👉🏻", "👉🏼", "👉🏽", "👉🏾", "👉🏿"]

    /// A list of Emojis that are pointing left
    fileprivate static let pointLeftEmojis = ["👈", "👈🏻", "👈🏼", "👈🏽", "👈🏾", "👈🏿"]

    /// A list of Emojis that are celebrating
    fileprivate static let celebrateEmojis = ["🎉", "🎊", "🎓", "💃", "💃🏻", "💃🏼", "💃🏽", "💃🏾", "💃🏿", "👯", "🙌", "🙌🏻", "🙌🏼", "🙌🏽", "🙌🏾", "🙌🏿", "👏", "👏🏻", "👏🏼", "👏🏽", "👏🏾", "👏🏿", "👍", "👍🏻", "👍🏼", "👍🏽", "👍🏾", "👍🏿", "👌", "👌🏻", "👌🏼", "👌🏽", "👌🏾", "👌🏿", "✌️", "✌🏻", "✌🏼", "✌🏽", "✌🏾", "✌🏿", "🐵"]

    /// A list of Emojis to show in the event of an error
    fileprivate static let errorEmojis = ["😅", "😐", "😞", "😳", "🙈", "🙉", "🙊"]

    /// A list of Emojis that look happy
    fileprivate static let happyFaceEmojis = ["😄", "😃", "😊", "😀", "😆", "😎", "😄", "😊", "😋", "☺️"]

    /// A list of Emojis that look sad
    fileprivate static let sadFaceEmojis = ["😣", "😥", "😒", "😓", "😔", "😖", "😲", "😞", "😟", "😢", "😭", "😦", "😧", "😨", "😩", "😬", "😰", "😱", "😳", "😵", "😡", "😠"]

    /// The only neutral looking Emoji I could find
    fileprivate static let neutralFaceEmoji = "😐"

}
