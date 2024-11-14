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
    
    private func emptyEntities(context: NSManagedObjectContext) {
        let fetchRequest = WorkoutSessionEntity.fetchRequest()
        let objects = try! context.fetch(fetchRequest)
        
        for exercise in objects {
            context.delete(exercise)
        }
        try! context.save()
    }
    
    private func addExercice(context: NSManagedObjectContext, category: String, duration: Int, intensity: Int, startDate: Date, userFirstName: String, userLastName: String) {
        let newUser = UserEntity(context: context)
        newUser.firstName = userFirstName
        newUser.lastName = userLastName
        newUser.passwordHash = "defaultPasswordHash"
        newUser.id = UUID()
        try! context.save()
        
        let newExercise = WorkoutSessionEntity(context: context)
        
        newExercise.category = category
        newExercise.duration = Int64(duration)
        newExercise.intensity = Int64(intensity)
        newExercise.start = startDate
        newExercise.user = newUser
        newExercise.id = UUID()
        
        try! context.save()
    }
    
    func test_WhenNoExerciseIsInDatabase_GetExercise_ReturnEmptyList() {
        // Clean manually all data
        let persistenceController = PersistenceController(inMemory: true)
        emptyEntities(context: persistenceController.container.viewContext)

        let data = WorkoutSessionRepository(context: persistenceController.container.viewContext)
        let exercises = try! data.getWorkoutSessions()

        XCTAssert(exercises.isEmpty == true)
    }

    func test_WhenAddingOneExerciseInDatabase_GetExercise_ReturnAListContainingTheExercise() {
        // Clean manually all data
        let persistenceController = PersistenceController(inMemory: true)
        emptyEntities(context: persistenceController.container.viewContext)

        let date = Date()
        addExercice(context: persistenceController.container.viewContext, category: "Football", duration: 10, intensity: 5, startDate: date, userFirstName: "Eric", userLastName: "Marcus")

        let data = WorkoutSessionRepository(context: persistenceController.container.viewContext)
        let exercises = try! data.getWorkoutSessions()

        XCTAssert(exercises.isEmpty == false)
        XCTAssert(exercises.first?.category == WorkoutSession.Category.football) // Compare avec l'enum
        XCTAssert(exercises.first?.duration == 10)
        XCTAssert(exercises.first?.intensity == 5)
        XCTAssert(exercises.first?.start == date)
    }

    func test_WhenAddingMultipleExerciseInDatabase_GetExercise_ReturnAListContainingTheExerciseInTheRightOrder() {
        // Clean manually all data
        let persistenceController = PersistenceController(inMemory: true)
        emptyEntities(context: persistenceController.container.viewContext)

        let date1 = Date()
        let date2 = Date(timeIntervalSinceNow: -(60*60*24))
        let date3 = Date(timeIntervalSinceNow: -(60*60*24*2))

        addExercice(context: persistenceController.container.viewContext,
                    category: "Football",
                    duration: 10,
                    intensity: 5,
                    startDate: date1,
                    userFirstName: "Erica",
                    userLastName: "Marcusi")
        addExercice(context: persistenceController.container.viewContext,
                    category: "Running",
                    duration: 120,
                    intensity: 1,
                    startDate: date3,
                    userFirstName: "Erice",
                    userLastName: "Marceau")
        addExercice(context: persistenceController.container.viewContext,
                    category: "Fitness",
                    duration: 30,
                    intensity: 5,
                    startDate: date2,
                    userFirstName: "Fréderic",
                    userLastName: "Marcus")

        let data = WorkoutSessionRepository(context: persistenceController.container.viewContext)
        let exercises = try! data.getWorkoutSessions()

        XCTAssertEqual(exercises.count, 3)
        XCTAssertEqual(exercises[0].category, WorkoutSession.Category.football)
        XCTAssertEqual(exercises[1].category, WorkoutSession.Category.fitness)
        XCTAssertEqual(exercises[2].category, WorkoutSession.Category.running)
    }

}
