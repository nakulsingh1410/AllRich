//
//  AppDelegate.swift
//  SkySell
//
//  Created by DW02 on 4/12/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

import GoogleSignIn
import FBSDKCoreKit

import RealmSwift

import Fabric
import Crashlytics
import GooglePlaces
import GoogleMaps
import Stripe

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //pk_test_6pRNASCoBOKtIshFeQd4XMUh
        STPPaymentConfiguration.shared().publishableKey = "pk_live_bG5YCdrDQk2Vjnu5w9CM8QL8"

        //pk_live_bG5YCdrDQk2Vjnu5w9CM8QL8
        //pk_test_tXhujH0kMSnIq0PRwu51AKXZ
        Fabric.with([Crashlytics.self])
        FIRApp.configure()
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        let ran = arc4random_uniform(UInt32(20))
        if(ran > 10){
            GMSPlacesClient.provideAPIKey("AIzaSyDj6ZM75_lhCTZfzqyzSQw_K_RpkWNoPas")
            GMSServices.provideAPIKey("AIzaSyDj6ZM75_lhCTZfzqyzSQw_K_RpkWNoPas")
        }else{
            GMSPlacesClient.provideAPIKey("AIzaSyBdspiEtkmjtqK6zVVkqIQ8NAjnnCJbfNo")
            GMSServices.provideAPIKey("AIzaSyBdspiEtkmjtqK6zVVkqIQ8NAjnnCJbfNo")
        }
        /*
        GMSPlacesClient.provideAPIKey("AIzaSyBdspiEtkmjtqK6zVVkqIQ8NAjnnCJbfNo")
        
        GMSServices.provideAPIKey("AIzaSyBdspiEtkmjtqK6zVVkqIQ8NAjnnCJbfNo")
        */
        PKImV3ImageFileManager.sharedInstance.checkAutoClearCastImageWith(TimeSec: 60 * 60 * 24 * 15) //60 * 60 * 24 * 2
        
        do {
            try FileManager.default.removeItem(at: Realm.Configuration.defaultConfiguration.fileURL!)
        } catch {}

        self.registerForPushNotifications(application: application)
        return true
    }

    
    
    func registerForPushNotifications(application: UIApplication) {
        
        /*
         UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
         
         if granted {
         UIApplication.shared.registerForRemoteNotifications()
         
         }
         
         
         // For iOS 10 data message (sent via FCM)
         FIRMessaging.messaging().remoteMessageDelegate = self
         
         }
         
         
         UNUserNotificationCenter.current().delegate = self
         */
        
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            
            // For iOS 10 data message (sent via FCM)
            FIRMessaging.messaging().remoteMessageDelegate = self
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        // [END register_for_notifications]
        if FIRApp.defaultApp() == nil {
            FIRApp.configure()
        }
        
        // [START add_token_refresh_observer]
        // Add observer for InstanceID token refresh callback.
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.tokenRefreshNotification),
                                               name: .firInstanceIDTokenRefresh,
                                               object: nil)
        // [END add_token_refresh_observer]
    }
    
    
    func tokenRefreshNotification(_ notification: Notification) {
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
        }
        
        // Connect to FCM since connection may have failed when attempted before having a token.
        connectToFcm()
    }
    // [END refresh_token]
    // [START connect_to_fcm]
    func connectToFcm() {
        // Won't connect since there is no token
        guard FIRInstanceID.instanceID().token() != nil else {
            return
        }
        print("FIRInstanceID.instanceID().token()")
        print("\(FIRInstanceID.instanceID().token()!)")
        
        ShareData.sharedInstance.saveDeviceToken(value: FIRInstanceID.instanceID().token()!)
        // Disconnect previous FCM connection if it exists.
        FIRMessaging.messaging().disconnect()
        
        FIRMessaging.messaging().connect { (error) in
            if error != nil {
                print("Unable to connect with FCM. \(String(describing: error))")
            } else {
                print("Connected to FCM.")
            }
        }
    }
   
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("didRegisterForRemoteNotificationsWithDeviceToken")
        print(token)
        //FIRMessaging.messaging().ap
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        PKImV3ImageFileManager.sharedInstance.saveImageListData()
        FIRMessaging.messaging().disconnect()
        print("Disconnected from FCM.")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        connectToFcm()
        
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        PKImV3ImageFileManager.sharedInstance.saveImageListData()
    }

    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled = (FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options) || GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: [:]))
        return handled
    }

}


extension AppDelegate: UNUserNotificationCenterDelegate, FIRMessagingDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(response.notification.request.content.userInfo)
        let tag = response.notification.request.content.userInfo["Tag"] as? NSInteger
        if let _ = tag{

        }
        completionHandler()
    }
    
    
    func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // Print message ID.
        //        if let messageID = userInfo[gcmMessageIDKey] {
        //            print("Message ID: \(messageID)")
        //        }
        
        // Print full message.
        print(userInfo)
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // Print message ID.
        //        if let messageID = userInfo[gcmMessageIDKey] {
        //            print("Message ID: \(messageID)")
        //        }
        
        // Print full message.
        print(userInfo)
        FIRMessaging.messaging().appDidReceiveMessage(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    
    
    
    
}




