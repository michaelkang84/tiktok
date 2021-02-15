//
//  CameraViewController.swift
//  TikTok
//
//  Created by Afraz Siddiqui on 12/24/20.
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
    // player layer for preview of recorded video
    private var previewLayer: AVPlayerLayer?
    // player looper
    var playerLooper: AVPlayerLooper?
    

    private let cameraView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .black
        return view
    }()
    
    private let recordButton = RecordButton()
    var recordedVideoUrl: URL?
    
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
        view.addSubview(recordButton)
        recordButton.addTarget(self, action: #selector(didTapRecord), for: .touchUpInside)
    }
    
 
    override func viewDidAppear(_ animated: Bool) {
        print("camera view did appear")
        super.viewDidAppear(animated)
        tabBarController?.tabBar.isHidden = true
        captureSession.startRunning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("camera view did layout subviews")
        cameraView.frame = view.bounds
        let size: CGFloat = 70
        recordButton.frame = CGRect(x: (view.width - size)/2, y: view.height - view.safeAreaInsets.bottom - size - 5, width: size, height: size)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        captureSession.stopRunning()
    }

    
    @objc private func didTapRecord() {
        if  captureVideoOutput.isRecording {
            print("camera is recording")
            // stop recording
            recordButton.toggle(for: .notRecording)
            captureVideoOutput.stopRecording()
            HapticsManager.shared.vibrateForSelection()
        } else {
            print("camera is not recording")
            guard var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                return
            }
            
            HapticsManager.shared.vibrateForSelection()
            
            url.appendPathComponent("video.mov")
            print(url)
            
            recordButton.toggle(for: .recording)
            
            try? FileManager.default.removeItem(at: url)
            print(url)
            captureVideoOutput.startRecording(to: url, recordingDelegate: self)
        }
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
        print("starting capture session")
//        captureSession.startRunning()
    }
    
    @objc func didTapClose() {
        recordButton.isHidden = false
        navigationItem.rightBarButtonItem = nil
        if previewLayer != nil {
            previewLayer?.removeFromSuperlayer()
            previewLayer = nil
        } else {
            captureSession.stopRunning()
            tabBarController?.tabBar.isHidden = false
            tabBarController?.selectedIndex = 0
        }
    }
}



//MARK: av capture field out recording delegate
extension CameraViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        guard error == nil else {
            let alert = UIAlertController(title: "Woops", message: "Something went wrong when recording your video", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(didTapNext))

        let asset = AVAsset(url: outputFileURL)
        let item = AVPlayerItem(asset: asset)
        
        let player = AVQueuePlayer()
        previewLayer = AVPlayerLayer(player: player)
        
        previewLayer?.videoGravity = .resizeAspectFill
        previewLayer?.frame = cameraView.bounds
        
        recordedVideoUrl = outputFileURL
        
        guard let previewLayer = previewLayer else {
            return
        }
        
        recordButton.isHidden = true
        
        // Create a new player looper with the queue player and template item
        playerLooper = AVPlayerLooper(player: player, templateItem: item)
        
        cameraView.layer.addSublayer(previewLayer)
        
        player.play()
        
        print("finished recording to url: \(outputFileURL.absoluteString )")
    }
 
    @objc func didTapNext()
    {
        print("did tap next button ")
        guard let url = recordedVideoUrl else {
            return
        }
        
        NotificationCenter.default.removeObserver(self)
        
        HapticsManager.shared.vibrateForSelection()
        
        // push caption controller
        let vc = CaptionViewController(videoURL: url)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
