//
//  AppDelegate.swift
//  MatchingGenerations
//
//  Created by Oscar Blanco Castan on 26/2/16.
//  Copyright © 2016 AlcaponeTeam. All rights reserved.
//

import UIKit

let userId = "56d088c2fff2d8905ab4d9da"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        UINavigationBar.appearance().barStyle = UIBarStyle.Black
        UINavigationBar.appearance().barTintColor = UIColor(red:0.1, green:0.69, blue:0.36, alpha:1);
        UINavigationBar.appearance().tintColor = UIColor.whiteColor();
        UINavigationBar.appearance().translucent = false;
        
        UITabBar.appearance().barTintColor = UIColor(red:0.1, green:0.69, blue:0.36, alpha:1);
        UITabBar.appearance().tintColor = UIColor.whiteColor();
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

