//
//  AppDelegate.swift
//  MegaNews
//
//  Created by Eugene Kurilenko on 11/16/16.
//  Copyright © 2016 Eugene Kurilenko. All rights reserved.
//

import UIKit
import DrawerController

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var drawerController: DrawerController!
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
        //Navigation
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newsViewController = mainStoryboard
            .instantiateViewController(withIdentifier: Storyboard.newsViewController)
        let settingsViewController = mainStoryboard
            .instantiateViewController(withIdentifier: Storyboard.settingsViewController)
        
        let newsNav = UINavigationController(rootViewController: newsViewController)

        self.drawerController = DrawerController(centerViewController: newsNav,
                                                 leftDrawerViewController: settingsViewController)
        self.drawerController.showsShadows = true
        self.drawerController.shadowRadius = 4.0
        self.drawerController.shadowOpacity = 0.1
        self.drawerController.maximumLeftDrawerWidth = 320.0
        self.drawerController.openDrawerGestureModeMask = .all
        self.drawerController.closeDrawerGestureModeMask = .all
        
        self.drawerController.drawerVisualStateBlock = {(drawerController, drawerSide, percentVisible) in
            let visualStateBlock = DrawerVisualState.parallaxVisualStateBlock(parallaxFactor: 2.0)
            visualStateBlock(drawerController, drawerSide, percentVisible)
        }
        
        self.window?.rootViewController = drawerController
        
        return true
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.window?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.window?.makeKeyAndVisible()
        
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

