//
//  ListViewModelTests.swift
//  reposListTests
//
//  Created by Fedor Bebinov on 04.12.2024.
//

import XCTest
import Foundation
@testable import reposList

class MockReposFacadeService: ReposFacadeServiceProtocol {
    
    var mockRepos: [StoredRepositoryInfo] = []
    var shouldThrowError = false
    var fetchPage: Int = 1

    func getRepos(page: Int) async throws -> [StoredRepositoryInfo] {
        if shouldThrowError {
            throw RepositoryError.storageError("Can't get repo")
        }
        fetchPage = page
        return mockRepos
    }

    func getLocalRepos() throws -> [StoredRepositoryInfo] {
        if shouldThrowError {
            throw RepositoryError.storageError("Can't get repo")
        }
        return mockRepos
    }
    
    func deleteRepo(index: Int) throws {
        if shouldThrowError {
            throw RepositoryError.storageError("Delete error")
        }
        mockRepos.remove(at: index)
    }
    
    func save() throws {
        if shouldThrowError {
            throw RepositoryError.storageError("Save error")
        }
    }
    
    func configure() throws {
        
    }
}

final class ListViewModelTests: XCTestCase {

    var viewModel: ListViewModel!
    var mockService: MockReposFacadeService!
    
    override func setUp() {
        super.setUp()
        mockService = MockReposFacadeService()
        viewModel = ListViewModel(reposFacade: mockService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }
    
    func testFetchDataSuccess() async {
        let expectedRepos = [StoredRepositoryInfo(name: "Repo1", avatarUrl: "url1", specification: "spec1"), StoredRepositoryInfo(name: "Repo2", avatarUrl: "url2", specification: "spec2")]
        mockService.mockRepos = expectedRepos

        viewModel.fetchData()

        XCTAssertEqual(viewModel.repos, expectedRepos)
        XCTAssertEqual(mockService.fetchPage, 1) // Проверим, что страница увеличилась
        XCTAssertFalse(viewModel.isPaginating)
    }

    func testRefreshReposSuccess() {
        // Установим мок данных
        let expectedRepos = [StoredRepositoryInfo(name: "Repo1", avatarUrl: "url1", specification: "spec1")]
        mockService.mockRepos = expectedRepos

        viewModel.refreshRepos()
        XCTAssertEqual(viewModel.repos, expectedRepos)
    }

    func testDeleteRepo() {
        mockService.mockRepos = [StoredRepositoryInfo(name: "Repo1", avatarUrl: "url1", specification: "spec1"), StoredRepositoryInfo(name: "Repo2", avatarUrl: "url2", specification: "spec2")]
        
        // Вызовем метод deleteRepo
        viewModel.fetchData()
        viewModel.deleteRepo(index: 0)
        
        XCTAssertEqual(viewModel.repos.count, 1)
        XCTAssertEqual(viewModel.repos[0].name, "Repo2")
    }
    
    func testFetchDataError() async {
        mockService.shouldThrowError = true
        
        viewModel.fetchData()
        
        XCTAssertTrue(viewModel.repos.isEmpty)

    }
    
    func testRefreshReposError() {
        mockService.shouldThrowError = true
        
        // Вызовем метод uploadData
        viewModel.refreshRepos()
        XCTAssertEqual(viewModel.errorMessage, RepositoryError.storageError("Can't get repo").description)
    }
    
    func testDeleteRepoError() {
        mockService.shouldThrowError = true
        
        viewModel.deleteRepo(index: 1)
        XCTAssertEqual(viewModel.errorMessage, RepositoryError.storageError("Delete error").description)
    }
    
    func testFetchdDataError() {
        mockService.shouldThrowError = true
        
        viewModel.fetchData()
        XCTAssertEqual(viewModel.errorMessage, RepositoryError.storageError("Can't get repo").description)
    }
}
