//
//  AppDelegate.swift
//  NowImHere
//
//  Created by 杉田浩隆 on 2019/06/24.
//  Copyright © 2019 杉田浩隆. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Thread.sleep(forTimeInterval: 1.5)
        // Override point for customization after application launch.
        
//        if LoginTools.getLoginState() {
//            LoginViewModel.requestDataWithUserNameAndPassword(Username: LoginTools.getUsername(), Password: LoginTools.getPassword()){
//                
//            }
//            self.window = UIWindow.init(frame: UIScreen.main.bounds)
//            self.window?.makeKeyAndVisible()
//            let homeNaviController = UIStoryboard(name: "Main", bundle: nil)
//                .instantiateViewController(withIdentifier: "Home_ID") as! UINavigationController
//            self.window?.rootViewController = homeNaviController
//            
//        }
//        else{
//            self.window = UIWindow.init(frame: UIScreen.main.bounds)
//            self.window?.makeKeyAndVisible()
//            let loginController = UIStoryboard(name: "Main", bundle: nil)
//                .instantiateViewController(withIdentifier: "Login_ID")
//            self.window?.rootViewController = loginController
//        }
//        if #available(iOS 13.0,*) {
//            window?.overrideUserInterfaceStyle = .light
//        }
        
        return true
    }
    func application(application: UIApplication, shouldAllowExtensionPointIdentifier extensionPointIdentifier: String) -> Bool {
        if extensionPointIdentifier == UIApplication.ExtensionPointIdentifier.keyboard.rawValue {
            return false
        }
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
        NotificationCenter.default.post(name: NSNotification.Name("applicationWillEnterForeground"), object: nil)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        NotificationCenter.default.removeObserver(self)
    }


}

