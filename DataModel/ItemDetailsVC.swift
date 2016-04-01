//
//  ItemDetailsVC.swift
//  DataModel
//
//  Created by Emanuele Cundari on 27/03/16.
//  Copyright © 2016 Emanuele Cundari. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var titleField: CustomTextField!
    @IBOutlet weak var priceField: CustomTextField!
    @IBOutlet weak var detailsField: CustomTextField!
    @IBOutlet weak var itemImg: UIImageView!
    
    
    var stores = [Store]()
    var itemToEdit: Item? // perchè non è detto che ci siano items
    
    var imagePicker: UIImagePickerController!

    override func viewDidLoad() {
        super.viewDidLoad()

        storePicker.delegate = self
        storePicker.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        //createStore()
        
        getStores()
        
        if itemToEdit != nil {
            loadItemData()
        }
        
    }
    
    
    func createStore() {
        let store1 = NSEntityDescription.insertNewObjectForEntityForName("Store", inManagedObjectContext: ad.managedObjectContext) as! Store
        store1.name = "Amazon"
        
        let store2 = NSEntityDescription.insertNewObjectForEntityForName("Store", inManagedObjectContext: ad.managedObjectContext) as! Store
        store2.name = "Walmart"
        
        let store3 = NSEntityDescription.insertNewObjectForEntityForName("Store", inManagedObjectContext: ad.managedObjectContext) as! Store
        store3.name = "Scary Goth Club"
        
        let store4 = NSEntityDescription.insertNewObjectForEntityForName("Store", inManagedObjectContext: ad.managedObjectContext) as! Store
        store4.name = "Best Buy"
        
        let store5 = NSEntityDescription.insertNewObjectForEntityForName("Store", inManagedObjectContext: ad.managedObjectContext) as! Store
        store5.name = "Steve's Fish & Chips"
        
        let store6 = NSEntityDescription.insertNewObjectForEntityForName("Store", inManagedObjectContext: ad.managedObjectContext) as! Store
        store6.name = "Aussie Panel Beater"
        
        ad.saveContext()
    }
    
    func loadItemData() {
        if let item = itemToEdit {
            
            if let title = item.title { // TO AVOID CRUSHES! and the values will not be optionals ;)
                titleField.text = title
            }
            
            if let price = item.price {
                priceField.text = "\(price)"
            }
            
            if let details = item.details {
                detailsField.text = details
            }
            
            
            
            if let store = item.store {
                var index = 0
                repeat {
                    
                    let s = stores[index]
                    
                    if s.name == store.name {
                        storePicker.selectRow(index, inComponent: 0, animated: false)
                        break
                    }
                    index += 1
                    
                } while (index < stores.count)
            }
            
            if let image = item.image?.getItemImage() {
                itemImg.image = image
            }
        }
    }
    
    func getStores() {
        let fetchRequest = NSFetchRequest(entityName: "Store")
        
        do {
            self.stores = try ad.managedObjectContext.executeFetchRequest(fetchRequest) as! [Store]
            self.storePicker.reloadAllComponents()
        } catch {
            // handle errors
        }
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stores.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let store = stores[row]
        return store.name
    }
    
    @IBAction func savePressed(sender: UIButton) {
        
        // assicurarsi che i dati inseriti siano corretti, diversi da "", ecc, poi...
        if titleField.text! != "" && priceField.text! != "" {
            
            var item: Item!
            var image: Image!
            
            if itemToEdit == nil {
                item = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: ad.managedObjectContext) as! Item
                image = NSEntityDescription.insertNewObjectForEntityForName("Image", inManagedObjectContext: ad.managedObjectContext) as! Image
                item.image = image
            } else {
                item = itemToEdit
            }
            
            if let title = titleField.text {
                item.title = title
            }
            
            if let price = priceField.text {
                let priceStr = NSString(string: price)
                let priceDbl = priceStr.doubleValue
                item.price = NSNumber(double: priceDbl)
            }
            
            if let details = detailsField.text {
                item.details = details
            }
            
            if let descImage = itemImg.image {
                item.image?.setItemImage(descImage)
            }
            
            
            item.store = stores[storePicker.selectedRowInComponent(0)]
            
            ad.saveContext()
            self.navigationController?.popViewControllerAnimated(true)
            
        } else {
            
            let alertEmptyField = UIAlertController(title: "Attention", message: "One or more fields are empty", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "Ok", style: .Destructive, handler: { (ok) in
                self.titleField.becomeFirstResponder()
            })
            alertEmptyField.addAction(okAction)
            self.presentViewController(alertEmptyField, animated: true, completion: nil)
        
        }
    }
    
    
    @IBAction func deletePressed(sender: UIBarButtonItem) {
        if itemToEdit != nil {
            ad.managedObjectContext.deleteObject(itemToEdit!)
            ad.saveContext()
        }
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    @IBAction func addStorePressed(sender: UIButton) {
        let addStoreController = UIAlertController(title: "Add store", message: "Write here the name of the store", preferredStyle: .Alert)
        addStoreController.addTextFieldWithConfigurationHandler { (storeName) in
            storeName.placeholder = "Name of the Store"
        }
        let storeName = addStoreController.textFields![0] as UITextField
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Destructive) { (cancel) in
            //cancel
        }
        let saveAction = UIAlertAction(title: "Save", style: .Default) { (save) in
            if storeName.text! != "" {
                let newStore = NSEntityDescription.insertNewObjectForEntityForName("Store", inManagedObjectContext: ad.managedObjectContext) as! Store
                newStore.name = storeName.text!
                ad.saveContext()
                self.getStores()
            } else {
                let alertEmptyController = UIAlertController(title: "Error", message: "The field must not be empty", preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "Ok", style: .Default, handler: { (ok) in
                    self.presentViewController(addStoreController, animated: true, completion: nil)
                    storeName.becomeFirstResponder()
                })
                alertEmptyController.addAction(okAction)
                self.presentViewController(alertEmptyController, animated: true, completion: nil)
            }
        }
        addStoreController.addAction(saveAction)
        addStoreController.addAction(cancelAction)
        self.presentViewController(addStoreController, animated: true, completion: nil)
    }
    
    @IBAction func setItemImage(sender: UIButton) {
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        itemImg.image = image
    }
    

}



















