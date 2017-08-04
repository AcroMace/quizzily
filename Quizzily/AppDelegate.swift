//
//  AppDelegate.swift
//  Quizzily
//
//  Created by Andy Cho on 2015-03-16.
//  Copyright (c) 2015 Andy Cho. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    //
    // MARK: - Initialization
    //

    /**
        Called when the application launches.
        Hide the status bar, make the text on the status bar white, and initialize Smooch
    */
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        // Set the theme
        application.isStatusBarHidden = false
        application.statusBarStyle = UIStatusBarStyle.lightContent
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().barTintColor = Color.getPrimary()
        UINavigationBar.appearance().titleTextAttributes = [ NSAttributedStringKey.foregroundColor: UIColor.white ]
        UINavigationBar.appearance().isTranslucent = false

        initSmooch()
        return true
    }

    /**
        Initialize Smooch

        - Start it in the background with the app token
        - Customize the appearance
    */
    fileprivate func initSmooch() {
        guard let smoochToken = Constants.Smooch.Token else {
            print("ERROR: Smooch key not configured")
            return
        }
        let smoochSettings = SKTSettings(appToken: smoochToken)

        // Smooch appearance customization
        smoochSettings.conversationAccentColor = Color.getPrimary()
        smoochSettings.conversationStatusBarStyle = UIStatusBarStyle.lightContent

        Smooch.initWith(smoochSettings)
    }

    /**
        Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    */
    func applicationWillTerminate(_ application: UIApplication) {
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    //
    // MARK: - Core Data stack
    //

    /**
        The directory the application uses to store the Core Data store file. This code uses a directory named "com.acromace.Quizzily" in the application's documents Application Support directory.
    */
    lazy var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()

    /**
        The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
    */
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: "Quizzily", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    /**
        The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
    */
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("Quizzily.sqlite")
        let failureReason = "There was an error creating or loading the application's saved data."

        // Add the default data
        // Check to see that a database does not exist
        if !FileManager.default.fileExists(atPath: url.path) {
            let preloadUrl = URL(fileURLWithPath: Bundle.main.path(forResource: "QuizzilyDefaultData", ofType: "sqlite")!)
            do {
                try FileManager.default.copyItem(at: preloadUrl, to: url)
                print("Successfully copied preloaded data")
            } catch let error as NSError {
                print("Could not copy preloaded data :(")
                print(error)
            }
        }

        do {
            // Enable automatic migration
            let coordinatorOptions = [
                NSMigratePersistentStoresAutomaticallyOption: true,
                NSInferMappingModelAutomaticallyOption: true
            ]
            try coordinator!.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: coordinatorOptions)
        } catch var error as NSError {
            coordinator = nil
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error.userInfo)")
            abort()
        } catch {
            fatalError()
        }

        return coordinator
    }()

    /**
        Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
    */
    lazy var managedObjectContext: NSManagedObjectContext? = {
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    //
    // MARK: - Core Data Saving support
    //

    /**
        Save the changes made
    */
    func saveContext () {
        guard let moc = self.managedObjectContext, moc.hasChanges else { return }
        do {
            try moc.save()
        } catch let error as NSError {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error.userInfo)")
            abort() // TODO: Handle the database saving failure error better
        }
    }

}
