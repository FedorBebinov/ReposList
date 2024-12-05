//
//  ListViewModel.swift
//  reposList
//
//  Created by Fedor Bebinov on 02.12.2024.
//

import Foundation
import Combine

final class ListViewModel: ObservableObject {
    
    private var page = 1
    private let reposFacade: ReposFacadeServiceProtocol
    @Published private(set) var repos: [StoredRepositoryInfo] = []
    @Published private(set) var isPaginating = false
    @Published private(set) var errorMessage: String?
    
    init(reposFacade: ReposFacadeServiceProtocol){
        self.reposFacade = reposFacade
    }
    
    func fetchData(){
        if isPaginating {
            return
        }
        isPaginating = true
        Task {
            do {
                repos = try await reposFacade.getRepos(page: page)
                page += 1
                isPaginating = false
            } catch let error as RepositoryError {
                errorMessage = error.description
                isPaginating = false
            } catch {
                errorMessage = "Unexpected error: \(error)"
                isPaginating = false
            }
        }
    }
    
    func refreshRepos(){
        do{
            repos = try reposFacade.getLocalRepos()
        } catch let error as RepositoryError {
            errorMessage = error.description
        } catch {
            errorMessage = "Unexpected error: \(error)"
        }
    }
    
    func deleteRepo(index: Int) {
        do {
            try reposFacade.deleteRepo(index: index)
        } catch  let error as RepositoryError {
            errorMessage = error.description
        } catch {
            errorMessage = "Unexpected error: \(error)"
        }
    }
}
