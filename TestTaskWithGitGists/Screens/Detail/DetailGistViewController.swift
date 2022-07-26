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
    
//    private var filesGist = DetailGistCellModel(userName: "", avatarURL: "", files: []) {
//        didSet {
//            DispatchQueue.main.async {
//                self.collectionView.reloadData()
//            }
//        }
//    }
    
    private var photoService: PhotoService?
    
    //MARK: - Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var nameGistLabel: UILabel!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel?.getGistContent()
        bindViewModel()
    }
        
    //MARK: - Methods
    
    private func setupUI() {
        view.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        self.collectionView.register(UINib(
            nibName: "DetailViewCell",
            bundle: nil),
            forCellWithReuseIdentifier: "detailViewCell")
        photoService = PhotoService(container: collectionView)
        setupRefreshControl()
        userNameLabel.isHidden = true
        nameGistLabel.isHidden = true
    }
    
    private func configureUI() {
        userNameLabel.isHidden = false
        nameGistLabel.isHidden = false
        userNameLabel.text = viewModel?.filesModel.value.userName
        nameGistLabel.text = viewModel?.filesModel.value.files.first?.filename
        avatarImage.image = photoService?.photo(byUrl: viewModel?.filesModel.value.avatarURL ?? "")
    }
    
    private func bindViewModel() {
        self.viewModel?.filesModel.addObserver(self, closure: { [weak self] (filesViewModel, _) in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
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
        viewModel?.filesModel.value.files.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell( withReuseIdentifier: "detailViewCell",for: indexPath) as? DetailViewCell
        else {
        return UICollectionViewCell()
    }
        configureUI()
         guard let currentFileGist = viewModel?.filesModel.value.files[indexPath.item]
            else { return UICollectionViewCell() }
        cell.configure(file: currentFileGist)
    return cell
    }
}
