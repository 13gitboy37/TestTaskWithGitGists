//
//  ViewController.swift
//  TestTaskWithGitGists
//
//  Created by Никита Мошенцев on 28.06.2022.
//

import UIKit

class MainViewController: UIViewController {
    
    //MARK: - Private properties
    
    private var photoService: PhotoService?
    private let viewModel = MainViewModel()

    private var gists: [MainCellModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.mainView.tableView.reloadData()
            }
        }
    }
    
    private var isLoading: Bool = false
    
    private var mainView: MainView {
        return view as! MainView
    }
    
    private struct Constants {
        static let reuseIdentifier = "reuseId"
    }
    
    //MARK: - Lificycle
    
    override func loadView() {
        super.loadView()
        self.view = MainView()
        self.viewModel.viewController = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "GitHub Gists"
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.tableView.prefetchDataSource = self
        bindViewModel()
        viewModel.getGists()
        photoService = PhotoService(container: mainView.tableView)
        mainView.tableView.register(MainCell.self, forCellReuseIdentifier: Constants.reuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupRefreshControl()
    }
    
    //MARK: - Methods
    
    private func bindViewModel() {
        self.viewModel.cellModel.addObserver(self) { [weak self]  (gistJSON, _) in
            self?.gists = gistJSON
        }
    }
    
    fileprivate func setupRefreshControl() {
        self.mainView.tableView.refreshControl = UIRefreshControl()
        self.mainView.tableView.refreshControl?.attributedTitle = NSAttributedString(string: "Обновление...")
        self.mainView.tableView.refreshControl?.tintColor = .gray
        self.mainView.tableView.refreshControl?.addTarget(self, action: #selector(refreshGists), for: .valueChanged)
            }
    
    @objc func refreshGists() {
        self.viewModel.getGistForRefreshController()
        DispatchQueue.main.async {
            self.mainView.tableView.refreshControl?.endRefreshing()
        }
    }
}

//MARK: - TableViewDelegate

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentGist = self.gists[indexPath.row]
        viewModel.didSelectGist(currentGist)
    }
}
//MARK: - TableViewDataSource

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        gists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentGist = gists[indexPath.row]
        
        let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: Constants.reuseIdentifier, for: indexPath)
        
        guard let cell = dequeuedCell as? MainCell else {
            return dequeuedCell
        }
        
        configure(cell: cell, with: currentGist, indexPath: indexPath)
        return cell
        
    }
    
    private func configure(cell: MainCell, with gist: MainCellModel, indexPath: IndexPath) {
        cell.nameGistLabel.text = gist.fileName
        cell.userNameLabel.text = gist.userName
        guard let currentAvatar = photoService?.photo(atIndexPath: indexPath, byUrl: gist.avatarURL)
        else { return }
        cell.avatarImage.image = currentAvatar
    }
}

//MARK: - Prefetch Data Source

extension MainViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let maxRow = indexPaths.map({ $0.row }).max() else { return }
        
        if maxRow > gists.count - 2, !isLoading {
                isLoading = true
            viewModel.getGistForPrefetching()
            }
        isLoading = false
        }
    }
