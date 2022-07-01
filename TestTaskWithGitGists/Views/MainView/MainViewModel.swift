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
    
    private var gists = [Gist]()
    
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
        guard let lastDate = self.gists.first?.createdAt else { return }
        networkService.getGistsWithTime(lastDate: lastDate) { [weak self] gistsJSON in
            guard let self = self else { return }
            if gistsJSON.first?.createdAt != self.gists.first?.createdAt && gistsJSON.first?.owner.login != self.gists.first?.owner.login {
                self.gists.insert(contentsOf: gistsJSON, at: 0)
                self.cellModel.value = self.viewModels()
            }
        }
    }
    
    func getGistForPrefetching() {
                guard var nextFrom = self.gists.last?.createdAt else { return }
                nextFrom = dateFormmater(lastDate: nextFrom)
                var gistsArray = [Gist]()
                networkService.getGistsWithTime(lastDate: nextFrom) { [weak self] gistsJSON in
                    guard let self = self else { return }
                    gistsJSON.forEach { gistJSON in
                        if self.gists.contains(where: { $0.url == gistJSON.url }) {
                           
                       } else {
                           print(gistJSON)
                            gistsArray.append(gistJSON)
                       }
                    }
                    }
        self.gists.insert(contentsOf: gistsArray, at: self.gists.count - 1)
        self.cellModel.value = self.viewModels()
    }
    
    func didSelectGist(_ gistViewModel: MainCellModel) {
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
    
    private func dateFormmater(lastDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        var date = dateFormatter.date(from: lastDate)!
        date.addTimeInterval(-60 * 5)
        let dateString = dateFormatter.string(from: date)
        return dateString
    }

}
