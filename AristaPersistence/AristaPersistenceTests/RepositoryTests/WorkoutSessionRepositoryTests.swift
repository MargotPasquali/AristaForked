//
//  WorkoutSessionRepositoryTests.swift
//  AristaPersistenceTests
//
//  Created by Margot Pasquali on 12/11/2024.
//

import XCTest
import CoreData

@testable import AristaPersistence

final class WorkoutSessionRepositoryTests: XCTestCase {
    
    // MARK: - Properties
    private var persistenceController: PersistenceController!
    private var context: NSManagedObjectContext!
    
    // MARK: - Setup and Teardown
    override func setUp() {
        super.setUp()
        persistenceController = PersistenceController(inMemory: true)
        context = persistenceController.container.viewContext
    }

    override func tearDown() {
        emptyEntities(context: context)
        persistenceController = nil
        context = nil
        super.tearDown()
    }
    
    // MARK: - Helper Methods
    private func emptyEntities(context: NSManagedObjectContext) {
        let fetchRequest = WorkoutSessionEntity.fetchRequest()
        let objects = try! context.fetch(fetchRequest)
        
        for exercise in objects {
            context.delete(exercise)
        }
        try! context.save()
    }
    
    @discardableResult
    private func addExercice(context: NSManagedObjectContext, category: String, duration: Int, intensity: Int, startDate: Date, userFirstName: String, userLastName: String) -> WorkoutSessionEntity {
        let newUser = UserEntity(context: context)
        newUser.firstName = userFirstName
        newUser.lastName = userLastName
        newUser.passwordHash = "defaultPasswordHash"
        newUser.id = UUID()
        
        let newExercise = WorkoutSessionEntity(context: context)
        newExercise.category = category
        newExercise.duration = Int64(duration)
        newExercise.intensity = Int64(intensity)
        newExercise.start = startDate
        newExercise.user = newUser
        newExercise.id = UUID()
        
        try! context.save()
        return newExercise
    }
    
    // MARK: - Tests
    func test_WhenNoExerciseIsInDatabase_GetExercise_ReturnEmptyList() {
        emptyEntities(context: context)
        
        let repository = WorkoutSessionRepository(context: context)
        let exercises = try! repository.getWorkoutSessions()
        
        XCTAssertTrue(exercises.isEmpty)
    }

    func test_WhenAddingOneExerciseInDatabase_GetExercise_ReturnAListContainingTheExercise() {
        emptyEntities(context: context)
        
        let date = Date()
        addExercice(context: context, category: "Football", duration: 10, intensity: 5, startDate: date, userFirstName: "Eric", userLastName: "Marcus")

        let repository = WorkoutSessionRepository(context: context)
        let exercises = try! repository.getWorkoutSessions()
        
        XCTAssertFalse(exercises.isEmpty)
        XCTAssertEqual(exercises.first?.category, WorkoutSession.Category.football)
        XCTAssertEqual(exercises.first?.duration, 10)
        XCTAssertEqual(exercises.first?.intensity, 5)
        XCTAssertEqual(exercises.first?.start, date)
    }

    func test_WhenAddingMultipleExerciseInDatabase_GetExercise_ReturnAListContainingTheExerciseInTheRightOrder() {
        emptyEntities(context: context)

        let date1 = Date()
        let date2 = Date(timeIntervalSinceNow: -(60*60*24))
        let date3 = Date(timeIntervalSinceNow: -(60*60*24*2))
        
        addExercice(context: context, category: "Football", duration: 10, intensity: 5, startDate: date1, userFirstName: "Erica", userLastName: "Marcusi")
        addExercice(context: context, category: "Running", duration: 120, intensity: 1, startDate: date3, userFirstName: "Eric", userLastName: "Marceau")
        addExercice(context: context, category: "Fitness", duration: 30, intensity: 5, startDate: date2, userFirstName: "Frédéric", userLastName: "Marcus")

        let repository = WorkoutSessionRepository(context: context)
        let exercises = try! repository.getWorkoutSessions()
        
        XCTAssertEqual(exercises.count, 3)
        XCTAssertEqual(exercises[0].category, WorkoutSession.Category.football)
        XCTAssertEqual(exercises[1].category, WorkoutSession.Category.fitness)
        XCTAssertEqual(exercises[2].category, WorkoutSession.Category.running)
    }
}
