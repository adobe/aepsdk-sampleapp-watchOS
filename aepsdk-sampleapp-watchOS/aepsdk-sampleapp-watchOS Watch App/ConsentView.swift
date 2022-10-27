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
import AEPCore
import AEPEdgeConsent
import SwiftUI

struct ConsentView: View {
    @State var currentConsents = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Button("Set Collect Consent - Yes") {
                    let collectConsent = ["collect": ["val": "y"]]
                    let currentConsents = ["consents": collectConsent]
                    Consent.update(with: currentConsents)
                }.buttonStyle(CustomButtonStyle())
                
                Button("Set Collect Consent - No") {
                    let collectConsent = ["collect": ["val": "n"]]
                    let currentConsents = ["consents": collectConsent]
                    Consent.update(with: currentConsents)
                }.buttonStyle(CustomButtonStyle())
                
                Button("Set default collect consent = y") {
                    let defaultsConsents = ["collect": ["val": "y"]]
                    let defaultConsent = ["consent.default": ["consents": defaultsConsents]]
                    MobileCore.updateConfigurationWith(configDict: defaultConsent)
                }.buttonStyle(CustomButtonStyle())
                
                Button("Get Consents") {
                    Consent.getConsents { consents, error in
                        guard error == nil, let consents = consents else { return }
                        guard let jsonData = try? JSONSerialization.data(withJSONObject: consents, options: .prettyPrinted) else { return }
                        guard let jsonStr = String(data: jsonData, encoding: .utf8) else { return }
                        currentConsents = jsonStr
                    }
                }.buttonStyle(CustomButtonStyle())
                
                Text("Current Consents:")
                Text(currentConsents)
                    .fixedSize(horizontal: false, vertical: true)
            }.padding()
        }
    }
}

struct ConsentView_Previews: PreviewProvider {
    static var previews: some View {
        ConsentView()
    }
}

