//
//  UserRepositoryTests.swift
//  AristaPersistenceTests
//
//  Created by Margot Pasquali on 13/11/2024.
//

import XCTest
import CoreData

@testable import AristaPersistence

final class UserRepositoryTests: XCTestCase {

    // MARK: - Helper Methods
    private func emptyEntities(context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        let objects = try! context.fetch(fetchRequest)
        
        for user in objects {
            context.delete(user)
        }
        try! context.save()
    }
    
    @discardableResult
    private func addUser(context: NSManagedObjectContext, firstName: String, lastName: String, passwordHash: String) -> UserEntity {
        let newUser = UserEntity(context: context)
        newUser.firstName = firstName
        newUser.lastName = lastName
        newUser.passwordHash = passwordHash
        newUser.id = UUID()
        try! context.save()
        return newUser
    }
    
    // MARK: - Tests
    
    func test_WhenNoUserIsInDatabase_GetUser_ReturnsNil() {
        let persistenceController = PersistenceController(inMemory: true)
        let repository = UserRepository(context: persistenceController.container.viewContext)
        let user = repository.getUser()
        
        XCTAssertNil(user)
    }

    func test_WhenAddingOneUserInDatabase_GetUser_ReturnsTheUser() {
        let persistenceController = PersistenceController(inMemory: true)
        let firstName = "John"
        let lastName = "Doe"
        let passwordHash = "secureHash"

        addUser(context: persistenceController.container.viewContext, firstName: firstName, lastName: lastName, passwordHash: passwordHash)
        
        let repository = UserRepository(context: persistenceController.container.viewContext)
        let user = repository.getUser()
        
        XCTAssertNotNil(user)
        XCTAssertEqual(user?.firstName, firstName)
        XCTAssertEqual(user?.lastName, lastName)
        XCTAssertEqual(user?.passwordHash, passwordHash)
    }

    func test_WhenAddingMultipleUsersInDatabase_GetUser_ReturnsTheFirstUser() {
        let persistenceController = PersistenceController(inMemory: true)

        // Ajoute plusieurs utilisateurs
        addUser(context: persistenceController.container.viewContext, firstName: "Alice", lastName: "Smith", passwordHash: "hash1")
        addUser(context: persistenceController.container.viewContext, firstName: "Bob", lastName: "Johnson", passwordHash: "hash2")
        
        let repository = UserRepository(context: persistenceController.container.viewContext)
        let user = repository.getUser()
        
        // Vérifie que le premier utilisateur est retourné
        XCTAssertNotNil(user)
        XCTAssertEqual(user?.firstName, "Alice")
        XCTAssertEqual(user?.lastName, "Smith")
        XCTAssertEqual(user?.passwordHash, "hash1")
    }
}
