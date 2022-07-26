//
//  MainViewModel.swift
//  TestTaskWithGitGists
//
//  Created by Никита Мошенцев on 29.06.2022.
//

import UIKit

final class MainViewModel {
    
    //MARK: - Properties
    
    let cellModel = Observable<[MainCellModel]>([])
    
    weak var viewController: UIViewController?
    
    var gists = [Gist]()
    
    private var page = 1
    
    private let networkService = NetworkService()
    
    //MARK: - Methods
    
    func getGists() {
        networkService.getGists { [weak self] result in
            switch result {
            case .success(let gistArray):
                guard let self = self else { return }
                self.gists = gistArray
                self.cellModel.value = self.viewModels()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getGistForRefreshController() {
        
        networkService.getGists { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let gistsJSON):
                if gistsJSON.first?.createdAt != self.gists.first?.createdAt && gistsJSON.first?.owner.login != self.gists.first?.owner.login {
                    self.gists.insert(contentsOf: gistsJSON, at: 0)
                    self.cellModel.value = self.viewModels()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getGistForPrefetching() {
        page += 1
        networkService.getGistsWithTime(page: page) { [weak self] gistsJSON in
            guard let self = self else { return }
            gistsJSON.forEach { gistJSON in
                if self.gists.contains(where: { $0.id == gistJSON.id }) {
                    print(true)
                } else {
                    print(gistJSON)
                    self.gists.append(gistJSON)
                    self.cellModel.value = self.viewModels()
                }
            }
        }
    }
    
    func didSelectGist(_ gistViewModel: MainCellModel) {
        
#warning("Убрать подгрузку контроллера через storyboard и сделать через Xib")
        guard let gist = self.gist(with: gistViewModel) else { return }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailGistViewController = storyboard.instantiateViewController(withIdentifier: "DetailGistViewControllerID") as! DetailGistViewController
        let detailViewModel = DetailViewModel(gist: gist, viewController: detailGistViewController)
        detailGistViewController.viewModel = detailViewModel
        
        self.viewController?.navigationController?.pushViewController(detailGistViewController, animated: true)
    }
    
    private func viewModels() -> [MainCellModel] {
        return self.gists.compactMap { gist -> MainCellModel in
            return MainCellModel(url: gist.url,
                                 userName: gist.owner.login,
                                 avatarURL: gist.owner.avatarUrl,
                                 createdAt: gist.createdAt,
                                 fileName: gist.files.values.first?.filename ?? "")
        }
    }
    
    private func gist(with viewModel: MainCellModel) -> Gist? {
        return self.gists.first { viewModel.url == $0.url }
    }
}
