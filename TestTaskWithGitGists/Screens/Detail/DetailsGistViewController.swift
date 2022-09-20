//
//  DetailsGistViewController.swift
//  TestTaskWithGitGists
//
//  Created by Никита Мошенцев on 27.07.2022.
//

import UIKit

class DetailsGistViewController: UIViewController {
    
    //MARK: - Properties
    
    var viewModel: DetailViewModel?
    
    //MARK: - Outlets
    
    @IBOutlet weak var avatarUserImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var gistNameLabel: UILabel!
    @IBOutlet weak var collectionVIew: UICollectionView!
    
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
        collectionVIew.delegate = self
        collectionVIew.dataSource = self
        collectionVIew.register(UINib(
            nibName: "DetailViewCell",
            bundle: nil),
            forCellWithReuseIdentifier: "detailViewCell")
        setupRefreshControl()
        userNameLabel.isHidden = true
        gistNameLabel.isHidden = true
    }
    
    private func configureUI() {
        userNameLabel.isHidden = false
        gistNameLabel.isHidden = false
        userNameLabel.text = viewModel?.filesModel.value.userName
        gistNameLabel.text = viewModel?.filesModel.value.files.first?.filename
        avatarUserImage.image = viewModel?.filesModel.value.avatarURL
    }
    
    private func bindViewModel() {
        self.viewModel?.filesModel.addObserver(self, closure: { [weak self] (filesViewModel, _) in
            DispatchQueue.main.async {
                self?.collectionVIew.reloadData()
            }
        })
    }
    
    fileprivate func setupRefreshControl() {
        self.collectionVIew.refreshControl = UIRefreshControl()
        self.collectionVIew.refreshControl?.attributedTitle = NSAttributedString(string: "Обновление...")
        self.collectionVIew.refreshControl?.tintColor = .gray
        self.collectionVIew.refreshControl?.addTarget(self, action: #selector(refreshFilesGist), for: .valueChanged)
            }
    
    @objc func refreshFilesGist() {
        viewModel?.refreshFileGist()
            DispatchQueue.main.async {
                self.collectionVIew.refreshControl?.endRefreshing()
            }
    }
}

//MARK: - Colection View Delegate

extension DetailsGistViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel?.didSelectFiles(indexPath: indexPath)
    }
}

//MARK: - Collection View DataSource

extension DetailsGistViewController: UICollectionViewDataSource {
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

extension DetailsGistViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width) - 6, height: (UIScreen.main.bounds.height / 8) - 6)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
    }
}

