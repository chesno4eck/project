//
//  ViewController.swift
//  coreDataTestApp
//
//  Created by Дмитрий Алиев on 23/05/16.
//  Copyright © 2016 web.academmedia. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

var people = [NSManagedObject]()


class ViewController: UIViewController, UITableViewDataSource {
    
    let camera = Camera()

    
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchRequest()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: - Core Data methods
    func fetchRequest() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName:"Person")
        
        do {
            let fetchedResults = try managedContext.executeFetchRequest(fetchRequest)  as? [NSManagedObject]
            if let results = fetchedResults {
                people = results
            }
        } catch {
            print("Cant fetch \(error)")
        }
    }
    
    func saveInCoreData(name: String) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity =  NSEntityDescription.entityForName("Person", inManagedObjectContext:managedContext)
        let person = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        person.setValue(name, forKey: "name")
        person.setValue("12", forKey: "age")
        
        do {
            try managedContext.save()
            people.append(person)
        } catch let error as NSError  {
            print("Cant save \(error)")
        }
    }


    @IBAction func addItemInTable(sender: AnyObject) {
        let alert = UIAlertController(title: "New name", message: "Add a new name", preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .Default) { (action: UIAlertAction!) in
                                        
                                        let textField = alert.textFields![0]
                                        self.saveInCoreData(textField.text!)
                                        self.myTableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action: UIAlertAction!) in
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField!) in
        }
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    //MARK: - Table View
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath
        indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! TableViewCell
        
        let person = people[indexPath.row]
        cell.name.text = person.valueForKey("name") as? String
        cell.age.text = "\(person.valueForKey("age") as? String)"
        cell.photo.image = UIImage(named: "a - \(indexPath.row)")

        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext

            managedContext.deleteObject(people[indexPath.row])
            appDelegate.saveContext()

            people.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    @IBAction func startCam(sender: AnyObject) {
        camera.startCamera(view)
    }
    
       
    @IBAction func shoot(sender: AnyObject) {
        camera.takePhoto(view)
    }
    



}

