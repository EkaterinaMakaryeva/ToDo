//
//  Category.swift
//  ToDo
//
//  Created by Ekaterina Makaryeva on 09/04/2018.
//  Copyright © 2018 Ekaterina Makaryeva. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name = ""
    var items = List<Item>()
}
