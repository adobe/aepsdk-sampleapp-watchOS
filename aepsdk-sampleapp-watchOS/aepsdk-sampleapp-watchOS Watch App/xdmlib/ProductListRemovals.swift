/*
  Copyright 2022 Adobe. All rights reserved.
  This file is licensed to you under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License. You may obtain a copy
  of the License at http://www.apache.org/licenses/LICENSE-2.0
  Unless required by applicable law or agreed to in writing, software distributed under
  the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR REPRESENTATIONS
  OF ANY KIND, either express or implied. See the License for the specific language
  governing permissions and limitations under the License.

----
 XDM Property Swift Object Generated 2020-07-17 14:52:38.217972 -0700 PDT m=+2.051410268 by XDMTool

 Title            :    ProductListRemovals
 Description    :    Removal or removals of a product entry from a product list, for example a product is removed from a shopping cart.
----
*/

import Foundation


public struct ProductListRemovals {
    public init() {}

    public var id: String?
    public var value: Double?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case value = "value"
    }
}

extension ProductListRemovals:Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if let unwrapped = id { try container.encode(unwrapped, forKey: .id) }
        if let unwrapped = value { try container.encode(unwrapped, forKey: .value) }
    }
}

