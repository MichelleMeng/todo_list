//
//  TodoModel+CoreDataProperties.swift
//  Todo
//
//  Created by MichelleMeng on 16/11/17.
//  Copyright © 2016年 MichelleMeng. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension TodoModel {

    @NSManaged var date: NSDate?
    @NSManaged var id: String?
    @NSManaged var image: String?
    @NSManaged var title: String?

}
