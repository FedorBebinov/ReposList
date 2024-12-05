//
//  ListModule.swift
//  reposList
//
//  Created by Fedor Bebinov on 02.12.2024.
//

import UIKit

struct ListModule {
    static func build(reposFacade: ReposFacadeServiceProtocol) -> UIViewController{
        ListViewController(viewModel: ListViewModel(reposFacade: reposFacade))
    }
}
