//
//  UserDataViewModelTests.swift
//  AristaTests
//
//  Created by Margot Pasquali on 14/11/2024.
//

import XCTest
import CoreData
import AristaPersistence

@testable import Arista

final class UserDataViewModelTests: XCTestCase {
    
    private var persistenceController: PersistenceController!
    private var context: NSManagedObjectContext!
    
    override func setUp() {
        persistenceController = PersistenceController(inMemory: true)
        context = persistenceController.container.viewContext
    }
    
    override func tearDown() {
        emptyEntities(context: context)
        persistenceController = nil
        context = nil
    }
    
    private func emptyEntities(context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        let objects = try! context.fetch(fetchRequest)
        
        for user in objects {
            context.delete(user)
        }
        try! context.save()
    }
    
    @discardableResult
    private func addUser(firstName: String, lastName: String, passwordHash: String) -> UserEntity {
        let newUser = UserEntity(context: context)
        newUser.firstName = firstName
        newUser.lastName = lastName
        newUser.passwordHash = passwordHash
        newUser.id = UUID()
        try! context.save()
        return newUser
    }
    
    func test_WhenNoUserInDatabase_FetchUserData_UsesDefaultValues() {
        let viewModel = UserDataViewModel(context: context)
        
        XCTAssertEqual(viewModel.firstName, "Invité", "Expected default firstName to be 'Invité' when no user is in database")
        XCTAssertEqual(viewModel.lastName, "Utilisateur", "Expected default lastName to be 'Utilisateur' when no user is in database")
    }

    func test_WhenUserExists_FetchUserData_UpdatesPublishedProperties() {
        addUser(firstName: "John", lastName: "Doe", passwordHash: "hash123")
        
        let viewModel = UserDataViewModel(context: context)
        
        XCTAssertEqual(viewModel.firstName, "John", "Expected firstName to be 'John' after fetching user data")
        XCTAssertEqual(viewModel.lastName, "Doe", "Expected lastName to be 'Doe' after fetching user data")
    }

    func test_WhenMultipleUsersExist_FetchUserData_ReturnsFirstUser() {
        addUser(firstName: "Alice", lastName: "Smith", passwordHash: "hash1")
        addUser(firstName: "Bob", lastName: "Johnson", passwordHash: "hash2")
        
        let viewModel = UserDataViewModel(context: context)
        
        XCTAssertEqual(viewModel.firstName, "Alice", "Expected firstName to be 'Alice' for the first user in database")
        XCTAssertEqual(viewModel.lastName, "Smith", "Expected lastName to be 'Smith' for the first user in database")
    }
}
