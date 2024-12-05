//
//  RepositoryInfo.swift
//  reposList
//
//  Created by Fedor Bebinov on 01.12.2024.
//

import Foundation

struct RepositoryInfo: Decodable {
    let name: String
    let owner: Owner
    let description: String
}
