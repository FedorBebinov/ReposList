//
//  RequestInfo.swift
//  reposList
//
//  Created by Fedor Bebinov on 01.12.2024.
//

import Foundation

struct RequestInfo: Decodable {
    let total_count: Int
    let incomplete_results: Bool
    let items: [RepositoryInfo]
}
