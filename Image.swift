//
//  Image.swift
//  DataModel
//
//  Created by Emanuele Cundari on 31/03/16.
//  Copyright © 2016 Emanuele Cundari. All rights reserved.
//

import UIKit
import CoreData


class Image: NSManagedObject {

    func setItemImage(img: UIImage) {
        let data = UIImagePNGRepresentation(img)
        self.image = data
    }
    
    func getItemImage() -> UIImage {
        let img = UIImage(data: self.image!)!
        return img
    }

}
