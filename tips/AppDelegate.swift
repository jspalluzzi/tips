//
//  AppDelegate.swift
//  tips
//
//  Created by John Spalluzzi on 12/28/15.
//  Copyright © 2015 johns. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let defaults = NSUserDefaults.standardUserDefaults()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        if((defaults.objectForKey("first_launch")) != nil){
            self.checkLastUsedTime()
        }
        else{
            defaults.setInteger( 1 , forKey: "first_launch")
            
            defaults.setInteger(20, forKey: "tip_percent_default")
            defaults.setInteger(1, forKey: "tip_percent_min")
            defaults.setInteger(40, forKey: "tip_percent_max")
            
            defaults.setInteger(8, forKey: "split_bill_max")
            
            defaults.setBool(false, forKey: "dark_theme")
        }
        defaults.synchronize()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        
        let lastUsedTime: NSDate = NSDate()
        defaults.setObject(lastUsedTime, forKey: "last_used_time")
        defaults.synchronize()
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
    
    func checkLastUsedTime(){
        
        let saveTilTime = 600
        
        let lastUsedTime = defaults.objectForKey("last_used_time")
        if(lastUsedTime == nil){ return }
        let timeSince = Int((lastUsedTime?.timeIntervalSinceNow)! * -1)
        print(timeSince)
        
        if(timeSince > saveTilTime){
            defaults.setDouble(0.0, forKey: "last_saved_value")
        }
        
    }

}

