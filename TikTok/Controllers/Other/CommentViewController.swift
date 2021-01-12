//
//  CommentViewController.swift
//  TikTok
//
//  Created by Michael Kang on 1/12/21.
//

import UIKit

protocol CommentViewControllerDelegate: AnyObject {
    func didTapCloseComments(with viewController: CommentViewController)
}

class CommentViewController: UIViewController {
    
    weak var delegate: CommentViewControllerDelegate?
    private let post: PostModel
    private var comments = [CommentModel]()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    init(post: PostModel) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        view.backgroundColor = .white
        fetchPostComments()
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        closeButton.frame = CGRect(x: view.width - 40, y: 10, width: 30, height: 30)
        tableView.frame = CGRect(x: 0,
                              y: closeButton.bottom,
                              width: view.width,
                              height: view.width - closeButton.bottom
        )
    }
    
    @objc private func didTapClose() {
        delegate?.didTapCloseComments(with: self)
    }
    
    func fetchPostComments() {
        // DatabaseMangaer.shared.fetchComments
        self.comments = CommentModel.mockComments()
        
    }
    
}

extension CommentViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let comment = comments[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = comment.text
        return cell
    }
 
}
