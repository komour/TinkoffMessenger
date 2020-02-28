//
//  AppDelegate.swift
//  TinkoffMessenger
//
//  Created by Always Strive And Prosper on 16.02.2020.
//  Copyright © 2020 komarov. All rights reserved.
//

import UIKit
import CoreData

func printLog(_ message : String) {
    #if Logs
        print(message)
    #endif
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    var window: UIWindow?
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//        printLog("The launch process is initiated: \(#function)\n")

        return true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        printLog("The application state changes from Non-running to Inactive: \(#function)\n")
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
//        printLog("The application state changes from Inactive to Active: \(#function)\n")
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
//        printLog("The application state changes from Active to Inactive: \(#function)\n")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
//        printLog("The application state changes from Foreground (Inactive) to Background: \(#function)\n")
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
//        printLog("The application state changes from Background to Foreground (Inactive): \(#function)\n")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
//        printLog("The application state changes from Background to Non-running: \(#function)\n")
    }
    


    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "TinkoffMessenger")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

