//
//  CartList.swift
//  MeaningOutApp
//
//  Created by 장예지 on 6/15/24.
//

import UIKit
import SwiftyUserDefaults

struct CartList: Codable, DefaultsSerializable {
    let name: String
    let productId: String
}
