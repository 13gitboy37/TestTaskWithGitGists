//
//  FileFullScreenViewController.swift
//  TestTaskWithGitGists
//
//  Created by Никита Мошенцев on 30.06.2022.
//

import UIKit

class FileDetailsViewController: UIViewController {
    
    //MARK: - Properties
    
    var fileName: String?
    var contentFile: String?
    private var commitsFile = [GistCommits]() {
        didSet{
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    var idGist = String()
    
    private let networkService = NetworkService()
    
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var fileNameLabel: UILabel!
    @IBOutlet weak var contentFileLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        networkService.getCommitsGist(idGist: idGist) { [weak self] commits in
            self?.commitsFile = commits         }
        fileNameLabel.text = fileName
        contentFileLabel.text = contentFile
        self.collectionView.register(UINib(
            nibName: "CommitsFileCell",
            bundle: nil),
            forCellWithReuseIdentifier: "commitsFileCell")
    }
}

//MARK: - CollectionView Delegate

extension FileDetailsViewController: UICollectionViewDelegate {
    
}

//MARK: - CollectionView DataSource

extension FileDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        commitsFile.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
       guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "commitsFileCell", for: indexPath) as? CommitsFileCell
        else {
           return UICollectionViewCell()
       }
        let currentCommits = commitsFile[indexPath.item]
        cell.configure(gistCommits: currentCommits)
        return cell
    }
}

