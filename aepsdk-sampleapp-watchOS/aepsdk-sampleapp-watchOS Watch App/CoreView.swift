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

import UIKit
import SwiftUI

import AEPCore
import AEPIdentity
import AEPUserProfile

struct CoreView: View {
    @State private var eventQueueLength: String = ""
    @State private var minBatchSize: String = ""
    @State private var trackingIdentifier: String = ""
    @State private var visitorIdentifier: String = ""
    @State private var batchQueueLimit: String = ""
    @State private var selectedOptInIndex = 0
    @State private var currentPrivacyStatus: String = ""
    @State private var showingAlert = false
    @State private var retrievedAttributes: String = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                privacySection
                piiSection
                manualOverridesSection
                eventsSection
                identitySection
                profileSection
            }.padding()
        }
    }
    var profileSection: some View {
        
        VStack(alignment: .leading, spacing: 12) {
            Text("User Profile").bold()
            Button(action: {
                UserProfile.updateUserAttributes(attributeDict: ["user_name":"Will Smith"])
            }){
                Text("Update Attributes")
            }.buttonStyle(CustomButtonStyle())
            Button(action: {
                UserProfile.getUserAttributes(attributeNames: ["user_name"]){
                    attributes, error in
                        self.showingAlert = true
                        self.retrievedAttributes = String(describing: attributes)
                }
            }){
                Text("Retrieve Attributes")
            }.buttonStyle(CustomButtonStyle())
            .alert(isPresented: $showingAlert){
                Alert(title: Text("Profile"),message: Text(self.retrievedAttributes),dismissButton: .default(Text("Got it!")))
            }
            Button(action: {
                UserProfile.removeUserAttributes(attributeNames: ["user_name"])
            }){
                Text("Remove Attributes")
            }.buttonStyle(CustomButtonStyle())
        }
    }

    var privacySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Change Privacy Status").font(.caption).bold()
            Button(action: {
                MobileCore.setPrivacyStatus(.optedIn)
            }) {
                Text("Opted In")
            }.buttonStyle(CustomButtonStyle())
            
            Button(action: {
                MobileCore.setPrivacyStatus(.optedOut)
            }) {
                Text("Opted Out")
            }.buttonStyle(CustomButtonStyle())
            
            Button(action: {
                MobileCore.setPrivacyStatus(.unknown)
            }) {
                Text("Unknown")
            }.buttonStyle(CustomButtonStyle())
            
            VStack {
                Button(action: {
                    MobileCore.getPrivacyStatus { privacyStatus in
                        self.currentPrivacyStatus = "\(privacyStatus.rawValue)"
                    }
                }) {
                    Text("Get Privacy")
                }.buttonStyle(CustomButtonStyle())
                VStack{
                    Text("Current Privacy:")
                    Text(currentPrivacyStatus)
                }
            }
        }
    }
    
    var piiSection: some View {
        
        VStack(alignment: .leading, spacing: 12) {
            Text("Collect PII").bold()
            Button(action: {
                MobileCore.collectPii(["name":"Adobe Experience Platform"])
            }){
                Text("Collect PII")
            }.buttonStyle(CustomButtonStyle())
        }
    }
    
    
    var manualOverridesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Update Configuration").bold()
            Button(action: {
                let dataDict = ["analytics.batchLimit": 3]
                MobileCore.updateConfigurationWith(configDict: dataDict)
            }) {
                Text("Update Configuration")
            }.buttonStyle(CustomButtonStyle())
        }
    }
    
    var eventsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Dispatch Events").bold()
            Button(action: {
                let event = Event(name: "Sample Event", type: "type", source: "source", data: ["platform" : "ios"])
                MobileCore.dispatch(event: event)
            }) {
                Text("Dispatch Custom Event")
            }.buttonStyle(CustomButtonStyle())
            
            Button(action: {
                let event = Event(name: "Sample Event", type: "type", source: "source", data: ["platform" : "ios"])
                MobileCore.dispatch(event: event) { event in
                    
                }
            }) {
                Text("Dispatch Custom Event with response callback")
            }.buttonStyle(CustomButtonStyle())
        }
    }
    
    var identitySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Identity APIs").bold()
            Button(action: {
                MobileCore.setAdvertisingIdentifier("advertisingIdentifier")
            }) {
                Text("Set Advertising Identifier")
            }.buttonStyle(CustomButtonStyle())
            
            Button(action: {
                MobileCore.setPushIdentifier("9516258b6230afdd93cf0cd07b8dd845".data(using: .utf8))
            }) {
                Text("Set Push Identifier")
            }.buttonStyle(CustomButtonStyle())
            
            Button(action: {
                Identity.syncIdentifiers(identifiers: ["idType1":"1234567"], authenticationState: .authenticated)
            }) {
                Text("Sync Identifiers")
            }.buttonStyle(CustomButtonStyle())
            
            Button(action: {
                Identity.getExperienceCloudId { ecid, error in
                    print(ecid ?? "")
                }
            }) {
                Text("Get ExperienceCloudId")
            }.buttonStyle(CustomButtonStyle())
            
            
            Button(action: {
                MobileCore.getSdkIdentities { identities, _ in
                    print(identities ?? "")
                }
            }) {
                Text("Get Sdk Identities")
            }.buttonStyle(CustomButtonStyle())
            
            Button(action: {
                Identity.getUrlVariables { variables, error in
                    print(variables ?? "")
                }
            }) {
                Text("Get Url Variables")
            }.buttonStyle(CustomButtonStyle())
            
            Button(action: {
                Identity.appendTo(url: URL(string: "https://example.com")) { url, _ in
                }
            }) {
                Text("Append Url")
            }.buttonStyle(CustomButtonStyle())
        }
    }
}

struct CoreViewController_Previews: PreviewProvider {
    static var previews: some View {
        CoreView()
    }
}
