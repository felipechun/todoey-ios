//
//  Item.swift
//  Todoey
//
//  Created by Felipe Chun on 10/15/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift
import ChameleonFramework

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    @objc dynamic var color: String = RandomFlatColor().hexValue()
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
