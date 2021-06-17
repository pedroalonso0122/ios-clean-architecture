//
//  ApartmentViewModelTests.swift
//  ApartmentManagementTests
//
//  Created by Pedro Alonso on 2020/11/3.
//  Copyright © 2020 Pedro Alonso. All rights reserved.
//

import XCTest
@testable import ApartmentManagement

class ApartmentViewModelTests: XCTestCase {
    
    var authViewModel: AuthViewModel!
    
    var viewModel: ApartmentViewModel!
    
    let testId: Int = 7
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = ApartmentViewModel()
        
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
        let exp = expectation(description: "Check Apartment Load")

        viewModel.load(country: "United States", locality: "New York", minPrice: "", maxPrice: "", minAreaSize: "", maxAreaSize: "", minNumberRooms: "", maxNumberRooms: "")

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

        guard let imageData = UIImage(named: "TestHouse")?.pngData() else { return }
        
        viewModel.add(name: "", description: "description", floorAreaSize: 8000, price: 5000, numberOfRooms: 4, country: "United States", locality: "New York", address: "201 E 40", latitude: 40.5, longitude: -73.5, image: imageData, status: RentStatus.available.rawValue)

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
    
    func testAddEmptyDescription() throws {
        let exp = expectation(description: "Check Add Empty Description")

        guard let imageData = UIImage(named: "TestHouse")?.pngData() else { return }
        
        viewModel.add(name: "Test", description: "", floorAreaSize: 8000, price: 5000, numberOfRooms: 4, country: "United States", locality: "New York", address: "201 E 40", latitude: 40.5, longitude: -73.5, image: imageData, status: RentStatus.available.rawValue)

        // Assert
        viewModel.state.observe(on: self) { state in
            if state != ActionState.waiting {
                XCTAssertEqual(self.viewModel.state.value, ActionState.fail)
                XCTAssertEqual(self.viewModel.error.value, "The description field is required.")

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
    
    
    func testAddEmptyCountry() throws {
        let exp = expectation(description: "Check Add Empty Country")

        guard let imageData = UIImage(named: "TestHouse")?.pngData() else { return }
        
        viewModel.add(name: "Test", description: "description", floorAreaSize: 8000, price: 5000, numberOfRooms: 4, country: "", locality: "New York", address: "201 E 40", latitude: 40.5, longitude: -73.5, image: imageData, status: RentStatus.available.rawValue)

        // Assert
        viewModel.state.observe(on: self) { state in
            if state != ActionState.waiting {
                XCTAssertEqual(self.viewModel.state.value, ActionState.fail)
                XCTAssertEqual(self.viewModel.error.value, "The country field is required.")

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
    
    func testAddEmptyLocality() throws {
        let exp = expectation(description: "Check Add Empty Locality")

        guard let imageData = UIImage(named: "TestHouse")?.pngData() else { return }
        
        viewModel.add(name: "Test", description: "description", floorAreaSize: 8000, price: 5000, numberOfRooms: 4, country: "United States", locality: "", address: "201 E 40", latitude: 40.5, longitude: -73.5, image: imageData, status: RentStatus.available.rawValue)

        // Assert
        viewModel.state.observe(on: self) { state in
            if state != ActionState.waiting {
                XCTAssertEqual(self.viewModel.state.value, ActionState.fail)
                XCTAssertEqual(self.viewModel.error.value, "The locality field is required.")

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
    
    func testAddEmptyAddress() throws {
        let exp = expectation(description: "Check Add Empty Address")

        guard let imageData = UIImage(named: "TestHouse")?.pngData() else { return }
        
        viewModel.add(name: "Test", description: "description", floorAreaSize: 8000, price: 5000, numberOfRooms: 4, country: "United States", locality: "New York", address: "", latitude: 40.5, longitude: -73.5, image: imageData, status: RentStatus.available.rawValue)

        // Assert
        viewModel.state.observe(on: self) { state in
            if state != ActionState.waiting {
                XCTAssertEqual(self.viewModel.state.value, ActionState.fail)
                XCTAssertEqual(self.viewModel.error.value, "The address field is required.")

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
        let exp = expectation(description: "Check Add Empty Name")

        guard let imageData = UIImage(named: "TestHouse")?.pngData() else { return }
        
        viewModel.add(name: "Test", description: "description", floorAreaSize: 8000, price: 5000, numberOfRooms: 4, country: "United States", locality: "New York", address: "201 E 40", latitude: 40.5, longitude: -73.5, image: imageData, status: RentStatus.available.rawValue)

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
        
        guard let imageData = UIImage(named: "TestHouse")?.pngData() else { return }
        
        viewModel.update(id: testId, realtorId: user.id, name: "", description: "description", floorAreaSize: 8000, price: 5000, numberOfRooms: 4, country: "United States", locality: "New York", address: "201 E 40", latitude: 40.5, longitude: -73.5, image: imageData, status: RentStatus.available.rawValue)

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
    
    func testUpdateEmptyDescription() throws {
        let exp = expectation(description: "Check Update Empty Description")

        let user = AuthManager.shared.userInfo!
        
        guard let imageData = UIImage(named: "TestHouse")?.pngData() else { return }
        
        viewModel.update(id: testId, realtorId: user.id, name: "Test", description: "", floorAreaSize: 8000, price: 5000, numberOfRooms: 4, country: "United States", locality: "New York", address: "201 E 40", latitude: 40.5, longitude: -73.5, image: imageData, status: RentStatus.available.rawValue)

        // Assert
        viewModel.state.observe(on: self) { state in
            if state != ActionState.waiting {
                XCTAssertEqual(self.viewModel.state.value, ActionState.fail)
                XCTAssertEqual(self.viewModel.error.value, "The description field is required.")

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
    
    
    func testUpdateEmptyCountry() throws {
        let exp = expectation(description: "Check Update Empty Country")

        let user = AuthManager.shared.userInfo!
        
        guard let imageData = UIImage(named: "TestHouse")?.pngData() else { return }
        
        viewModel.update(id: testId, realtorId: user.id, name: "Test", description: "description", floorAreaSize: 8000, price: 5000, numberOfRooms: 4, country: "", locality: "New York", address: "201 E 40", latitude: 40.5, longitude: -73.5, image: imageData, status: RentStatus.available.rawValue)

        // Assert
        viewModel.state.observe(on: self) { state in
            if state != ActionState.waiting {
                XCTAssertEqual(self.viewModel.state.value, ActionState.fail)
                XCTAssertEqual(self.viewModel.error.value, "The country field is required.")

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
    
    func testUpdateEmptyLocality() throws {
        let exp = expectation(description: "Check Update Empty Locality")

        let user = AuthManager.shared.userInfo!
        
        guard let imageData = UIImage(named: "TestHouse")?.pngData() else { return }
        
        viewModel.update(id: testId, realtorId: user.id, name: "Test", description: "description", floorAreaSize: 8000, price: 5000, numberOfRooms: 4, country: "United States", locality: "", address: "201 E 40", latitude: 40.5, longitude: -73.5, image: imageData, status: RentStatus.available.rawValue)

        // Assert
        viewModel.state.observe(on: self) { state in
            if state != ActionState.waiting {
                XCTAssertEqual(self.viewModel.state.value, ActionState.fail)
                XCTAssertEqual(self.viewModel.error.value, "The locality field is required.")

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
    
    func testUpdateEmptyAddress() throws {
        let exp = expectation(description: "Check Update Empty Address")

        let user = AuthManager.shared.userInfo!
        
        guard let imageData = UIImage(named: "TestHouse")?.pngData() else { return }
        
        viewModel.update(id: testId, realtorId: user.id, name: "Test", description: "description", floorAreaSize: 8000, price: 5000, numberOfRooms: 4, country: "United States", locality: "New York", address: "", latitude: 40.5, longitude: -73.5, image: imageData, status: RentStatus.available.rawValue)

        // Assert
        viewModel.state.observe(on: self) { state in
            if state != ActionState.waiting {
                XCTAssertEqual(self.viewModel.state.value, ActionState.fail)
                XCTAssertEqual(self.viewModel.error.value, "The address field is required.")

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
        let exp = expectation(description: "Check Add Empty Name")

        let user = AuthManager.shared.userInfo!
        
        guard let imageData = UIImage(named: "TestHouse")?.pngData() else { return }
        
        viewModel.update(id: testId, realtorId: user.id, name: "Test", description: "description", floorAreaSize: 8000, price: 5000, numberOfRooms: 4, country: "United States", locality: "New York", address: "201 E 40", latitude: 40.5, longitude: -73.5, image: imageData, status: RentStatus.available.rawValue)

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

        viewModel.delete(id: 0)

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

        viewModel.delete(id: testId)

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
