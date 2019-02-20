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
    
    var previewView: UIImageView!
    
    // Initialize the model carousel. See Models/Models+Fritz.swift for the definition of this data structure.
    var models = FritzVisionStyleTypes.allCases
    var activeModel: FritzVisionFlexibleStyleModel?
    var activeModelIndex: Int?
    
    // Initalize flexible model options. In this case, we want the model to
    // create stylized versions of input images at whatever the original size is.
    lazy var modelOptions: FritzVisionFlexibleStyleModelOptions = {
        let options = FritzVisionFlexibleStyleModelOptions()
        options.flexibleModelDimensions = .original
        return options
    }()

    // The image size of the capture session. This will also be the output size of the
    // stylized images. Other values: hd1280x720, hd1920x1080
    let presetSize = AVCaptureSession.Preset.vga640x480
    
    private lazy var captureSession: AVCaptureSession = {
        let session = AVCaptureSession()
        
        guard
            let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
            let input = try? AVCaptureDeviceInput(device: backCamera)
            else { return session }
        session.addInput(input)
        
        // The style transfer takes a 640x480 image as input and outputs an image of the same size.
        session.sessionPreset = self.presetSize
        return session
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the active model to the first one
        self.activeModel = models[0].getModel()
        self.activeModelIndex = 0

        previewView = UIImageView(frame: view.frame)
        previewView.contentMode = .scaleAspectFit
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
        // Loop if we get back to the begining
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

            let image = UIImage(pixelBuffer: stylizedImage)
            DispatchQueue.main.async {
                self.previewView.image = image
            }
        }
    }
    
}
