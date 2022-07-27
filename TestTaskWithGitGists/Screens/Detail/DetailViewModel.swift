//
//  DetailViewModel.swift
//  TestTaskWithGitGists
//
//  Created by Никита Мошенцев on 30.06.2022.
//

import Foundation
import UIKit

final class DetailViewModel {
    
    // MARK: - Properties
    
    let filesModel = Observable<DetailGistCellModel>(DetailGistCellModel(userName: "",
                                                                         avatarURL: "",
                                                                         files: []))
    
    var gist: Gist?
    
    private let networkService = NetworkService()
    private var files = [FileGist]()
    
    weak var viewController: UIViewController?
    
    //MARK: - Init
    
    init(gist: Gist, viewController: UIViewController) {
        self.gist = gist
        self.viewController = viewController
    }
    
    //MARK: - Methods
    
    private func refreshFiles() {
        self.gist?.files.values.forEach({ fileGist in
            self.files.append(fileGist)
        })
    }
    
    func getGistContent() {
        networkService.getGistContent(url: gist?.url ?? "") { [weak self] content in
            guard let self = self else { return }
            self.gist = content
            self.refreshFiles()
            self.filesModel.value = self.viewModel()
        }
    }
    
    func refreshFileGist() {
        guard let url = gist?.url else { return }
        networkService.getGistContent(url: url) { [weak self] gistRefresh in
            guard let self = self else { return }
            gistRefresh.files.forEach { fileGist in
                if self.files.contains(where: { $0.filename == fileGist.value.filename }) {
                    return
                } else {
                    self.gist = gistRefresh
                    self.refreshFiles()
                    self.filesModel.value = self.viewModel()
                }
            }
        }
    }
    
    func didSelectFiles(indexPath: IndexPath) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let fullscreenviewController = storyboard.instantiateViewController(withIdentifier: "FileFullScreenViewController") as! FileDetailViewController
        let fileDetailsViewController = FileDetailsViewController(nibName: "FileDetailsViewController", bundle: nil)
        fileDetailsViewController.fileName = "\(files[indexPath.item].filename)"
        fileDetailsViewController.contentFile = "\(files[indexPath.item].content ?? "")"
        fileDetailsViewController.idGist = "\(gist?.id ?? "")"
        viewController?.present(fileDetailsViewController, animated:true)
    }
    
    func viewModel() -> DetailGistCellModel {
        return DetailGistCellModel(userName: self.gist?.owner.login ?? "",
                                   avatarURL: self.gist?.owner.avatarUrl ?? "",
                                   files: self.files)
    }
}
