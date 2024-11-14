//
//  AddExerciseViewModelTests.swift
//  AristaTests
//
//  Created by Margot Pasquali on 14/11/2024.
//

import XCTest
import CoreData
import Combine
import AristaPersistence

@testable import Arista

final class AddExerciseViewModelTests: XCTestCase {
    
    private var persistenceController: PersistenceController!
    private var context: NSManagedObjectContext!
    
    private var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        persistenceController = PersistenceController(inMemory: true)
        context = persistenceController.container.viewContext
    }
    
    override func tearDown() {
        emptyEntities(context: context)
        persistenceController = nil
        context = nil
        cancellables.removeAll()
    }
    
    // MARK: - Helper Methods
    
    private func emptyEntities(context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<WorkoutSessionEntity> = WorkoutSessionEntity.fetchRequest()
        let objects = try! context.fetch(fetchRequest)
        for exercise in objects {
            context.delete(exercise)
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
    
    func test_WhenInitialized_DefaultCategoryIsFitness() {
        let viewModel = AddExerciseViewModel(context: context)
        XCTAssertEqual(viewModel.category, .fitness)
    }
    
    func test_WhenNoUserInDatabase_AddExercise_ReturnsFalse() {
        let viewModel = AddExerciseViewModel(context: context)
        
        let expectation = XCTestExpectation(description: "onExerciseAdded should not be called")
        expectation.isInverted = true // Ne doit pas être rempli, car onExerciseAdded ne doit pas être appelé
        
        let result = viewModel.addExercise {
            expectation.fulfill()
        }
        
        XCTAssertFalse(result)
        wait(for: [expectation], timeout: 1)
    }
    
    func test_WhenUserExists_AddExercise_ReturnsTrueAndAddsWorkout() {
        addUser(context: context, firstName: "John", lastName: "Doe", passwordHash: "hash")
        
        let viewModel = AddExerciseViewModel(context: context)
        viewModel.category = .football
        viewModel.duration = 60
        viewModel.intensity = 7
        viewModel.start = Date()
        
        let expectation = XCTestExpectation(description: "onExerciseAdded should be called")
        
        let result = viewModel.addExercise {
            expectation.fulfill()
        }
        
        XCTAssertTrue(result)
        
        // Vérification dans CoreData pour s'assurer que l'exercice est bien ajouté
        let fetchRequest: NSFetchRequest<WorkoutSessionEntity> = WorkoutSessionEntity.fetchRequest()
        let exercises = try! context.fetch(fetchRequest)
        
        XCTAssertEqual(exercises.count, 1)
        XCTAssertEqual(exercises.first?.category, "Football")
        XCTAssertEqual(exercises.first?.duration, 60)
        XCTAssertEqual(exercises.first?.intensity, 7)
        XCTAssertEqual(exercises.first?.user?.firstName, "John")
        
        wait(for: [expectation], timeout: 1)
    }
}
