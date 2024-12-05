//
//  StoredRepositoryInfo.swift
//  reposList
//
//  Created by Fedor Bebinov on 03.12.2024.
//

import SwiftData

@Model
final class StoredRepositoryInfo {
    var name: String
    var avatarUrl: String
    var specification: String

    init(name: String, avatarUrl: String, specification: String) {
        self.name = name
        self.avatarUrl = avatarUrl
        self.specification = specification
    }
}


