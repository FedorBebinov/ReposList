//
//  ServiceLocator.swift
//  reposList
//
//  Created by Fedor Bebinov on 02.12.2024.
//

import Foundation

struct ServiceLocator{
    static let networkService: NetworkServiceProtocol = NetworkService()
    static let storageService: StorageServiceProtocol = StorageService()
    static let reposFacade: ReposFacadeServiceProtocol = ReposFacadeService(networkService: networkService, strorageService: storageService)
}
