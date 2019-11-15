//
//  FirstViewController.swift
//  Find Your Parking
//
//  Created by Student on 10/4/19.
//  Copyright © 2019 Bearcat Coders. All rights reserved.
//
/*
import UIKit
import AVFoundation

class QRReaderViewController: UIViewController {

    var session = AVCaptureSession()
    var frontCamera: AVCaptureDevice?
    var backCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    var photoOutput: AVCapturePhotoOutput?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCaputerSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        startRunningCaputerSession()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.tabBarItem.title = "QR Scanner"
        tabBarItem.image = UIImage(named: "QR")
        
    }
    
    @IBAction func cameraButton(_ sender: Any) {
        performSegue(withIdentifier: "Photo", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupCaputerSession(){
        session.sessionPreset = AVCaptureSession.Preset.photo
    }
    
    func setupDevice(){
        let device = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        
        let devices = device.devices
        for usingDevice in devices {
            if usingDevice.position == AVCaptureDevice.Position.back {
                backCamera = usingDevice
            }
            else if usingDevice.position == AVCaptureDevice.Position.front {
                frontCamera = usingDevice
            }
        }
        
        currentCamera = backCamera
    }
    
    func setupInputOutput(){
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!)
            session.addInput(captureDeviceInput)
            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
        }
        catch{
            print(error)
        }
        
        
    }
    
    func setupPreviewLayer() {
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        self.view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
    }
    
    func startRunningCaputerSession() {
        session.startRunning()
    }
 }/**/*/
