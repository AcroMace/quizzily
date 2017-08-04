//
//  QuestionCard.swift
//  Quizzily
//
//  Created by Andy Cho on 2015-03-16.
//  Copyright (c) 2015 Andy Cho. All rights reserved.
//

// swiftlint:disable identifier_name

import CoreData

/**
    A representation of a flashcard
*/
@objc(QuestionCard)
class QuestionCard: NSManagedObject {
    /// Unique ID of the card
    @NSManaged var id: Int
    /// Term (answer)
    @NSManaged var term: String
    /// Definition of the term
    @NSManaged var definition: String
    /// Order in the set
    @NSManaged var rank: Int
    /// URL of an image if it exists
    @NSManaged var image: String
    /// Set that the card belongs to
    @NSManaged var set: QuestionSet
}

/**
    `NSObject` instance of the `QuestionCard`.
    Used as a temporary instance before the user decides to save the card to the database.

    - SeeAlso: `QuestionCard`
    - SeeAlso: `QuestionSetTemp`
*/
class QuestionCardTemp {
    var id: Int
    var term: String
    var definition: String
    var rank: Int
    var image: String

    /**
        Create a `QuestionCardTemp`

        - parameter id: ID of the card from Quizlet
        - parameter term: The term of the card
        - parameter definition: The definition of the card
        - parameter rank: Order in the set given by Quizlet
        - parameter image: URL of an image for the card
        - returns: An initialized QuestionCardTemp instance
    */
    init(id: Int?, term: String?, definition: String?, rank: Int?, image: String?) {
        self.id = id ?? 0
        self.term = term ?? ""
        self.definition = definition ?? ""
        self.rank = rank ?? 0
        self.image = image ?? ""
    }

}
