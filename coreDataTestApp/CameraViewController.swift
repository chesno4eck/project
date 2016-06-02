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
    
    let cameraManager = CameraManager()

    @IBOutlet weak var viewForCameraLayer: UIView!
        
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraManager.addPreviewLayerToView(viewForCameraLayer)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func shoot(sender: AnyObject) {
        
        cameraManager.capturePictureWithCompletition({ (image, error) -> Void in
            NSNotificationCenter.defaultCenter().postNotificationName("photoForAvatar", object: image )
        })
        
        self.dismissViewControllerAnimated(true) {
        }
    }
}

