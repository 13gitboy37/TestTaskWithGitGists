//
//  NetworkService.swift
//  TestTaskWithGitGists
//
//  Created by Никита Мошенцев on 28.06.2022.
//

import Foundation

final class NetworkService {

    lazy var mySession = URLSession(configuration: configuration)
    let configuration: URLSessionConfiguration = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 10.0
        return config
    }()
    
    private var urlConstructor: URLComponents = {
        var constructor = URLComponents()
        constructor.scheme = "https"
        constructor.host = "api.github.com"
        return constructor
    }()
    
    func getGists(completion: @escaping (Result<[Gist],Error>) -> Void) {
    urlConstructor.path = "/gists"
        urlConstructor.queryItems = [
            URLQueryItem(name: "accept", value: "application/vnd.github.v3+json"),
            URLQueryItem(name: "per_page", value: "20"),
        ]
    guard
        let url = urlConstructor.url
    else { return }
        let task = mySession.dataTask(with: url) { data, response, error in
            if let response = response as? HTTPURLResponse {
                print(response.statusCode)
            }
            guard
                error == nil,
                let data = data
            else { return }
            do {
                guard let gistResponse = try? JSONDecoder().decode([Gist].self, from: data)
                else {
                    return
                }
                completion(.success(gistResponse))
            }
        }
            task.resume()
        }
    
    func getGistsWithTime(lastDate: String, completion: @escaping ([Gist]) -> Void) {
    urlConstructor.path = "/gists"
        urlConstructor.queryItems = [
            URLQueryItem(name: "accept", value: "application/vnd.github.v3+json"),
            URLQueryItem(name: "per_page", value: "10"),
            URLQueryItem(name: "since", value: "\(lastDate)")
        ]
    guard
        let url = urlConstructor.url
    else { return }
        let task = mySession.dataTask(with: url) { data, response, error in
            if let response = response as? HTTPURLResponse {
                print(response.statusCode)
            }
            guard
                error == nil,
                let data = data
            else { return }
            do {
                typealias Gists = [Gist]
                guard let gistResponse = try? JSONDecoder().decode(Gists.self, from: data)
                else {
                    return
                }
                completion((gistResponse))
            }
        }
            task.resume()
        }
    
    func getCommitsGist(idGist: String, completion: @escaping ([GistCommits]) -> Void) {
        urlConstructor.path = "/gists/\(idGist)/commits"
        urlConstructor.queryItems = [
            URLQueryItem(name: "accept", value: "application/vnd.github.v3+json"),
        ]
        guard
            let url = urlConstructor.url
        else { return }
        
        let task = mySession.dataTask(with: url) { data, response, error in
            if let response = response as? HTTPURLResponse {
                print(response.statusCode)
            }
            guard
                error == nil,
                let data = data
            else {return}
            do {
                guard let commitsResponse = try? JSONDecoder().decode([GistCommits].self, from: data)
                else {
                    return
                }
                completion((commitsResponse))
            }
        }
        task.resume()
    }
    
    func getGistContent(url: String, completion: @escaping (Gist) -> Void) {
    guard
        let url = URL(string: url)
    else { return }
        let task = mySession.dataTask(with: url) { data, response, error in
            if let response = response as? HTTPURLResponse {
                print(response.statusCode)
            }
            guard
                error == nil,
                let data = data
            else { return }
            do {
                guard let gistResponse = try? JSONDecoder().decode(Gist.self, from: data)
                else {
                    return
                }
                completion((gistResponse))
            }
        }
            task.resume()
        }
    
}
