//
//  Item.swift
//  ToDo
//
//  Created by Ekaterina Makaryeva on 09/04/2018.
//  Copyright © 2018 Ekaterina Makaryeva. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title = ""
    @objc dynamic var done = false
    @objc dynamic var dateOfCreation: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
