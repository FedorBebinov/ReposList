//
//  RepositoryError.swift
//  reposList
//
//  Created by Fedor Bebinov on 05.12.2024.
//

import Foundation

enum RepositoryError: Error, CustomStringConvertible {
    case networkError(Error)
    case decodingError(Error)
    case storageError(String)
    case containerInitializationFailed(String)
    case invalidURL(String)
    case notFound(String)

    var description: String {
        switch self {
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"
        case .storageError(let message):
            return "Storage error: \(message)"
        case .containerInitializationFailed(let message):
            return "Ошибка инициализации контейнера: \(message)"
        case .invalidURL(let url):
            return "Invalid URL: \(url)"
        case .notFound(let resource):
            return "\(resource) not found."
        }
    }
}
