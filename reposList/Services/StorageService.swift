//
//  StorageService.swift
//  reposList
//
//  Created by Fedor Bebinov on 03.12.2024.
//

import Foundation
import SwiftData

protocol StorageServiceProtocol {
    func insert(repos: [RepositoryInfo])
    func save() throws
    func delete(index: Int) throws
    func deleteAll() throws
    func allRepos() throws -> [StoredRepositoryInfo]
    func configure() throws
}

final class StorageService: StorageServiceProtocol {
    
    private var container: ModelContainer!
    private var context: ModelContext!
    
    func insert(repos: [RepositoryInfo]) {
        for repo in repos {
            let storedRepo = StoredRepositoryInfo(name: repo.name, avatarUrl: repo.owner.avatar_url, specification: repo.description)
            context.insert(storedRepo)
        }
        
    }
    
    func configure() throws {
        do {
            container = try ModelContainer.init(for: StoredRepositoryInfo.self)
            context = ModelContext(container)
        } catch {
            throw RepositoryError.containerInitializationFailed("Failed to initialize")
        }
    }
    
    func save() throws {
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
    
    func deleteAll() throws {
        try context.delete(model: StoredRepositoryInfo.self)
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
