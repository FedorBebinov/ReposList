//
//  RepositoryModule.swift
//  reposList
//
//  Created by Fedor Bebinov on 04.12.2024.
//

import UIKit

struct RepositoryModule {
    static func build(reposFacade: ReposFacadeServiceProtocol, repo: StoredRepositoryInfo, repoIndex: Int) -> UIViewController{
        RepositoryViewController(viewModel: RepositoryViewModel(reposFacade: reposFacade, repo: repo, repoIndex: repoIndex))
    }
}
