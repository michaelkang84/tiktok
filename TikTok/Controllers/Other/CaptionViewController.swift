//
//  CaptionViewController.swift
//  TikTok
//
//  Created by Michael Kang on 1/23/21.
//

import UIKit
import Appirater
import ProgressHUD

class CaptionViewController: UIViewController {
    
    let videoUrl: URL
    
    private let captionTextView: UITextView = {
        let textView = UITextView()
        textView.contentInset = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        textView.backgroundColor = .secondarySystemBackground
        textView.layer.cornerRadius = 8
        textView.layer.masksToBounds = true
        return textView
    }()
    
    //MARK: init
    init(videoUrl: URL) {
        self.videoUrl = videoUrl
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Caption"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .done, target: self, action: #selector(didTapPost))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        captionTextView.becomeFirstResponder()
    }
    
    @objc private func didTapPost(){
        captionTextView.resignFirstResponder()
        let caption = captionTextView.text ?? ""
        // generate video name
        let newVideoName = StorageManager.shared.generateVideoName()
        // upload video
        StorageManager.shared.uploadVideo(from: videoUrl, fileName: newVideoName) { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    print("upload video into storage success")
                    // update database
                    DatabaseManager.shared.insertPost(filename: newVideoName, caption: caption) { (databaseUpdated) in
                        if databaseUpdated {
                            print("insert post into database success")
                            
                        } else {
                            print("insert post into database failure")
                        }
                    }
                } else {
                    print("upload video failure")
                }
            }
        }
        
        // reset camera and switch to feed
    }
}
