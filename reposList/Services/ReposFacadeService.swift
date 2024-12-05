//
//  ReposFacadeService.swift
//  reposList
//
//  Created by Fedor Bebinov on 03.12.2024.
//

import Foundation

protocol ReposFacadeServiceProtocol {
    func getRepos(page: Int) async throws -> [StoredRepositoryInfo]
    func updateDescription(index: Int, descriptionText: String) throws
    func getLocalRepos() throws -> [StoredRepositoryInfo]
    func deleteRepo(index: Int) throws
}

class ReposFacadeService: ReposFacadeServiceProtocol {
    private let networkService:NetworkServiceProtocol
    private let strorageService: StorageServiceProtocol
    
    init(networkService: NetworkServiceProtocol, strorageService: StorageServiceProtocol) {
        self.networkService = networkService
        self.strorageService = strorageService
    }
    
    func getRepos(page: Int) async throws -> [StoredRepositoryInfo] {
        let repos = try await networkService.getRepos(page: page)
        strorageService.save(repos: repos)
        return try strorageService.allRepos()
    }
    
    func updateDescription(index: Int, descriptionText: String) throws {
        try strorageService.update(index: index, descriptionText: descriptionText)
    }
    
    func getLocalRepos()throws -> [StoredRepositoryInfo] {
        try strorageService.allRepos()
    }
    
    func deleteRepo(index: Int) throws {
        try strorageService.delete(index: index)
    }
}