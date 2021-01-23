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
    
    private let recordButton = RecordButton()
    private var previewLayer: AVPlayerLayer?
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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("camera view did layout subviews")
        cameraView.frame = view.bounds
        let size: CGFloat = 70
        recordButton.frame = CGRect(x: (view.width - size)/2, y: view.height - view.safeAreaInsets.bottom - size - 5, width: size, height: size)
    }
    
    @objc func didTapClose() {
        captureSession.stopRunning()
        tabBarController?.tabBar.isHidden = false
        tabBarController?.selectedIndex = 0
    }
    
    @objc private func didTapRecord() {
        if  captureVideoOutput.isRecording {
            // stop recording
            recordButton.toggle(for: .notRecording)
            captureVideoOutput.stopRecording()
            HapticsManager.shared.vibrateForSelection()
        } else {
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
        captureSession.startRunning()
    }
}

extension CameraViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        guard error == nil else {
            let alert = UIAlertController(title: "Woops", message: "Something went wrong when recording your video", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        recordedVideoUrl = outputFileURL
        let player = AVPlayer(url: outputFileURL)
        previewLayer = AVPlayerLayer(player: player)
        previewLayer?.videoGravity = .resizeAspectFill
        previewLayer?.frame = cameraView.bounds
        
        guard let previewLayer = previewLayer else {
            return
        }
        
        recordButton.isHidden = true
        cameraView.layer.addSublayer(previewLayer)
        previewLayer.player?.play()
        
        player.actionAtItemEnd = .none

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerItemDidReachEnd(notification:)),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: player.currentItem)
        print("finished recording to url: \(outputFileURL.absoluteString )")
    }
    
    @objc func playerItemDidReachEnd(notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: CMTime.zero, completionHandler: nil)
        }
    }
    
    
}
