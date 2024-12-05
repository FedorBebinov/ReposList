//
//  RepositoryViewModel.swift
//  reposList
//
//  Created by Fedor Bebinov on 04.12.2024.
//

import Foundation
import Combine

class RepositoryViewModel: ObservableObject {
    
    private let reposFacade: ReposFacadeServiceProtocol
    private let repoTitle: String
    private let avatarUrl: String
    @Published private (set) var errorMessage: String?
    private(set) var repoDescription: String
    let repo: StoredRepositoryInfo
    
    
    init(reposFacade: ReposFacadeServiceProtocol, repo: StoredRepositoryInfo){
        self.reposFacade = reposFacade
        repoTitle = repo.name
        avatarUrl = repo.avatarUrl
        repoDescription = repo.specification
        self.repo = repo
    }
    
    func uploadData(description: String){
        do {
            repo.specification = description
            try reposFacade.save()
        } catch let error as RepositoryError {
            errorMessage = error.description
        } catch {
            errorMessage = "Unexpected error: \(error)"
        }
    }
}
