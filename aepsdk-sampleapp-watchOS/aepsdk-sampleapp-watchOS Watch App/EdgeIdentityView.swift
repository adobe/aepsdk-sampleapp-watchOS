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


import AEPCore
import AEPEdgeIdentity
import Foundation
import SwiftUI
import WatchKit

struct EdgeIdentityView: View {
    @State var currentEcid = ""
    @State var currentIdentityMap: IdentityMap?
    @State var adID: UUID?
    @State var adIdText: String = ""
    @State var trackingAuthorizationResultText: String = ""
    @State var urlVariablesText: String = ""


    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("Current ECID:")
                Button(action: {
                    Identity.getExperienceCloudId { ecid, error in
                        currentEcid = ecid ?? ""
                    } }) {

                    Text("Get ExperienceCloudId").font(.system(size: 12))
                }.buttonStyle(CustomButtonStyle())

                Text(currentEcid)
                    .lineLimit(2)
                    .minimumScaleFactor(0.5)

                Text("Current Identities:")
                Button(action: {
                    Identity.getIdentities { identityMap, error in
                        currentIdentityMap = identityMap
                    }

                }) {
                    Text("Get Identities")
                }.buttonStyle(CustomButtonStyle())

                Text(currentIdentityMap?.jsonString ?? "")
                    .fixedSize(horizontal: false, vertical: true)

                Button(action: {
                    let updatedIdentities = IdentityMap()
                    updatedIdentities.add(item: IdentityItem(id: "test-id"), withNamespace: "test-namespace")
                    Identity.updateIdentities(with: updatedIdentities)
                }) {
                    Text("Update Identities with test-namespace").font(.system(size: 12))
                }.buttonStyle(CustomButtonStyle())

                Button(action: {
                    Identity.removeIdentity(item: IdentityItem(id: "test-id"), withNamespace: "test-namespace")
                }) {
                    Text("Remove Identities with test-namespace").font(.system(size: 12))
                }.buttonStyle(CustomButtonStyle())
                }

                VStack(alignment: .leading, spacing: 12) {

                    Text("Get URLVariables:")
                    Button(action: {
                        self.urlVariablesText = ""

                        AEPEdgeIdentity.Identity.getUrlVariables { urlVariablesString, _ in
                            self.urlVariablesText = urlVariablesString ?? "URLVariables not generated"
                        }

                    }) {
                        Text("Get URLVariables")
                    }.buttonStyle(CustomButtonStyle())
                    Text(urlVariablesText)
                }
            }.padding()
        }
    }

struct EdgeIdentityView_Previews: PreviewProvider {
    static var previews: some View {
        EdgeIdentityView()
    }
}

extension IdentityMap {
    var jsonString: String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        guard let data = try? encoder.encode(self) else { return nil }

        return String(data: data, encoding: .utf8)
    }
}

