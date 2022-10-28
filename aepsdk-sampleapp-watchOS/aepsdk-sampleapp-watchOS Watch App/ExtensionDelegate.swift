/*
  Copyright 2022 Adobe. All rights reserved.
  This file is licensed to you under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License. You may obtain a copy
  of the License at http://www.apache.org/licenses/LICENSE-2.0
  Unless required by applicable law or agreed to in writing, software distributed under
  the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR REPRESENTATIONS
  OF ANY KIND, either express or implied. See the License for the specific language
  governing permissions and limitations under the License.
 */

import Foundation
import WatchKit
import UserNotifications

import AEPCore
import AEPEdge
import AEPIdentity
import AEPEdgeIdentity
import AEPMessaging
import AEPLifecycle
import AEPUserProfile
import AEPSignal
import AEPServices
import AEPEdgeConsent
import AEPAssurance

import UIKit
import CoreData

///// Entry point of the watch app.
class ExtensionDelegate: NSObject, WKExtensionDelegate {

    func applicationDidFinishLaunching() {
        let applicationId: String = ""
        let extensions = [Edge.self, Lifecycle.self, UserProfile.self, Consent.self, AEPIdentity.Identity.self, AEPEdgeIdentity.Identity.self, Assurance.self, UserProfile.self, Signal.self, Messaging.self]

        MobileCore.setLogLevel(.trace)
        MobileCore.registerExtensions(extensions, {
            MobileCore.configureWith(appId: applicationId)
            MobileCore.updateConfigurationWith(configDict: ["messaging.useSandbox": true])
            MobileCore.lifecycleStart(additionalContextData: ["contextDataKey": "contextDataVal"])
        })
        setupRemoteNotifications()
    }

    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }
    
    func applicationWillEnterForeground() {
        MobileCore.lifecycleStart(additionalContextData: nil)
    }
    
    func applicationDidEnterBackground() {
        MobileCore.lifecyclePause()
    }

    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        // Sent when the system needs to launch the application in the background to process tasks. Tasks arrive in a set, so loop through and process each one.
        for task in backgroundTasks {
            // Use a switch statement to check the task type
            switch task {
            case let backgroundTask as WKApplicationRefreshBackgroundTask:
                // Be sure to complete the background task once you’re done.
                backgroundTask.setTaskCompletedWithSnapshot(false)
            case let snapshotTask as WKSnapshotRefreshBackgroundTask:
                // Snapshot tasks have a unique completion call, make sure to set your expiration date
                snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: Date.distantFuture, userInfo: nil)
            case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
                // Be sure to complete the connectivity task once you’re done.
                connectivityTask.setTaskCompletedWithSnapshot(false)
            case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
                // Be sure to complete the URL session task once you’re done.
                urlSessionTask.setTaskCompletedWithSnapshot(false)
            case let relevantShortcutTask as WKRelevantShortcutRefreshBackgroundTask:
                // Be sure to complete the relevant-shortcut task once you're done.
                relevantShortcutTask.setTaskCompletedWithSnapshot(false)
            case let intentDidRunTask as WKIntentDidRunRefreshBackgroundTask:
                // Be sure to complete the intent-did-run task once you're done.
                intentDidRunTask.setTaskCompletedWithSnapshot(false)
            default:
                // make sure to complete unhandled task types
                task.setTaskCompletedWithSnapshot(false)
            }
        }
    }
}

// MARK:  - Notification Methods
extension ExtensionDelegate: UNUserNotificationCenterDelegate {

    func setupRemoteNotifications() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in

            if granted {
                DispatchQueue.main.async {
                    WKExtension.shared().registerForRemoteNotifications()
                }
            }
        }
    }

    func didRegisterForRemoteNotifications(withDeviceToken deviceToken: Data) {
        // Convert token to string
        let deviceTokenString = deviceToken.map { data in String(format: "%02.2hhx", data) }.joined()

        print("Device Token: \(deviceTokenString)")

        // Send push token to experience platform
        MobileCore.setPushIdentifier(deviceToken)
    }

    //Receive Notifications while app is in background
    func didReceiveRemoteNotification(_ userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (WKBackgroundFetchResult) -> Void) {

        if let apsPayload = userInfo as? [String: Any] {
            NotificationCenter.default.post(name: Notification.Name("TEST NAME"), object: self, userInfo: apsPayload)
        }
        completionHandler(WKBackgroundFetchResult.newData)
    }

    // MARK: - Handle Push Notification Interactions
    // Receiving Notifications
    // Delegate method to handle a notification that arrived while the app was running in the foreground.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        let userInfo = notification.request.content.userInfo
        if let apsPayload = userInfo as? [String: Any] {
            NotificationCenter.default.post(name: Notification.Name("T"), object: self, userInfo: apsPayload)
        }
        completionHandler([.banner, .badge, .sound])
    }

    // Handling the Selection of Custom Actions
    // Delegate method to process the user's response to a delivered notification.
    func userNotificationCenter(_: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void) {
        // Perform the task associated with the action
        switch response.actionIdentifier {
        case "ACCEPT_ACTION":
            Messaging.handleNotificationResponse(response, applicationOpened: true, customActionId: "ACCEPT_ACTION")

        case "DECLINE_ACTION":
            Messaging.handleNotificationResponse(response, applicationOpened: false, customActionId: "DECLINE_ACTION")

        // Handle other actions…
        default:
            Messaging.handleNotificationResponse(response, applicationOpened: true, customActionId: nil)
        }
        // Always call the completion handler when done.
        completionHandler()
    }
}

