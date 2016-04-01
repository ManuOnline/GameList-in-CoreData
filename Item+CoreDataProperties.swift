//
//  Item+CoreDataProperties.swift
//  DataModel
//
//  Created by Emanuele Cundari on 31/03/16.
//  Copyright © 2016 Emanuele Cundari. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Item {

    @NSManaged var created: NSDate?
    @NSManaged var details: String?
    @NSManaged var price: NSNumber?
    @NSManaged var title: String?
    @NSManaged var image: Image?
    @NSManaged var itemType: ItemType?
    @NSManaged var store: Store?

}
