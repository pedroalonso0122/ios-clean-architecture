//
//  UserViewModel.swift
//  ApartmentManagementTests
//
//  Created by Pedro Alonso on 2020/9/6.
//  Copyright © 2020 Pedro Alonso. All rights reserved.
//

import XCTest
@testable import ApartmentManagement

class UserViewModelTests: XCTestCase {
    var authViewModel: AuthViewModel!
    
    var viewModel: UserViewModel!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = UserViewModel()
        
        authViewModel = AuthViewModel()
        login()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
    }
    
    func login() {
        let exp = expectation(description: "Check Login Invalid Email")
        
        authViewModel.login(email: "test@mail.com", password: "Pass1234")
        
        authViewModel.state.observe(on: self) { state in
            if state != ActionState.waiting {
                exp.fulfill()
            }
        }
        
        waitForExpectations(timeout: 4.0) {
            error in
            if let _ = error {
                XCTAssert(false, "Timeout while attempting login")
            }
        }
            
    }
    
    // MARK: - Load Test Case
    
    func testLoad() throws {
        let exp = expectation(description: "Check User Load")

        viewModel.load()

        // Assert
        viewModel.state.observe(on: self) { state in
            if state != ActionState.waiting {
                XCTAssertEqual(state, ActionState.success)

                exp.fulfill()
            }            
        }
        
        waitForExpectations(timeout: 5.0) {
            error in
            if let _ = error {
                XCTAssert(false, "Timeout while attempting load")
            }
        }
    }

    // MARK: - Add Test Case

    func testAddEmptyName() throws {
        let exp = expectation(description: "Check Add Empty Name")

        viewModel.add(email: String(format: "test%@@mail.com", DateUtil.instance.getDate()), name: "", password: "Pass1234", role: Role.admin.rawValue)

        // Assert
        viewModel.state.observe(on: self) { state in
            if state != ActionState.waiting {
                XCTAssertEqual(self.viewModel.state.value, ActionState.fail)
                XCTAssertEqual(self.viewModel.error.value, "The name field is required.")

                exp.fulfill()
            }
        }
        
        waitForExpectations(timeout: 4.0) {
            error in
            if let _ = error {
                XCTAssert(false, "Timeout while attempting add")
            }
        }
    }

    func testAddInvalidEmail() throws {
        let exp = expectation(description: "Check Add Invalid Email")

        viewModel.add(email: "a123", name: "Test", password: "Pass1234", role: Role.admin.rawValue)

        // Assert
        viewModel.state.observe(on: self) { state in
            if state != ActionState.waiting {
                XCTAssertEqual(self.viewModel.state.value, ActionState.fail)
                XCTAssertEqual(self.viewModel.error.value, "The email must be a valid email address.")

                exp.fulfill()
            }
        }
        
        waitForExpectations(timeout: 4.0) {
            error in
            if let _ = error {
                XCTAssert(false, "Timeout while attempting add")
            }
        }
    }

    func testAddInvalidPassword() throws {
        let exp = expectation(description: "Check Add Invalid Password")

        viewModel.add(email: String(format: "test%@@mail.com", DateUtil.instance.getDate()), name: "Test", password: "asd", role: Role.admin.rawValue)

        // Assert
        viewModel.state.observe(on: self) { state in
            if state != ActionState.waiting {
                XCTAssertEqual(self.viewModel.state.value, ActionState.fail)
                XCTAssertEqual(self.viewModel.error.value, "The password must be at least 6 characters.")

                exp.fulfill()
            }
        }
        
        waitForExpectations(timeout: 4.0) {
            error in
            if let _ = error {
                XCTAssert(false, "Timeout while attempting add")
            }
        }
    }

    func testAddEmptyRole() throws {
        let exp = expectation(description: "Check Add Empty Role")

        viewModel.add(email: "a124@mail.com", name: "Test", password: "asd", role: "")

        // Assert
        viewModel.state.observe(on: self) { state in
            if state != ActionState.waiting {
                XCTAssertEqual(self.viewModel.state.value, ActionState.fail)
                XCTAssertEqual(self.viewModel.error.value, "The role field is required.")

                exp.fulfill()
            }
        }
        
        waitForExpectations(timeout: 4.0) {
            error in
            if let _ = error {
                XCTAssert(false, "Timeout while attempting add")
            }
        }
    }

    func testAddSameEmail() throws {
        let exp = expectation(description: "Check Add Same Email")

        viewModel.add(email: "admin@mail.com", name: "Test", password: "asd", role: Role.admin.rawValue)

        // Assert
        viewModel.state.observe(on: self) { state in
            if state != ActionState.waiting {
                XCTAssertEqual(self.viewModel.state.value, ActionState.fail)
                XCTAssertEqual(self.viewModel.error.value, "The email has already been taken.")

                exp.fulfill()
            }
        }
        
        waitForExpectations(timeout: 4.0) {
            error in
            if let _ = error {
                XCTAssert(false, "Timeout while attempting add")
            }
        }
    }

    func testAddSuccess() throws {
        let exp = expectation(description: "Check Add Success")

        viewModel.add(email: String(format: "test%@@mail.com", DateUtil.instance.getDate()), name: "Test", password: "Pass1234", role: Role.admin.rawValue)

        // Assert
        viewModel.state.observe(on: self) { state in
            if state != ActionState.waiting {
                XCTAssertEqual(self.viewModel.state.value, ActionState.success)

                exp.fulfill()
            }
        }
        
        waitForExpectations(timeout: 4.0) {
            error in
            if let _ = error {
                XCTAssert(false, "Timeout while attempting add")
            }
        }
    }

    // MARK: - Update Test Case

    func testUpdateEmptyName() throws {
        let exp = expectation(description: "Check Update Empty Name")

        let user = AuthManager.shared.userInfo!
        
        viewModel.update(id: user.id, email: user.email, name: "", password: "Pass1234", role: Role.admin.rawValue)

        // Assert
        viewModel.state.observe(on: self) { state in
            if state != ActionState.waiting {
                XCTAssertEqual(self.viewModel.state.value, ActionState.fail)
                XCTAssertEqual(self.viewModel.error.value, "The name must be a string.")

                exp.fulfill()
            }
        }
        
        waitForExpectations(timeout: 4.0) {
            error in
            if let _ = error {
                XCTAssert(false, "Timeout while attempting update")
            }
        }
    }

    func testUpdateInvalidEmail() throws {
        let exp = expectation(description: "Check Update Invalid Email")

        let user = AuthManager.shared.userInfo!
        
        viewModel.update(id: user.id, email: "b", name: "Pedro Alonso", password: "", role: "")

        // Assert
        viewModel.state.observe(on: self) { state in
            if state != ActionState.waiting {
                XCTAssertEqual(self.viewModel.state.value, ActionState.fail)
                XCTAssertEqual(self.viewModel.error.value, "The email must be a valid email address.")

                exp.fulfill()
            }
        }
        
        waitForExpectations(timeout: 4.0) {
            error in
            if let _ = error {
                XCTAssert(false, "Timeout while attempting update")
            }
        }
    }

    func testUpdateSameEmail() throws {
        let exp = expectation(description: "Check Update Same Email")

        let user = AuthManager.shared.userInfo!
        
        viewModel.update(id: user.id, email: "admin@mail.com", name: user.name, password: "Pass1234", role: Role.admin.rawValue)

        // Assert
        viewModel.state.observe(on: self) { state in
            if state != ActionState.waiting {
                XCTAssertEqual(self.viewModel.state.value, ActionState.fail)
                XCTAssertEqual(self.viewModel.error.value, "The email has already been taken.")

                exp.fulfill()
            }
        }
        
        waitForExpectations(timeout: 4.0) {
            error in
            if let _ = error {
                XCTAssert(false, "Timeout while attempting update")
            }
        }
    }

    func testUpdateEmptyRole() throws {
        let exp = expectation(description: "Check Update Empty Role")

        let user = AuthManager.shared.userInfo!
        
        viewModel.update(id: user.id, email: user.email, name: user.name, password: "Pass1234", role: "")

        // Assert
        viewModel.state.observe(on: self) { state in
            if state != ActionState.waiting {
                XCTAssertEqual(self.viewModel.state.value, ActionState.fail)
                XCTAssertEqual(self.viewModel.error.value, "The role must be a string.")

                exp.fulfill()
            }
        }
        
        waitForExpectations(timeout: 4.0) {
            error in
            if let _ = error {
                XCTAssert(false, "Timeout while attempting update")
            }
        }
    }

    func testUpdateInvalidPassword() throws {
        let exp = expectation(description: "Check Update Invalid Password")

        let user = AuthManager.shared.userInfo!
        
        viewModel.update(id: user.id, email: user.email, name: user.name, password: "a1qwe", role: Role.admin.rawValue)

        // Assert
        viewModel.state.observe(on: self) { state in
            if state != ActionState.waiting {
                XCTAssertEqual(self.viewModel.state.value, ActionState.fail)
                XCTAssertEqual(self.viewModel.error.value, "The password must be at least 6 characters.")

                exp.fulfill()
            }
        }
        
        waitForExpectations(timeout: 4.0) {
            error in
            if let _ = error {
                XCTAssert(false, "Timeout while attempting add")
            }
        }
    }

    func testUpdateSuccess() throws {
        let exp = expectation(description: "Check Update Success")

        let user = AuthManager.shared.userInfo!
        
        viewModel.update(id: user.id, email: user.email, name: user.name, password: "Pass1234", role: Role.admin.rawValue)

        // Assert
        viewModel.state.observe(on: self) { state in
            if state != ActionState.waiting {
                XCTAssertEqual(self.viewModel.state.value, ActionState.success)

                exp.fulfill()
            }
        }
        
        waitForExpectations(timeout: 4.0) {
            error in
            if let _ = error {
                XCTAssert(false, "Timeout while attempting add")
            }
        }
    }

    // MARK: - Delete Test Case

    func testDeleteWrongId() throws {
        let exp = expectation(description: "Check Delete Invalid Id")

        viewModel.delete(id: 100)

        // Assert
        viewModel.state.observe(on: self) { state in
            if state != ActionState.waiting {
                XCTAssertEqual(self.viewModel.state.value, ActionState.fail)
                XCTAssertEqual(self.viewModel.error.value, "Could not find the user")

                exp.fulfill()
            }
        }
        
        waitForExpectations(timeout: 4.0) {
            error in
            if let _ = error {
                XCTAssert(false, "Timeout while attempting delete")
            }
        }
    }

    func testDeleteSuccess() throws {
        let exp = expectation(description: "Check Delete Success")

        viewModel.delete(id: 6)

        // Assert
        viewModel.state.observe(on: self) { state in
            if state != ActionState.waiting {
                XCTAssertEqual(self.viewModel.state.value, ActionState.success)

                exp.fulfill()
            }
        }
        
        waitForExpectations(timeout: 4.0) {
            error in
            if let _ = error {
                XCTAssert(false, "Timeout while attempting delete")
            }
        }
    }
}
