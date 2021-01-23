//
//  CameraViewController.swift
//  TikTok
//
//  Created by Michael Kang on 1/7/21.
//

import AVFoundation
import UIKit

class CameraViewController: UIViewController {
    
    // capture session
    var captureSession = AVCaptureSession()
    // capture device
    var videoCaptureDevice: AVCaptureDevice?
    // capture output
    var captureVideoOutput = AVCaptureMovieFileOutput()
    // capture preview
    var capturePreviewLayer: AVCaptureVideoPreviewLayer?
    

    private let cameraView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .black
        return view
    }()
    
    // MARK: lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("camera view did load")
        view.addSubview(cameraView)
        view.backgroundColor = .systemBackground
        setUpCamera()
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(didTapClose)
        )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("camera view did appear")
        super.viewDidAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("camera view did layout subviews")
        cameraView.frame = view.bounds
    }
    
    @objc func didTapClose() {
        captureSession.stopRunning()
        tabBarController?.tabBar.isHidden = false
        tabBarController?.selectedIndex = 0
    }
    
    
    func setUpCamera() {
       
        let audioDevice = AVCaptureDevice.default(for: .audio)
        
        guard let audioInput = try? AVCaptureDeviceInput(device: audioDevice!),
              captureSession.canAddInput(audioInput) else {return}
        
        captureSession.addInput(audioInput)
        
        if let videoDevice = AVCaptureDevice.default(for: .video) {
            if let videoInput = try?AVCaptureDeviceInput(device: videoDevice) {
                if captureSession.canAddInput(videoInput) {
                    captureSession.addInput(videoInput)
                }
            }
        }
        // update session
        captureSession.sessionPreset = .hd1280x720
        guard captureSession.canAddOutput(captureVideoOutput) else {return}
        captureSession.addOutput(captureVideoOutput)
        // configure preview
        capturePreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        capturePreviewLayer?.videoGravity = .resizeAspectFill
        capturePreviewLayer?.frame = view.bounds
        
        if let previewLayer = capturePreviewLayer {
            cameraView.layer.addSublayer(previewLayer)
        }
        // enable camera start
        captureSession.startRunning()
    }
}

extension CameraViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        guard error == nil else {
            return
        }
        
        print("finished recording to url: \(outputFileURL.absoluteString )")
    }
    
    
}
