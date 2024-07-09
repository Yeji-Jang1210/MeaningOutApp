//
//  AppDelegate.swift
//  MeaningOutApp
//
//  Created by 장예지 on 6/13/24.
//

import UIKit
import IQKeyboardManagerSwift
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        sleep(2)
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.resignOnTouchOutside = true
        
        IQKeyboardManager.shared.toolbarConfiguration.tintColor = Color.primaryOrange
        IQKeyboardManager.shared.toolbarConfiguration.barTintColor = Color.white
        
        print(Realm.Configuration.defaultConfiguration.fileURL)
        
        let config = Realm.Configuration(schemaVersion: 4){ migration, oldSchemaVersion in
            
            if oldSchemaVersion < 1 {
            }
            
            if oldSchemaVersion < 3 {
                //category 추가, linkedobject 추가
            }
            
            if oldSchemaVersion < 4 {
                //category description 추가
            }
            
        }
        
        Realm.Configuration.defaultConfiguration = config
        
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


}

