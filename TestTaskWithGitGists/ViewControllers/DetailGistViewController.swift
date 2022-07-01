//
//  DetailGistViewController.swift
//  TestTaskWithGitGists
//
//  Created by Никита Мошенцев on 29.06.2022.
//

import UIKit

class DetailGistViewController: UIViewController {
    
    //MARK: - Properties
    
    var viewModel: DetailViewModel?
    
    private var filesGist = DetailGistModel(userName: "", avatarURL: "", files: []) {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    private var photoService: PhotoService?
    
    //MARK: - Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var nameGistLabel: UILabel!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        self.collectionView.register(UINib(
            nibName: "DetailViewCell",
            bundle: nil),
            forCellWithReuseIdentifier: "detailViewCell")
        viewModel?.getGistContent()
        bindViewModel()
        photoService = PhotoService(container: collectionView)
        userNameLabel.isHidden = true
        nameGistLabel.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupRefreshControl()
    }
    
    //MARK: - Methods
    
    private func configureUI() {
        userNameLabel.isHidden = false
        nameGistLabel.isHidden = false
        userNameLabel.text = filesGist.userName
        nameGistLabel.text = filesGist.files.first?.filename
        avatarImage.image = photoService?.photo(byUrl: filesGist.avatarURL)
    }
    
    private func bindViewModel() {
        self.viewModel?.filesModel.addObserver(self, closure: { [weak self] (filesViewModel, _) in
            self?.filesGist = filesViewModel
        })
    }
    
    fileprivate func setupRefreshControl() {
        self.collectionView.refreshControl = UIRefreshControl()
        self.collectionView.refreshControl?.attributedTitle = NSAttributedString(string: "Обновление...")
        self.collectionView.refreshControl?.tintColor = .gray
        self.collectionView.refreshControl?.addTarget(self, action: #selector(refreshFilesGist), for: .valueChanged)
            }
    
    @objc func refreshFilesGist() {
        viewModel?.refreshFileGist()
            DispatchQueue.main.async {
                self.collectionView.refreshControl?.endRefreshing()
            }
    }
}

//MARK: - Colection View Delegate

extension DetailGistViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel?.didSelectFiles(indexPath: indexPath)
    }
}

//MARK: - Collection View DataSource

extension DetailGistViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        filesGist.files.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell( withReuseIdentifier: "detailViewCell",for: indexPath) as? DetailViewCell
        else {
        return UICollectionViewCell()
    }
        configureUI()
        let currentFileGist = filesGist.files[indexPath.item]
        cell.configure(file: currentFileGist)
    return cell
    }
}
