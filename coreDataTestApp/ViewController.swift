//
//  ViewController.swift
//  coreDataTestApp
//
//  Created by Дмитрий Алиев on 23/05/16.
//  Copyright © 2016 web.academmedia. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var myTableView: UITableView!
    
    var people = [NSManagedObject]()
    
    @IBAction func add(sender: AnyObject) {
        let alert = UIAlertController(title: "New name",
                                      message: "Add a new name",
                                      preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .Default) { (action: UIAlertAction!) -> Void in
                                        
                                        let textField = alert.textFields![0]
                                        self.saveName(textField.text!)
                                        self.myTableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .Default) { (action: UIAlertAction!) -> Void in
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField!) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert,
                              animated: true,
                              completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //1
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName:"Person")
        
        //3
        do {
            let fetchedResults = try managedContext.executeFetchRequest(fetchRequest)  as? [NSManagedObject]
            if let results = fetchedResults {
                people = results
            } else {
            }
        } catch {
            
        }

    }
    
    func saveName(name: String) {
        //1
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        //2
        let entity =  NSEntityDescription.entityForName("Person", inManagedObjectContext:managedContext)
        
        let person = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        //3
        person.setValue(name, forKey: "name")
        person.setValue("12", forKey: "age")
        //4
        do {
            try managedContext.save()
            people.append(person)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "\"CoreData test app\""
    }

    func tableView(tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(tableView: UITableView,
                   cellForRowAtIndexPath
        indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! TableViewCell
        
        let person = people[indexPath.row]
        cell.name.text = person.valueForKey("name") as? String
        cell.age.text = "\(person.valueForKey("age") as? String)"
        cell.photo.image = UIImage(named: "a - \(indexPath.row)")
//
//        if person.valueForKey("photo") as? UIImage != nil {
//            cell.imageView!.image = person.valueForKey("photo") as? UIImage
//        }

        return cell
    }

    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            let managedContext = appDelegate.managedObjectContext

            managedContext.deleteObject(people[indexPath.row])
            appDelegate.saveContext()

            people.removeAtIndex(indexPath.row)
//            tableView.reloadData()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

