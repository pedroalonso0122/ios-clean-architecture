//
//  AppDelegate.swift
//  Apartment Rent Management
//
//  Created by Pedro Alonso on 2020/10/27.
//  Copyright © 2020 Pedro Alonso. All rights reserved.
//

import UIKit
import GoogleSignIn
import GoogleMaps
import GooglePlaces
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        ApplicationDelegate.shared.application(
                    application,
                    didFinishLaunchingWithOptions: launchOptions
                )
        
        GIDSignIn.sharedInstance().clientID = GOOGLE_CLIENT_ID
        
        GMSServices.provideAPIKey(GOOGLE_API_KEY)

        GMSPlacesClient.provideAPIKey(GOOGLE_API_KEY)
                
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
    
    func application(_ application: UIApplication,
                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        let googleHandle = GIDSignIn.sharedInstance().handle(url)
        let facebookHandle = ApplicationDelegate.shared.application(
                    application,
                    open: url,
                    sourceApplication: sourceApplication,
                    annotation: annotation
                )

        return googleHandle || facebookHandle
    }

    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        let googleHandle = GIDSignIn.sharedInstance().handle(url)
        
        let facebookHandle =  ApplicationDelegate.shared.application(
                    app,
                    open: url,
                    sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                    annotation: options[UIApplication.OpenURLOptionsKey.annotation]
                )

        return googleHandle || facebookHandle
    }
    
    // MARK: Switch View Controller
        
    func switchToLogin() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rootController = storyboard.instantiateViewController(identifier: "LoginViewController")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(rootController)
    }
    
    func switchToApartment() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rootController = storyboard.instantiateViewController(identifier: "ApartmentNavigationController")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(rootController)
    }
    
    func switchToUser() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rootController = storyboard.instantiateViewController(identifier: "UserNavigationController")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(rootController)
    }
    
    func switchToProfile() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rootController = storyboard.instantiateViewController(identifier: "ProfileNavigationController")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(rootController)
    }
    
}

