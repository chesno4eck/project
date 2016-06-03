//
//  CompaniesViewController.swift
//  coreDataTestApp
//
//  Created by Дмитрий Алиев on 03/06/16.
//  Copyright © 2016 web.academmedia. All rights reserved.
//

import UIKit
import CoreData

var companies = [NSManagedObject]()

class CompaniesViewController: UITableViewController {


    override func viewDidLoad() {
        super.viewDidLoad()

        companies = CoreData.fetchRequest("Company")

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - Core Data Methods
    @IBAction func addItemInTable(sender: AnyObject) {
        let alert = UIAlertController(title: "New Company", message: "Add a new Company name", preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .Default) { (action: UIAlertAction!) in
            
            let textField = alert.textFields![0]
            if let company = CoreData.saveCompanyWithName(textField.text!, andDirectora: people[0]) as NSManagedObject? {
                companies.append(company)
            }
            self.tableView.reloadData()
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

    
    // MARK: - Table view data source
//
//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 1
//    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cellCompanies", forIndexPath: indexPath)
        let company = companies[indexPath.row]
        
        cell.textLabel?.text = company.valueForKey("name") as? String
        cell.detailTextLabel?.text = company.valueForKey("director")?.valueForKey("name") as? String
        
        return cell
    }
 

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            CoreData.deleteObject(companies[indexPath.row])
            
            companies.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }


    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let vc = storyboard?.instantiateViewControllerWithIdentifier("pickerDirectorController")
        self.presentViewController(vc!, animated: true, completion: nil)
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
