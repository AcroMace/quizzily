//
//  QuizletHandler.swift
//  Quizzily
//
//  Created by Andy Cho on 2015-03-16.
//  Copyright (c) 2015 Andy Cho. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import CoreData

class QuizletHandler {

    //
    // MARK: - Interface with Quizlet
    //

    /**
        Search for sets with key words

        - parameter query:   Key words to query Quizlet with
        - parameter success: A callback that takes a list of the results of type `QuestionSetTemp`
    */
    class func searchSets(_ query: String, success: @escaping ((_ tempSet: [QuestionSetTemp]) -> Void)) {
        let url = makeURL("/search/sets", options: "q=\(query)")

        Alamofire.request(url).responseJSON { response in
            let result = response.result

            guard result.isSuccess == true else {
                print("ERROR: Request failed")
                print(result)
                return
            }

            // Error making a request
            if let error = response.error {
                print(error.localizedDescription)
                return
            }

            // Request successful but invalid data returned
            guard result.value != nil else {
                print("ERROR: No data returned from the server")
                return
            }

            print("Success: \(url)")

            let json = JSON(result.value!) // JSON response from Quizlet
            print(json)

            if let setsArray = json["sets"].array {
                // Array of QuestionSetTemp to be returned
                var questionSetList = [QuestionSetTemp]()

                for searchResultSet in setsArray {
                    questionSetList.append(QuestionSetTemp(
                        id: searchResultSet["id"].int,
                        title: searchResultSet["title"].string,
                        creator: searchResultSet["created_by"].string,
                        setDescription: searchResultSet["description"].string
                    ))
                }
                success(questionSetList)
            } else {
                print("Sets not found")
            }
        }
    }

    /**
        Downloads and saves the set given Quizlet's ID of the set.

        - parameter setId:   Quizlet's set ID
        - parameter success: Callback called after the set is downloaded with the local set
    */
    class func downloadAndSaveSet(_ setId: Int, success: @escaping ((_ set: QuestionSet?) -> Void)) {
        downloadSet(setId, success: { (tempSet: QuestionSetTemp) -> Void in
            success(self.saveTempSet(tempSet))
        })
    }

    /**
        Downloads a set and instantiates a `QuestionSetTemp`

        - parameter setId:   Quizlet's set ID of the set to download
        - parameter success: Callback called if the download is successful with a `QuestionSetTemp`
    */
    class func downloadSet(_ setId: Int, success: @escaping ((_ tempSet: QuestionSetTemp) -> Void)) {
        let url = makeURL("/sets/" + String(setId))

        Alamofire.request(url).responseJSON { response in
            let result = response.result

            guard result.isSuccess == true else {
                print("ERROR: Request failed")
                print(result)
                return
            }

            // Error making a request
            if let error = response.error {
                print(error.localizedDescription)
                return
            }

            // Request successful but invalid data returned
            guard result.value != nil else {
                print("ERROR: No data returned from the server")
                return
            }

            print("Success: \(url)")

            let json = JSON(result.value!) // JSON response from Quizlet

            // Array of terms returned by Quizlet exists
            if let questionsArray = json["terms"].array {
                let questionSet = QuestionSetTemp(
                    id: setId,
                    title: json["title"].string,
                    creator: json["created_by"].string,
                    setDescription: json["description"].string
                )
                for question in questionsArray {
                    let questionCard = QuestionCardTemp(
                        id: question["id"].int,
                        term: question["term"].string,
                        definition: question["definition"].string,
                        rank: question["rank"].int,
                        image: question["image"].string
                    )
                    questionSet.addToCards(questionCard)
                }
                success(questionSet)
            }
        }
    }

    //
    // MARK: - Local database addition
    //

    /**
        Save a temporary set to the local database

        - parameter tempSet: An instance of a temporary set `QuestionSetTemp` to save to the local database

        - returns: A `QuestionSet` saved to the local database if the save was successful
    */
    class func saveTempSet(_ tempSet: QuestionSetTemp) -> QuestionSet? {
        let managedContext = getManagedContext()

        // Ensure that all sets have at least 4 cards
        if tempSet.cards.count < 4 {
            return nil
        }

        let questionSet = NSEntityDescription.insertNewObject(forEntityName: "QuestionSet", into: managedContext) as? QuestionSet

        guard questionSet != nil else {
            return nil
        }

        // Create the set
        questionSet!.setValuesForKeys([
            "id": tempSet.id,
            "title": tempSet.title,
            "creator": tempSet.creator,
            "setDescription": tempSet.setDescription,
            "downloadedAt": tempSet.downloadedAt,
            "lastPracticed": tempSet.lastPracticed
        ])

        // Create the questions
        for tempCard in tempSet.cards {
            if let questionCard = NSEntityDescription.insertNewObject(forEntityName: "QuestionCard", into: managedContext) as? QuestionCard {
                questionCard.setValuesForKeys([
                    "term": tempCard.term,
                    "definition": tempCard.definition,
                    "rank": tempCard.rank,
                    "id": tempCard.id,
                    "image": tempCard.image,
                    "set": questionSet! // set relation
                ])
            }
        }

        // Save to the database
        if saveChanges() {
            return questionSet
        } else {
            return nil
        }
    }

    /**
        Save changes to all managed objects the database

        - returns: `true` if the save was successful, `false` if not
    */
    class func saveChanges() -> Bool {
        let managedContext = getManagedContext()
        do {
            try managedContext.save()
            return true
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
            return false
        }
    }

    //
    // MARK: - Local database retrieval
    //

    /**
        Fetch all sets currently stored in the local databse

        - returns: A list of all sets currently stored in the local database
    */
    class func getAllLocalSets() -> [QuestionSet] {
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "QuestionSet")

            let fetchedResults = try getManagedContext().fetch(fetchRequest) as? [NSManagedObject]

            guard fetchedResults != nil else {
                return []
            }

            if let results = fetchedResults as? [QuestionSet] {
                return results
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return []
    }

    /**
        Check if a set with an ID exists in the local database

        - parameter id: Quizlet's set ID

        - returns: `true` if the set exists, `false` if it does not
    */
    class func setExists(with setID: Int) -> Bool {
        let managedContext = getManagedContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "QuestionSet")
        let predicate = NSPredicate(format: "id == %i", Int64(setID))
        fetchRequest.predicate = predicate
        if let fetchResults = (try? managedContext.fetch(fetchRequest)) as? [NSManagedObject] {
            if fetchResults.count > 0 {
                return true
            }
        }
        return false
    }

    //
    // MARK: - Local database deletion
    //

    /**
        Delete locally saved sets

        - parameter sets: List of sets to delete from the local database
    */
    class func deleteSets(_ sets: [QuestionSet]) {
        let managedContext = getManagedContext()

        for set in sets {
            print("Deleting set: \(set.title)")
            managedContext.delete(set)
        }

        do {
            try managedContext.save()
            print("Set successfully deleted")
        } catch let error as NSError {
            print("Deletion failed \(error): \(error.userInfo)")
        }
    }

    /**
        Delete a locally saved set given the set itself

        - parameter set: The set to delete
    */
    class func deleteSet(_ set: QuestionSet) {
        deleteSets([set])
    }

    /**
        Delete all sets in the local database
    */
    class func deleteAllSets() {
        deleteSets(getAllLocalSets())
    }

    //
    // MARK: - Private helper functions
    //

    /**
        Get the managed context of the application

        - returns: An instance of a managed object context
    */
    fileprivate class func getManagedContext() -> NSManagedObjectContext {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            return appDelegate.managedObjectContext!
        } else {
            print("ERROR: Could not get the managed object context")
            return NSManagedObjectContext()
        }
    }

    /**
        Make the URL for the API query

        - parameter route:   Quizlet's route to call
        - parameter options: GET parameters for the request

        - returns: The URL to request
    */
    fileprivate class func makeURL(_ route: String, options: String = "") -> String {
        let baseUrl = "https://api.quizlet.com/2.0"
        // Can use &whitespace=1 for a formatted result
        let escapedOptions = options.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let url = baseUrl + route + "?client_id=" + Constants.Quizlet.ClientId + "&" + escapedOptions
        return url
    }

}
