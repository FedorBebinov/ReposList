//
//  ListViewModelTests.swift
//  reposListTests
//
//  Created by Fedor Bebinov on 04.12.2024.
//

import XCTest
import Foundation

/*class MockReposFacadeService: ReposFacadeServiceProtocol {
    var mockRepos: [StoredRepositoryInfo] = []
    var shouldThrowError = false
    var fetchPage: Int = 1

    func getRepos(page: Int) async throws -> [StoredRepositoryInfo] {
        if shouldThrowError {
            throw NSError(domain: "FetchError", code: 1, userInfo: nil)
        }
        fetchPage = page
        return mockRepos
    }

    func getLocalRepos() throws -> [StoredRepositoryInfo] {
        if shouldThrowError {
            throw NSError(domain: "FetchError", code: 1, userInfo: nil)
        }
        return mockRepos
    }
    
    func deleteRepo(index: Int) throws {
        if shouldThrowError {
            throw NSError(domain: "DeleteError", code: 1, userInfo: nil)
        }
        mockRepos.remove(at: index)
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
        // Установим мок данных
        let expectedRepos = [StoredRepositoryInfo(id: 1, name: "Repo1"), StoredRepositoryInfo(id: 2, name: "Repo2")]
        mockService.mockRepos = expectedRepos

        // Вызовем метод fetchData
        await viewModel.fetchData()

        // Проверим, что repos обновились
        XCTAssertEqual(viewModel.repos, expectedRepos)
        XCTAssertEqual(mockService.fetchPage, 1) // Проверим, что страница увеличилась
        XCTAssertFalse(viewModel.isPaginating)
    }

    func testUploadDataSuccess() {
        // Установим мок данных
        let expectedRepos = [StoredRepositoryInfo(id: 3, name: "Repo3")]
        mockService.mockRepos = expectedRepos

        // Вызовем метод uploadData
        do {
            try viewModel.uploadData()
            XCTAssertEqual(viewModel.repos, expectedRepos)
        } catch {
            XCTFail("uploadData failed with error: \(error)")
        }
    }

    func testDeleteRepo() {
        // Установим мок данных
        mockService.mockRepos = [StoredRepositoryInfo(id: 1, name: "Repo1"), StoredRepositoryInfo(id: 2, name: "Repo2")]
        
        // Вызовем метод deleteRepo
        viewModel.deleteRepo(index: 0)
        
        // Проверим, что был удален правильный элемент
        XCTAssertEqual(viewModel.repos.count, 1)
        XCTAssertEqual(viewModel.repos[0].name, "Repo2")
    }
    
    func testFetchDataError() async {
        mockService.shouldThrowError = true
        
        // Вызовем метод fetchData
        await viewModel.fetchData()
        
        // Убедимся, что repos не обновился
        XCTAssertTrue(viewModel.repos.isEmpty)
        XCTAssertFalse(viewModel.isPaginating)
    }
    
    func testUploadDataError() {
        mockService.shouldThrowError = true
        
        // Вызовем метод uploadData
        XCTAssertThrowsError(try viewModel.uploadData()) { error in
            XCTAssertEqual((error as NSError).domain, "FetchError")
        }
    }
    
    func testDeleteRepoError() {
        // Установим мок данных
        mockService.mockRepos = [StoredRepositoryInfo(id: 1, name: "Repo1")]

        // Установим флаг для генерации ошибки
        mockService.shouldThrowError = true
        
        // Проверим, что метод deleteRepo вызывает ошибку
        XCTAssertThrowsError(try viewModel.deleteRepo(index: 0)) { error in
            XCTAssertEqual((error as NSError).domain, "DeleteError")
        }
    }
}*/
