//
//  AppDelegate.swift
//  Final Project
//
//  Created by Jack Thompson on 12/1/17.
//  Copyright © 2017 Jack Thompson. All rights reserved.
//

import UIKit
import SpotifyLogin

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let tabBarController = UITabBarController()
        tabBarController.tabBar.isTranslucent = false
        
        let profileVC = ProfileViewController()
        profileVC.title = "Profile"
        let profileNavigationController = UINavigationController(rootViewController: profileVC)
        profileNavigationController.navigationBar.isTranslucent = false
        profileNavigationController.navigationBar.barStyle = .black
        profileNavigationController.navigationBar.barTintColor = Constants.barColor
        
        let playlistsVC = PlaylistsViewController()
        playlistsVC.title = "Playlists"
        playlistsVC.getPlaylists()
        
        let playlistsNavigationController = UINavigationController(rootViewController: playlistsVC)
        playlistsNavigationController.navigationBar.isTranslucent = false
        playlistsNavigationController.navigationBar.barStyle = .black
        playlistsNavigationController.navigationBar.barTintColor = Constants.barColor
        
        let createVC = CreatePlaylistViewController()
        createVC.title = "Playlists"
        let createNavigationController = UINavigationController(rootViewController: createVC)
        createNavigationController.navigationBar.isTranslucent = false
        createNavigationController.navigationBar.barStyle = .black
        createNavigationController.navigationBar.barTintColor = Constants.barColor
        
        
        
        
        profileNavigationController.tabBarItem = UITabBarItem(title: "Profile", image: #imageLiteral(resourceName: "profile"), tag: 0)
        playlistsNavigationController.tabBarItem = UITabBarItem(title: "Playlists", image: #imageLiteral(resourceName: "playlist"), tag: 1)
        createNavigationController.tabBarItem = UITabBarItem(title: "Create", image: #imageLiteral(resourceName: "create"), tag: 2)
        
        let controllers = [profileNavigationController, playlistsNavigationController, createNavigationController]
        tabBarController.setViewControllers(controllers, animated: true)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = tabBarController
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        
        
        
        SpotifyLogin.shared.configure(clientID: "5d48356640a14d7880744f76b3230186", clientSecret: "5740fe4fde9b46a684cdf033ec074a19", redirectURL: URL(string: "final-project://returnafterlogin")!)
        return true
    }
    
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled = SpotifyLogin.shared.applicationOpenURL(url) { (error) in }
        return handled
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


