//
//  Item.swift
//  Zen
//
//  Created by 池谷湧 on 2024/9/9.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
