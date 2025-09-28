//
//  ViewController.swift
//  MatchMate
//
//  Created by Singhal, Pallak on 27/09/25.
//

import UIKit
import SDWebImage
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let tableView = UITableView()
    private var profiles: [ProfileData] = []
    private let persistence = PersistenceController.shared
    private let network = NetworkService.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadProfiles()
        refreshData()
    }

    func setupUI() {
        title = "Profile Matches"
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshData))
    }

    func loadProfiles() {
        profiles = persistence.fetchStoredProfiles()
        tableView.reloadData()
    }

    @objc func refreshData() {
        tableView.refreshControl?.beginRefreshing()
        if Reachability.isConnectedToNetwork() {
            network.fetchUsers { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let users):
                        self?.persistence.saveProfiles(users)
                        self?.loadProfiles()
                    case .failure(let error):
                        print("Fetch error: \(error)")
                        self?.showError("Failed to fetch users: \(error.localizedDescription)")
                    }
                    self?.tableView.refreshControl?.endRefreshing()
                }
            }
        } else {
            print("Offline mode: Showing cached data")
            self.tableView.refreshControl?.endRefreshing()
            self.showError("No internet connection. Showing cached data.")
        }
    }

    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profiles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let profile = profiles[indexPath.row]
        cell.selectionStyle = .none

        // Clear existing subviews to avoid overlap
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }

        // Image View
        let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 80, height: 80))
        imageView.sd_setImage(with: URL(string: profile.pictureURL ?? ""), placeholderImage: UIImage(systemName: "person.circle"))
        imageView.layer.cornerRadius = 40
        imageView.clipsToBounds = true
        cell.contentView.addSubview(imageView)

        // Name Label
        let nameLabel = UILabel(frame: CGRect(x: 100, y: 10, width: 250, height: 30))
        nameLabel.text = profile.fullName
        nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        cell.contentView.addSubview(nameLabel)

        // Details Label
        let detailsLabel = UILabel(frame: CGRect(x: 100, y: 40, width: 250, height: 30))
        detailsLabel.text = "\(profile.age) years, \(profile.displayLocation ?? "")"
        detailsLabel.font = UIFont.systemFont(ofSize: 14)
        detailsLabel.textColor = .gray
        cell.contentView.addSubview(detailsLabel)

        // Status or Buttons
        if profile.status == "pending" {
            let declineButton = UIButton(frame: CGRect(x: view.frame.width - 140, y: 35, width: 60, height: 30))
            declineButton.setTitle("Decline", for: .normal)
            declineButton.setTitleColor(.red, for: .normal)
            declineButton.addTarget(self, action: #selector(declineAction(_:)), for: .touchUpInside)
            declineButton.tag = indexPath.row
            cell.contentView.addSubview(declineButton)

            let acceptButton = UIButton(frame: CGRect(x: view.frame.width - 70, y: 35, width: 60, height: 30))
            acceptButton.setTitle("Accept", for: .normal)
            acceptButton.setTitleColor(.green, for: .normal)
            acceptButton.addTarget(self, action: #selector(acceptAction(_:)), for: .touchUpInside)
            acceptButton.tag = indexPath.row
            cell.contentView.addSubview(acceptButton)
        } else {
            let statusLabel = UILabel(frame: CGRect(x: 100, y: 70, width: 250, height: 30))
            statusLabel.text = profile.status == "accepted" ? "Member Accepted" : "Member Declined"
            statusLabel.textColor = profile.status == "accepted" ? .green : .red
            statusLabel.font = UIFont.boldSystemFont(ofSize: 16)
            cell.contentView.addSubview(statusLabel)
        }

        return cell
    }

    @objc func declineAction(_ sender: UIButton) {
        let profile = profiles[sender.tag]
        persistence.updateStatus(for: profile.id ?? "", status: "declined")
        loadProfiles()
    }

    @objc func acceptAction(_ sender: UIButton) {
        let profile = profiles[sender.tag]
        persistence.updateStatus(for: profile.id ?? "", status: "accepted")
        loadProfiles()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
