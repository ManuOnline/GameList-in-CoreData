//
//  Item.swift
//  DataModel
//
//  Created by Emanuele Cundari on 31/03/16.
//  Copyright © 2016 Emanuele Cundari. All rights reserved.
//

import UIKit
import CoreData


class Item: NSManagedObject {

    // Si setta la data di creazione non appena l'oggetto viene creato!
    override func awakeFromInsert() {
        super.awakeFromInsert()
        
        self.created = NSDate()
    }

}
