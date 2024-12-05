//
//  RepositoryViewModel.swift
//  reposList
//
//  Created by Fedor Bebinov on 04.12.2024.
//

import Foundation
import Combine

final class RepositoryViewModel: ObservableObject {
    
    private let reposFacade: ReposFacadeServiceProtocol
    @Published private (set) var errorMessage: String?
    let repo: StoredRepositoryInfo
    
    
    init(reposFacade: ReposFacadeServiceProtocol, repo: StoredRepositoryInfo){
        self.reposFacade = reposFacade
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
