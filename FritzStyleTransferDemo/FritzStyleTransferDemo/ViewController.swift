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

public protocol StyleModelTagExample {

    var styleModels: [FritzVisionStyleModel] { get set}

    func load()
}


class InstantiateFromStyleModelClass: StyleModelTagExample {
    var styleModels: [FritzVisionStyleModel] = []

    func load() {
        FritzVisionStyleModel.fetchStyleModelsForTags(tags: ["style-transfer", "not-flexible"]) { downloadedModels, error in
            guard let fritzStyleModels = downloadedModels else {
                print(String(describing: error))
                return
            }
            self.styleModels = fritzStyleModels
        }
    }
}

class InstantiateFromModelManager: StyleModelTagExample {
    var styleModels: [FritzVisionStyleModel] = []

    func load() {
        let managedModel = FritzManagedModel(modelConfig: FritzModelConfiguration(identifier: "16bbb58cca57418993189c54f8642d5f", version: 1))
        managedModel.fetchModel { fetchedMLModel, error in
            guard let model = fetchedMLModel else {
                return
            }
            self.styleModels.append(try! FritzVisionStyleModel(model: model))
        }
    }
}


class FritzStyleTransferTagManagerExample: StyleModelTagExample {
    var styleModels: [FritzVisionStyleModel] = []

    func load() {
        let tagManager = ModelTagManager(tags: ["style-transfer", "not-flexible"])
        tagManager.fetchManagedModelsForTags { fetchedManagedModels, error in
            guard let managedModels = fetchedManagedModels else {
                return
            }
            for managedModel in managedModels {
                managedModel.fetchModel { fetchedMLModel, error in
                    guard let fritzMLModel = fetchedMLModel else {
                        return
                    }
                    let model = try! FritzVisionStyleModel(model: fritzMLModel)
                    self.styleModels.append(model)
                }
            }
        }
    }
}


class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    var previewView = VideoPreviewView()

    lazy var styleModel = FritzVisionStyleModel.starryNight

    let modelsExample: StyleModelTagExample = FritzStyleTransferTagManagerExample()

    private lazy var captureSession: AVCaptureSession = {
        let session = AVCaptureSession()

        guard
            let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
            let input = try? AVCaptureDeviceInput(device: backCamera)
            else { return session }
        session.addInput(input)

        // The style transfer takes a 640x480 image as input and outputs an image of the same size.
        session.sessionPreset = AVCaptureSession.Preset.vga640x480
        return session
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        modelsExample.load()

        // Add preview View as a subview
        view.addSubview(previewView)

        let videoOutput = AVCaptureVideoDataOutput()
        // Necessary video settings for displaying pixels using the VideoPreviewView
        videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA as UInt32]
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "MyQueue"))
        self.captureSession.addOutput(videoOutput)
        self.captureSession.startRunning()

        videoOutput.connection(with: .video)?.videoOrientation = .portrait
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
        if modelsExample.styleModels.count == 0 {
            print("No models :(")
            return
        }
        let model = modelsExample.styleModels[0]
        let fritzImage = FritzVisionImage(buffer: sampleBuffer)
        model.predict(fritzImage) { stylizedImage, error in
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

