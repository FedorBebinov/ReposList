//
//  ReposFacadeServiceTests.swift
//  reposListTests
//
//  Created by Fedor Bebinov on 05.12.2024.
//

import XCTest
@testable import reposList

// Mock Network Service
class MockNetworkService: NetworkServiceProtocol {
    var mockRepos: [RepositoryInfo] = []
    var shouldThrowError: Bool = false

    func getRepos(page: Int) async throws -> [RepositoryInfo] {
        if shouldThrowError {
            throw RepositoryError.networkError(URLError(.notConnectedToInternet))
        }
        return mockRepos
    }
}

// Mock Storage Service
class MockStorageService: StorageServiceProtocol {
    var mockStoredRepos: [StoredRepositoryInfo] = []
    var shouldThrowError: Bool = false

    func insert(repos: [RepositoryInfo]) {
        for repo in repos {
            mockStoredRepos.append(StoredRepositoryInfo(name: repo.name, avatarUrl: repo.owner.avatar_url, specification: repo.description))
        }
    }

    func save() throws {
        if shouldThrowError {
            throw RepositoryError.storageError("Save failed")
        }
    }

    func delete(index: Int) throws {
        if shouldThrowError || index >= mockStoredRepos.count {
            throw RepositoryError.storageError("Delete failed")
        }
        mockStoredRepos.remove(at: index)
    }

    func deleteAll() throws {
        if shouldThrowError {
            throw RepositoryError.storageError("Delete all failed")
        }
        mockStoredRepos.removeAll()
    }

    func allRepos() throws -> [StoredRepositoryInfo] {
        if shouldThrowError {
            throw RepositoryError.storageError("Fetch failed")
        }
        return mockStoredRepos
    }
    func configure() throws {
        
    }
}

final class ReposFacadeServiceTests: XCTestCase {
    var mockNetworkService: MockNetworkService!
    var mockStorageService: MockStorageService!
    var facadeService: ReposFacadeService!

    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        mockStorageService = MockStorageService()
        facadeService = ReposFacadeService(networkService: mockNetworkService, strorageService: mockStorageService)
    }

    override func tearDown() {
        mockNetworkService = nil
        mockStorageService = nil
        facadeService = nil
        super.tearDown()
    }

    func testGetReposSuccess() async throws {
        let mockRepo = RepositoryInfo(name: "Repo1", owner: Owner(avatar_url: "ava1"), description: "desc1")
        mockNetworkService.mockRepos = [mockRepo]

        let repos = try await facadeService.getRepos(page: 1)

        XCTAssertEqual(repos.count, 1)
        XCTAssertEqual(repos.first?.name, "Repo1")
        XCTAssertEqual(mockStorageService.mockStoredRepos.count, 1)
    }

    func testGetReposNetworkError() async {
        mockNetworkService.shouldThrowError = true

        do{ 
            _ = try await facadeService.getRepos(page: 1)
        }catch {
            XCTAssertTrue(error is RepositoryError)
        }
        
    }

    func testSaveSuccess() throws {
        XCTAssertNoThrow(try facadeService.save())
    }

    func testSaveError() throws {
        mockStorageService.shouldThrowError = true

        XCTAssertThrowsError(try facadeService.save()) { error in
            XCTAssertTrue(error is RepositoryError)
        }
    }

    func testGetLocalReposSuccess() throws {
        let storedRepo = StoredRepositoryInfo(name: "StoredRepo", avatarUrl: "url", specification: "spec")
        mockStorageService.mockStoredRepos = [storedRepo]

        let repos = try facadeService.getLocalRepos()

        XCTAssertEqual(repos.count, 1)
        XCTAssertEqual(repos.first?.name, "StoredRepo")
    }

    func testDeleteRepoSuccess() throws {
        let storedRepo = StoredRepositoryInfo(name: "StoredRepo", avatarUrl: "url", specification: "spec")
        mockStorageService.mockStoredRepos = [storedRepo]

        try facadeService.deleteRepo(index: 0)

        XCTAssertTrue(mockStorageService.mockStoredRepos.isEmpty)
    }

    func testDeleteRepoError() throws {
        mockStorageService.shouldThrowError = true

        XCTAssertThrowsError(try facadeService.deleteRepo(index: 0)) { error in
            XCTAssertTrue(error is RepositoryError)
        }
    }
}

