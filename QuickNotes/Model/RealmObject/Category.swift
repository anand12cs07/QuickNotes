//
//  Category.swift
//  QuickNotes
//
//  Created by Ratnesh Kumar on 13/06/19.
//  Copyright © 2019 Anand Gupta. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var title = ""
    @objc dynamic var color = "a6a6a6"
    let items = List<Item>()
}
