//
//  Category.swift
//  Todoey
//
//  Created by Felipe Chun on 10/15/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift
import ChameleonFramework

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = RandomFlatColor().hexValue()
    
    let items = List<Item>()
}
