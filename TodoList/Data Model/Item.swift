//
//  Data.swift
//  TodoList
//
//  Created by Mauricio Zarate on 10/02/21.
//

import Foundation
import RealmSwift

class Item: Object {
   @objc dynamic var title: String = ""
   @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated = Date()
    var parentCat = LinkingObjects(fromType: Category.self, property: "items")
    
}
