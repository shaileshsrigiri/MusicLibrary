//
//  SpotifyTableViewController.swift
//  Q15
//
//  Created by Shailesh Srigiri on 11/20/24.
//

import UIKit

class SpotifyTableViewController: UITableViewController {
    
    let filterStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    // Mini Player View at the bottom
    let miniPlayerView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()

    // Header View for Recently Played and Grid Options
    let recentlyPlayedLabel: UILabel = {
        let label = UILabel()
        label.text = "Recently played"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.grid.2x2"), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(SpotifyTableViewController.self, action: #selector(gridTapped), for: .touchUpInside)
        return button
    }()

    // Sample data for table view
    let items = [
        ("Liked Songs", "7,343 songs", UIImage(systemName: "heart.fill")),
        ("My Favorite Playlists", "2 playlists", UIImage(systemName: "music.note.list")),
        ("Matt Suda: JAMS", "Matt Suda", UIImage(systemName: "person.fill")),
        ("How To Be Human", "Chelsea Cutler", UIImage(systemName: "music.note")),
        ("How it Used to Feel", "Phoebe Ryan", UIImage(systemName: "music.note")),
        ("A Letter To My Younger Self", "Quinn XCII", UIImage(systemName: "music.note"))
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

                // Set up the navigation bar
                setupNavigationBar()

                // Set up the filter buttons
                setupFilterButtons()

                // Set up the mini player
                setupMiniPlayer()

                // Set up the header view
                setupHeaderView()

                // Set up the table view
                tableView.backgroundColor = .black
                tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
                tableView.separatorStyle = .none

                // Add filter stack view to the main view
                tableView.tableHeaderView = filterStackView
    }

    func setupNavigationBar() {
        navigationItem.title = "Your Library"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.tintColor = .systemBlue
        let profileButton = UIBarButtonItem(image: UIImage(systemName: "person.circle.fill"), style: .plain, target: self, action: #selector(profileTapped))
        navigationItem.leftBarButtonItem = profileButton
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchTapped))
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItems = [addButton, searchButton]
    }

    func setupFilterButtons() {
        let filterTitles = ["Playlists", "Artists", "Albums", "Podcasts & Shows"]

        for title in filterTitles {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .darkGray
            button.layer.cornerRadius = 15
            button.clipsToBounds = true
            filterStackView.addArrangedSubview(button)
        }

        filterStackView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
    }

    // Setup Header View with Recently Played and Grid Button
    func setupHeaderView() {
        let headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(recentlyPlayedLabel)
        headerView.addSubview(gridButton)
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)

        tableView.tableHeaderView = headerView

        NSLayoutConstraint.activate([
            recentlyPlayedLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 10),
            recentlyPlayedLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),

            gridButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -10),
            gridButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
    }

    // Setup Mini Player
    func setupMiniPlayer() {
        view.addSubview(miniPlayerView)
        NSLayoutConstraint.activate([
            miniPlayerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            miniPlayerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            miniPlayerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            miniPlayerView.heightAnchor.constraint(equalToConstant: 80)
        ])

        // Add elements to mini player
        let songImageView = UIImageView(image: UIImage(systemName: "music.note"))
        songImageView.tintColor = .white
        songImageView.translatesAutoresizingMaskIntoConstraints = false
        songImageView.contentMode = .scaleAspectFit
        songImageView.layer.cornerRadius = 5
        songImageView.clipsToBounds = true

        let songLabel = UILabel()
        songLabel.text = "How To Be Human - Chelsea Cutler"
        songLabel.textColor = .white
        songLabel.font = UIFont.boldSystemFont(ofSize: 16)
        songLabel.translatesAutoresizingMaskIntoConstraints = false

        let artistLabel = UILabel()
        artistLabel.text = "Chelsea Cutler"
        artistLabel.textColor = .lightGray
        artistLabel.font = UIFont.systemFont(ofSize: 14)
        artistLabel.translatesAutoresizingMaskIntoConstraints = false

        let playButton = UIButton(type: .system)
        playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        playButton.tintColor = .white
        playButton.translatesAutoresizingMaskIntoConstraints = false

        miniPlayerView.addSubview(songImageView)
        miniPlayerView.addSubview(songLabel)
        miniPlayerView.addSubview(artistLabel)
        miniPlayerView.addSubview(playButton)

        NSLayoutConstraint.activate([
            songImageView.leadingAnchor.constraint(equalTo: miniPlayerView.leadingAnchor, constant: 10),
            songImageView.centerYAnchor.constraint(equalTo: miniPlayerView.centerYAnchor),
            songImageView.widthAnchor.constraint(equalToConstant: 50),
            songImageView.heightAnchor.constraint(equalToConstant: 50),

            songLabel.leadingAnchor.constraint(equalTo: songImageView.trailingAnchor, constant: 10),
            songLabel.topAnchor.constraint(equalTo: miniPlayerView.topAnchor, constant: 15),
            songLabel.trailingAnchor.constraint(equalTo: playButton.leadingAnchor, constant: -10),

            artistLabel.leadingAnchor.constraint(equalTo: songImageView.trailingAnchor, constant: 10),
            artistLabel.topAnchor.constraint(equalTo: songLabel.bottomAnchor, constant: 2),
            artistLabel.trailingAnchor.constraint(equalTo: playButton.leadingAnchor, constant: -10),

            playButton.trailingAnchor.constraint(equalTo: miniPlayerView.trailingAnchor, constant: -10),
            playButton.centerYAnchor.constraint(equalTo: miniPlayerView.centerYAnchor),
            playButton.widthAnchor.constraint(equalToConstant: 30),
            playButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        let item = items[indexPath.row]
        cell.configure(with: item.0, subtitle: item.1, icon: item.2)
        cell.backgroundColor = .black
        return cell
    }
    @objc func profileTapped() {
        print("Profile button tapped")
    }

    @objc func searchTapped() {
        print("Search button tapped")
    }

    @objc func addTapped() {
        print("Add button tapped")
    }
    
    @objc func gridTapped() {
        print("Grid button tapped")
    }
}
