//
//  AppDelegate.swift
//  ezpay
//
//  Created by Albert Charles on 02/04/21.
//"com_ezpay_nissi_Clip"

import UIKit
import CoreData
import Firebase
import GoogleSignIn
import Stripe


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        var db = Firestore.firestore()
        
        if #available(iOS 13.0, *){
            print("iOS 13")
            UIApplication.shared.isStatusBarHidden = false
            UIApplication.shared.statusBarStyle = UIStatusBarStyle.darkContent
        }
        else{
            window = UIWindow(frame: UIScreen.main.bounds)
            if let window = window {
                print("window")

                let main = ViewController()
                
                let navigationController = UINavigationController(rootViewController: main)
                window.rootViewController = navigationController
                window.makeKeyAndVisible()
            }
        }
        STPPaymentConfiguration.shared.publishableKey = "pk_test_51IgtnoLRPkh4LOyDkQ7muN6jaUaM6kEOuVpYC2EnKjfJJePylwIFT1ONqSK7jB5Ttv2heTGSq5J96dzu0u4tSxmj00THY1DwUO"
        STPPaymentConfiguration.shared.appleMerchantIdentifier = "merchant.com.ezpay.nissi"
        STPPaymentConfiguration.shared.companyName = "eZpay"
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentCloudKitContainer(name: "ezpay")
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

