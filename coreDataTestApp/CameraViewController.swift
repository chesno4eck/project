//
//  ViewControllerCompany.swift
//  coreDataTestApp
//
//  Created by Дмитрий Алиев on 25/05/16.
//  Copyright © 2016 web.academmedia. All rights reserved.
//

import UIKit
import CoreData

class CameraViewController: UIViewController {
    
    @IBOutlet weak var viewForCameraLayer: UIView!
        
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Camera.camera.startCamera(viewForCameraLayer)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func shoot(sender: AnyObject) {
        
        let takenPhoto = Camera.camera.takePhoto(viewForCameraLayer)
        
        NSNotificationCenter.defaultCenter().postNotificationName("photoForAvatar", object: takenPhoto )
        
        self.dismissViewControllerAnimated(true) {
        }
    }
}

