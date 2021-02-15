//
//  Category.swift
//  TodoList
//
//  Created by Mauricio Zarate on 12/02/21.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var categoryName: String = ""
     var items = List<Item>()
}
