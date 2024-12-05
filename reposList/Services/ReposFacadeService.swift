//
//  ReposFacadeService.swift
//  reposList
//
//  Created by Fedor Bebinov on 03.12.2024.
//

import Foundation

protocol ReposFacadeServiceProtocol {
    func getRepos(page: Int) async throws -> [StoredRepositoryInfo]
    func save() throws
    func getLocalRepos() throws -> [StoredRepositoryInfo]
    func deleteRepo(index: Int) throws
    func configure() throws
}

final class ReposFacadeService: ReposFacadeServiceProtocol {
    private let networkService:NetworkServiceProtocol
    private let storageService: StorageServiceProtocol
    
    init(networkService: NetworkServiceProtocol, strorageService: StorageServiceProtocol) {
        self.networkService = networkService
        self.storageService = strorageService
    }
    
    func getRepos(page: Int) async throws -> [StoredRepositoryInfo] {
        let repos = try await networkService.getRepos(page: page)
        if page == 1 {
            try storageService.deleteAll()
        }
        storageService.insert(repos: repos)
        return try storageService.allRepos()
    }
    
    func save() throws {
        try storageService.save()
    }
    
    func getLocalRepos()throws -> [StoredRepositoryInfo] {
        try storageService.allRepos()
    }
    
    func deleteRepo(index: Int) throws {
        try storageService.delete(index: index)
    }
    
    func configure() throws{
        try storageService.configure()
    }
}
