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

import SwiftUI
import UserNotifications

import AEPCore
import AEPEdgeIdentity
import AEPMessaging
import AEPServices


struct MessagingView: View {
    @State var currentEcid: String = ""
    @State private var ecidState: String = ""
    @State var currentIdentityMap: IdentityMap?

    let LOG_PREFIX = "MessagingViewController"

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
            }.padding().onAppear() {
                MobileCore.track(state: "Messaging", data: nil)
            }


            VStack(alignment: .leading, spacing: 12) {
                Text("Current ECID:")
                Button(action: {
                    print("This is called")
                    print(currentEcid)
                    Identity.getExperienceCloudId { ecid, error in
                        currentEcid = ecid ?? "Error"
                    } }) {

                    Text("Get ExperienceCloudId")
                }.buttonStyle(CustomButtonStyle())
                Text(currentEcid)
                    .lineLimit(2)
                    .minimumScaleFactor(0.5)


                VStack(alignment: .leading, spacing: 12) {
                    Text("Push Messaging")
                    Text("Messaging SDK setup is complete with ECID:")
                    Text(currentEcid)
                        .lineLimit(2)
                        .minimumScaleFactor(0.5)

                    Spacer(minLength: 15)
                    Text("Click a button below to schedule a notification:")
                    Text("(clicking on a notification demonstrates how to handle a notification response)").italic().minimumScaleFactor(0.6)
                    Button("Sample notification") {
                        scheduleNotification()
                    }.buttonStyle(CustomButtonStyle())
                }
                VStack(alignment: .leading, spacing: 12) {
                    Text("In-App Messaging (beta)")
                    Text("Click a button below to trigger an in-app message:")
                    Button("Sample fullscreen message") {
                        MobileCore.track(action: "sampleAppFullscreen", data: nil)
                    }.buttonStyle(CustomButtonStyle())
                    Button("Sample modal message") {
                        MobileCore.track(action: "sampleAppModal", data: nil)
                    }.buttonStyle(CustomButtonStyle())
                    Button("Sample top banner") {
                        MobileCore.track(action: "sampleAppBannerTop", data: nil)
                    }.buttonStyle(CustomButtonStyle())
                    Button("Sample bottom banner") {
                        MobileCore.track(action: "sampleAppBannerBottom", data: nil)
                    }.buttonStyle(CustomButtonStyle())
                    Spacer()
                }
            }
        }
    }
}


// MARK: - Creation of local notifications for demonstrating notification click-throughs

func scheduleNotification() {
    let content = UNMutableNotificationContent()
    content.title = "Simple notification"
    content.body = "This notification does not have any custom actions."
    content.sound = UNNotificationSound.default

    /// the structure of `userInfo` is the same as you'd see with an actual push message.
    /// the values are made up for demonstration purposes.
    content.userInfo = [
        "_xdm": [
            "cjm": [
                "_experience": [
                    "customerJourneyManagement": [
                        "messageExecution": [
                            "messageExecutionID": "00000000-0000-0000-0000-000000000000",
                            "messageID": "message-1",
                            "journeyVersionID": "someJourneyVersionId",
                            "journeyVersionInstanceId": "someJourneyVersionInstanceId"
                        ]
                    ]
                ]
            ]
        ]
    ]

    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
    let identifier = "Simple local notification identifier"
    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
    let notificationCenter = UNUserNotificationCenter.current()
    notificationCenter.removeAllPendingNotificationRequests()
    notificationCenter.add(request, withCompletionHandler: handleNotificationError(_:))
}


func handleNotificationError(_ error: Error?) {
    if let error = error {
        print("An error occurred when adding a notification: \(error.localizedDescription)")
    }
}

struct MessaginView_Previews: PreviewProvider {
    static var previews: some View {
        MessagingView()
    }
}

