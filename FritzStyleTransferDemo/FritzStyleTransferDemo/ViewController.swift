//
//  ViewController.swift
//  FritzStyleTransferDemo
//
//  Created by Christopher Kelly on 9/12/18.
//  Copyright © 2018 Fritz. All rights reserved.
//
import UIKit
import Photos
import Fritz

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    var previewView = VideoPreviewView()
    
    lazy var styleModel = FritzVisionStyleTypes.starry_night
    var models = FritzVisionStyleTypes.allCases
    var activeModel: FritzVisionFlexibleStyleModel?
    var activeModelIndex: Int?
    
    let modelOptions = FritzVisionFlexibleStyleModelOptions(flexibleModelDimensions: FlexibleModelDimensions.original)
    
    private lazy var captureSession: AVCaptureSession = {
        let session = AVCaptureSession()
        
        guard
            let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
            let input = try? AVCaptureDeviceInput(device: backCamera)
            else { return session }
        session.addInput(input)
        
        // The style transfer takes a 640x480 image as input and outputs an image of the same size.
        session.sessionPreset = AVCaptureSession.Preset.hd1280x720
        return session
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activeModel = models[0].getModel()
        self.activeModelIndex = 0
        
        // Add preview View as a subview
        view.addSubview(previewView)
        
        let videoOutput = AVCaptureVideoDataOutput()
        // Necessary video settings for displaying pixels using the VideoPreviewView
        videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA as UInt32]
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "MyQueue"))
        self.captureSession.addOutput(videoOutput)
        self.captureSession.startRunning()
        
        videoOutput.connection(with: .video)?.videoOrientation = .portrait
        
        // Tap anywhere on the screen to change the current model (hack for now)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
    }
    
    @objc func tapped()
    {
        activateNextStyle()
    }
    
    func activateNextStyle()
    {
        if let modelIndex = self.activeModelIndex, modelIndex == models.count - 1 {
            self.activeModel = models.first!.getModel()
            self.activeModelIndex = 0
        } else if let _ = activeModel,
            let modelIndex = self.activeModelIndex {
            self.activeModel = models[modelIndex + 1].getModel()
            self.activeModelIndex = modelIndex + 1
        } else {
            activeModel = models.first!.getModel()
            self.activeModelIndex = 0
        }
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        previewView.frame = view.bounds
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let fritzImage = FritzVisionImage(buffer: sampleBuffer)
        self.activeModel!.predict(fritzImage, options: modelOptions) { stylizedImage, error in
            guard let stylizedImage = stylizedImage, error == nil else {
                print("Error encountered running Style Model")
                return
            }
            DispatchQueue.main.async {
                self.previewView.display(buffer: stylizedImage)
            }
        }
    }
    
}
