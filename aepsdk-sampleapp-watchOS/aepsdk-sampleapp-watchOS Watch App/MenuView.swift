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

struct MenuView: View {
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Core")) {
                    NavigationLink(destination: CoreView().navigationBarTitle("Core")) {
                        Text("Core")
                    }
                }.listRowBackground(Color.red)

                Section(header: Text("Edge")) {
                    NavigationLink(destination: EdgeView().navigationBarTitle("Edge")) {
                        Text("Edge")
                    }.listRowBackground(Color.red)

                    NavigationLink(destination: ConsentView().navigationBarTitle("Consent")) {
                        Text("Consent")
                    }.listRowBackground(Color.red)

                    NavigationLink(destination: EdgeIdentityView().navigationBarTitle("Edge Identity")) {
                        Text("Edge Identity")
                    }
                }.listRowBackground(Color.red)

                Section(header: Text("Validation")) {
                    NavigationLink(destination: AssuranceView().navigationBarTitle("Assurance")) {
                        Text("Assurance")
                    }
                }.listRowBackground(Color.red)

                Section(header: Text("Messaging")) {
                    NavigationLink(destination: MessagingView().navigationBarTitle("Messaging")) {
                        Text("Messaging")
                    }
                }.listRowBackground(Color.red)
            }.navigationBarTitle(Text("Extensions"))
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}

