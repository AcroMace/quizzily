//
//  QuestionSet.swift
//  Quizzily
//
//  Created by Andy Cho on 2015-03-16.
//  Copyright (c) 2015 Andy Cho. All rights reserved.
//

import Foundation
import CoreData

/**
    A representation of a set of flashcards
*/
@objc(QuestionSet)
class QuestionSet: NSManagedObject {
    /// Set ID
    @NSManaged var id: Int64
    /// Title of the set
    @NSManaged var title: String
    /// Creator of the set
    @NSManaged var creator: String
    /// Description of the set
    @NSManaged var setDescription: String
    /// Date that the set was downloaded
    @NSManaged var downloadedAt: Date
    /// The last date the set was used in a game
    @NSManaged var lastPracticed: Date
    /// Reference to the list pf QuestionCard in this set
    @NSManaged var cards: NSSet
    /// If `true`, flip the definition and the term in the quiz
    @NSManaged var flipTermAndDefinition: Bool
}

/**
    `NSObject` instance of the `QuestionSet`.
    Used as a temporary instance before the user decides to save the set to the database.

    - SeeAlso: `QuestionSet`
    - SeeAlso: `QuestionCardTemp`
*/
class QuestionSetTemp {
    var id: Int
    var title: String
    var creator: String
    var setDescription: String
    var downloadedAt: Date
    var lastPracticed: Date
    var cards: [QuestionCardTemp]
    var flipTermAndDefinition: Bool

    init(id: Int?, title: String?, creator: String?, setDescription: String?) {
        self.id = id ?? 0
        self.title = title ?? ""
        self.creator = creator ?? ""
        self.setDescription = setDescription ?? ""
        self.downloadedAt = Date()
        self.lastPracticed = Date(timeIntervalSince1970: 0)
        self.cards = [QuestionCardTemp]()
        self.flipTermAndDefinition = false
    }

    func addToCards(_ card: QuestionCardTemp) {
        cards.append(card)
    }

}
