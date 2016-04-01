//
//  Image+CoreDataProperties.swift
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

extension Image {

    @NSManaged var image: NSData?
    @NSManaged var item: Item?
    @NSManaged var store: Store?

}
