//
//  StorageService.swift
//  reposList
//
//  Created by Fedor Bebinov on 03.12.2024.
//

import Foundation
import SwiftData

protocol StorageServiceProtocol {
    func save(repos: [RepositoryInfo])
    func update(index: Int, descriptionText: String) throws
    func delete(index: Int) throws
    func allRepos() throws -> [StoredRepositoryInfo]
}

class StorageService: StorageServiceProtocol {
    
    private let container: ModelContainer
    private let context: ModelContext
    
    init() {
        container = try! ModelContainer.init(for: StoredRepositoryInfo.self)
        context = ModelContext(container)
    }
    
    func save(repos: [RepositoryInfo]) {
        for repo in repos {
            let storedRepo = StoredRepositoryInfo(name: repo.name, avatarUrl: repo.owner.avatar_url, specification: repo.description)
            context.insert(storedRepo)
        }
        
    }
    
    func update(index: Int, descriptionText: String) throws {
        let repos = try allRepos()
        let repoToUpdate = repos[index]
        repoToUpdate.specification = descriptionText
        do {
            try context.save()
        } catch {
            throw RepositoryError.storageError("Failed to update repository")
        }
    }
    
    func delete(index: Int) throws {
        let repos = try allRepos()
        let repoToDelete = repos[index]
            
        context.delete(repoToDelete)
        do {
            try context.save()
        } catch {
            throw RepositoryError.storageError("Failed to delete repository")
        }
    }
    
    func allRepos() throws -> [StoredRepositoryInfo]{
        let descriptor = FetchDescriptor<StoredRepositoryInfo>()
        do {
            return try context.fetch(descriptor)
        } catch {
            throw RepositoryError.storageError("Failed to fetch all repositories")
        }
    }
}
