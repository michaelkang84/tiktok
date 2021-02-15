//
//  NotificationsViewController.swift
//  TikTok
//
//  Created by Michael Kang on 1/7/21.
//

import UIKit

class NotificationsViewController: UIViewController {
    
    private let noNotificationsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.text = "No Notifications"
        label.isHidden = true
        label.textAlignment = .center
        return label
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.isHidden = true
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        table.register(NotificationsPostLikeTableViewCell.self, forCellReuseIdentifier: NotificationsPostLikeTableViewCell.identifier)
        table.register(NotificationsUserFollowTableViewCell.self, forCellReuseIdentifier: NotificationsUserFollowTableViewCell.identifier)
        table.register(NotificationsPostCommentTableViewCell.self, forCellReuseIdentifier: NotificationsPostCommentTableViewCell.identifier)
        
        return table
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.tintColor = .label
        spinner.startAnimating()
        return spinner
    }()
    
    var notifications = [Notification]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(noNotificationsLabel)
        view.addSubview(tableView)
        view.addSubview(spinner)
        view.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchNotifications()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        noNotificationsLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        noNotificationsLabel.center = view.center
        spinner.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        spinner.center = view.center
    }
    
    func fetchNotifications() {
        DatabaseManager.shared.getNotifications { [weak self] (notifications) in
            DispatchQueue.main.async {
                self?.spinner.stopAnimating()
                self?.spinner.isHidden = true
                self?.notifications = notifications.shuffled()
                self?.updateUI()
            }
        }
    }
    
    func updateUI() {
        if notifications.isEmpty {
            noNotificationsLabel.isHidden = false
            tableView.isHidden = true
        } else {
            noNotificationsLabel.isHidden = true
            tableView.isHidden = false
        }
        
        tableView.reloadData()
    }
    
}

extension NotificationsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = notifications[indexPath.row]
        
        switch model.type {
        
        case .postLike(let postName):
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: NotificationsPostLikeTableViewCell.identifier,
                    for: indexPath) as? NotificationsPostLikeTableViewCell else {
                return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            }
            
            cell.configure(with: postName, model: model)
            
            return cell
            
        case .userFollow(let username):
            guard let cell = tableView.dequeueReusableCell(
                                                            withIdentifier: NotificationsUserFollowTableViewCell.identifier,
                                                           for: indexPath) as? NotificationsUserFollowTableViewCell else {
                return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            }
            
            cell.configure(with: username, model: model)
            return cell
        case .postComment(let postName):
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: NotificationsPostCommentTableViewCell.identifier,
                    for: indexPath) as? NotificationsPostCommentTableViewCell else {
                return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            }
            
            cell.configure(with: postName, model: model)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {
            return
        }
        
        let model = notifications[indexPath.row]
        model.isHidden = true
        
        DatabaseManager.shared.markNotificationAsHidden(notificationID: model.identifier) { [weak self] (success) in
            DispatchQueue.main.async {
                if success {
                    self?.notifications = self?.notifications.filter({ $0.isHidden == false }) ?? []
                    //remove cell at the index path
                    tableView.beginUpdates()
                    tableView.deleteRows(at: [indexPath], with: .none)
                    tableView.endUpdates()
                } else {
                    print("mark notification as hidden: Failre")
                }
            }
        }
    }
    
}
