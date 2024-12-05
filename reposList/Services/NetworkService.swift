//
//  NetworkService.swift
//  reposList
//
//  Created by Fedor Bebinov on 01.12.2024.
//

import Foundation
import SwiftData

protocol NetworkServiceProtocol {
    func getRepos(page: Int) async throws -> [RepositoryInfo]
}

final class NetworkService: NetworkServiceProtocol {
    private let startUrl = "https://api.github.com/search/repositories?q=iOS&sort=stars&order=desc&page="
    
    func getRepos(page: Int) async throws -> [RepositoryInfo] {
        let url = URL(string: startUrl + String(page))
        guard let url else{
            throw RepositoryError.invalidURL(startUrl + String(page))
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                            throw RepositoryError.notFound("Unable to fetch repositories: \(response)")
                        }
            let requestInfo = try JSONDecoder().decode(RequestInfo.self, from: data)
            let repos = requestInfo.items
            return repos
        } catch {
            if let urlError = error as? URLError {
                throw RepositoryError.networkError(urlError)
            } else {
                throw RepositoryError.decodingError(error)
            }
        }
    }
}
