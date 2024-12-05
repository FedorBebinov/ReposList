//
//  RepositoryViewModelTests.swift
//  reposListTests
//
//  Created by Fedor Bebinov on 05.12.2024.
//

import XCTest
import Combine
@testable import reposList

final class RepositoryViewModelTests: XCTestCase {

    private var viewModel: RepositoryViewModel!
    private var mockReposFacade: MockReposFacadeService!
    private var testRepo: StoredRepositoryInfo!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockReposFacade = MockReposFacadeService()
        testRepo = StoredRepositoryInfo(name: "TestRepo", avatarUrl: "https://example.com/avatar.png", specification: "Initial description")
        viewModel = RepositoryViewModel(reposFacade: mockReposFacade, repo: testRepo)
        cancellables = []
    }

    override func tearDown() {
        viewModel = nil
        mockReposFacade = nil
        testRepo = nil
        cancellables = nil
        super.tearDown()
    }

    func testUploadDataSuccess() {
        let newDescription = "Updated description"
        mockReposFacade.shouldThrowError = false

        viewModel.uploadData(description: newDescription)

        XCTAssertEqual(testRepo.specification, newDescription)
        XCTAssertNil(viewModel.errorMessage)
    }

    func testUploadDataError() {
        let newDescription = "Updated description"
        mockReposFacade.shouldThrowError = true

        viewModel.uploadData(description: newDescription)

        XCTAssertEqual(testRepo.specification, newDescription)
        XCTAssertEqual(viewModel.errorMessage, RepositoryError.storageError("Save error").description)
    }
}

