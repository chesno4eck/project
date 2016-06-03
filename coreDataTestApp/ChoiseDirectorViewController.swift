//
//  ChoiseDirectorViewController.swift
//  coreDataTestApp
//
//  Created by Дмитрий Алиев on 03/06/16.
//  Copyright © 2016 web.academmedia. All rights reserved.
//

import UIKit

class ChoiseDirectorViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    
    var pickerDataSource = ["name"];

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerDataSource.removeAll()
        for i in 0...people.count-1 {
            pickerDataSource.append(people[i].valueForKey("name") as! String)
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataSource[row]
    }

    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        
        let willDirector = people[row]
        
        //WARNING: 0
        var currentCompany = companies[0]
        let currentCompanyName = currentCompany.valueForKey("name")!
        
        //WARNING: 0

        CoreData.deleteObject(companies[0])
        currentCompany = CoreData.saveCompanyWithName(currentCompanyName as! String, andDirectora: willDirector)!
        
        //WARNING: 0
        companies.removeAtIndex(0)
        companies.append(currentCompany)
    }
    
    @IBAction func done(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) {
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
