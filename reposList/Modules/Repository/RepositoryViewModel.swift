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
    private let repoIndex: Int
    private let repoTitle: String
    private let avatarUrl: String
    @Published private (set) var errorMessage: String = ""
    private(set) var repoDescription: String
    let repo: StoredRepositoryInfo
    
    
    init(reposFacade: ReposFacadeServiceProtocol, repo: StoredRepositoryInfo, repoIndex: Int){
        self.reposFacade = reposFacade
        repoTitle = repo.name
        avatarUrl = repo.avatarUrl
        repoDescription = repo.specification
        self.repo = repo
        self.repoIndex = repoIndex
    }
    
    func uploadData(description: String){
        do {
            try reposFacade.updateDescription(index: repoIndex, descriptionText: description)
        } catch let error as RepositoryError {
            errorMessage = error.description
        } catch {
            errorMessage = "Unexpected error: \(error)"
        }
    }
}
