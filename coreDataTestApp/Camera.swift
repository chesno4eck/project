//
//  Camera.swift
//  coreDataTestApp
//
//  Created by Дмитрий Алиев on 01/06/16.
//  Copyright © 2016 web.academmedia. All rights reserved.
//

import UIKit
import AVFoundation

class Camera: NSObject {
    
    static var camera = Camera()
    
    var session: AVCaptureSession?
    var device: AVCaptureDevice?
    var input: AVCaptureDeviceInput?
    var output: AVCaptureStillImageOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    func startCamera(view: UIView) {
        session = AVCaptureSession()
        session!.sessionPreset = AVCaptureSessionPresetPhoto
        
        device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        do {
            try input = AVCaptureDeviceInput(device: device)
        } catch {
            print("AVCaptureDeviceInput Error: \(error)")
            return
        }
        
        output = AVCaptureStillImageOutput()
        output!.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        
        guard session!.canAddInput(input) && session!.canAddOutput(output) else {
            return
        }
        session!.addInput(input)
        session!.addOutput(output)
        
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
        previewLayer!.frame = view.bounds
        previewLayer!.connection?.videoOrientation = .Portrait
        
        view.layer.addSublayer(previewLayer!)
        
        session!.startRunning()
    }
    
    func stopCamera(view: UIView) {
        session!.stopRunning()
        previewLayer = nil
    }

    
    func takePhoto(view: UIView) -> UIImage {
        UIGraphicsBeginImageContext(view.frame.size)
        let takenPhoto = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return takenPhoto
    }
    
}
