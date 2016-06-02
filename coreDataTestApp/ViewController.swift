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

class ViewController: UIViewController, UITableViewDataSource {
    
//    let camera = Camera()
    var imageFromCamera = UIImage?()
    var numberOfCellForAvatar = 0
    var people = [NSManagedObject]()

    
    @IBOutlet weak var myTableView: UITableView!
    
    //MARK: - System Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        people = CoreData.fetchRequest("Person")
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.presentCameraController), name: "cellAvatarPressed", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.recevePhoto), name: "photoForAvatar", object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if imageFromCamera != nil {
            
        }
    }
    
    //MARK: - Supporting Methods
    func recevePhoto(notif: NSNotification) {
        imageFromCamera = notif.object as? UIImage
        
        //засунуть в person под номером numberOfCellForAvatar imageFromCamera
        var person = people[numberOfCellForAvatar]

        let nameOfPerson = person.valueForKey("name") as! String
        CoreData.deleteObject(people[numberOfCellForAvatar])
        person = CoreData.savePersonWithName(nameOfPerson, andAvatar: imageFromCamera)!

        people.removeAtIndex(numberOfCellForAvatar)
        people.append(person)

        myTableView.reloadData()
    }
    
    //MARK: - Controls

    
    //MARK: - Core Data Methods
    @IBAction func addItemInTable(sender: AnyObject) {
        let alert = UIAlertController(title: "New name", message: "Add a new name", preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .Default) { (action: UIAlertAction!) in
                                        
            let textField = alert.textFields![0]
            if let person = CoreData.savePersonWithName(textField.text!, andAvatar: nil) as NSManagedObject? {
                self.people.append(person)
            }
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
        
        cell.tag = indexPath.row

        let person = people[indexPath.row]
        cell.name.text = person.valueForKey("name") as? String
        cell.age.text = "\(person.valueForKey("age") as? String)"
        if person.valueForKey("avatar") as? NSData != nil {
            if let imageFromData = UIImage(data: (person.valueForKey("avatar") as? NSData)!, scale:1.0) {
                cell.photo.image = imageFromData
            }
        } else {
            cell.photo.image = UIImage(named: "a - \(indexPath.row)")
        }
        

        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            CoreData.deleteObject(people[indexPath.row])
            
            people.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    //MARK: - Segues
    func presentCameraController(notification: NSNotification)  {
        self.numberOfCellForAvatar = (notification.object as? Int)!
        let vc = storyboard?.instantiateViewControllerWithIdentifier("cameraVC")
        self.presentViewController(vc!, animated: true, completion: nil)
    }

}

