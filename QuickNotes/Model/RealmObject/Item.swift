//
//  Item.swift
//  QuickNotes
//
//  Created by Ratnesh Kumar on 13/06/19.
//  Copyright © 2019 Anand Gupta. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object{
    @objc dynamic var title = ""
    @objc dynamic var done :Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
