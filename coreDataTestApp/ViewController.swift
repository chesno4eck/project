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

    var people = [NSManagedObject]()

    
    @IBOutlet weak var myTableView: UITableView!
    
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
    
    
    func recevePhoto(notif: NSNotification) {
        imageFromCamera = notif.object as? UIImage
    }
    
    //MARK: - Controls
//    @IBAction func startCam(sender: AnyObject) {
//        Camera.camera.startCamera(view)
//    }
//    
//    @IBAction func shoot(sender: AnyObject) {
//        Camera.camera.takePhoto(view)
//    }
    
    
    //MARK: - Core Data methods
    @IBAction func addItemInTable(sender: AnyObject) {
        let alert = UIAlertController(title: "New name", message: "Add a new name", preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .Default) { (action: UIAlertAction!) in
                                        
            let textField = alert.textFields![0]
            if let person = CoreData.savePersonWithName(textField.text!) as NSManagedObject? {
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
        
        let person = people[indexPath.row]
        cell.name.text = person.valueForKey("name") as? String
        cell.age.text = "\(person.valueForKey("age") as? String)"
        if imageFromCamera != nil {
            cell.photo.image = imageFromCamera!
        } else {
            cell.photo.image = UIImage(named: "a - \(indexPath.row)")
        }
        
        cell.tag = indexPath.row

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
    
    //MARK: - Segues
    
    func presentCameraController()  {
        let vc = storyboard?.instantiateViewControllerWithIdentifier("cameraVC")
        self.presentViewController(vc!, animated: true, completion: nil)
    }

}

