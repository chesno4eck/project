//
//  CoreData.swift
//  coreDataTestApp
//
//  Created by Дмитрий Алиев on 02/06/16.
//  Copyright © 2016 web.academmedia. All rights reserved.
//

import UIKit
import CoreData

class CoreData: NSObject {

    class func fetchRequest(entityName: String) -> [NSManagedObject] {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: entityName)
        
        do {
            let fetchedResults = try managedContext.executeFetchRequest(fetchRequest)  as? [NSManagedObject]
            if let results = fetchedResults {
                return results
            }
        } catch {
            print("Cant fetch \(error)")
        }
        return []
    }
    
    class func savePersonWithName(name: String) -> NSManagedObject? {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity =  NSEntityDescription.entityForName("Person", inManagedObjectContext: managedContext)
        let person = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        person.setValue(name, forKey: "name")
//        person.setValue("12", forKey: "age")
//        абвгдеёжзийклмнопрстуфхцчшщъыьэюя
//        яюэьыъщшчцхфутсрпонмлкйизжёедгвба
        do {
            try managedContext.save()
            return person
        } catch let error as NSError  {
            print("Cant save \(error)")
        }
        return nil
    }
    
    class func addPhotoToPerson() {
        
    }
    

}