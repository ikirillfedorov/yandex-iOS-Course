//
//  AppDelegate.swift
//  Notes
//
//  Created by Kirill Fedorov on 24/06/2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import UIKit
import CorePlot
import CocoaLumberjack

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        #if DEBUG
        let note1 = Note(uid: nil, title: "Title", content: "Buy milk", noteColor: .red, importance: .important, destractionDate: nil)
        let note2 = Note(uid: nil, title: "Title", content: "Buy bread", noteColor: .green, importance: .important, destractionDate: nil)

        let notebook = FileNotebook()
        
        notebook.add(note1)
        print("Now in notebook \(notebook.notes.count) notes")
        notebook.add(note2)
        print("Now in notebook \(notebook.notes.count) notes")

        notebook.saveToFile()
        
        notebook.remove(with: note1.uid)
        print("Now in notebook \(notebook.notes.count) notes")

        notebook.remove(with: note2.uid)
        print("Now in notebook \(notebook.notes.count) notes")

        notebook.loadFromFile()
        print("Now in notebook \(notebook.notes.count) notes")
        #endif

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

