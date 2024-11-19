//
//  EntitiesTransformationToModelsTests.swift
//  AristaPersistenceTests
//
//  Created by Margot Pasquali on 19/11/2024.
//

import XCTest
import CoreData
@testable import AristaPersistence

final class EntitiesTransformationToModelsTests: XCTestCase {
    
    private var persistenceController: PersistenceController!
    private var context: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        persistenceController = PersistenceController(inMemory: true)
        context = persistenceController.container.viewContext
    }
    
    override func tearDown() {
        context = nil
        persistenceController = nil
        super.tearDown()
    }
    
    // MARK: - Helper Methods
    
    @discardableResult
    private func createUser(firstName: String, lastName: String, passwordHash: String) -> UserEntity {
        let user = UserEntity(context: context)
        user.id = UUID()
        user.firstName = firstName
        user.lastName = lastName
        user.passwordHash = passwordHash
        user.exercises = NSSet()
        user.sleeps = NSSet()
        try! context.save()
        return user
    }

    @discardableResult
    private func createWorkoutSession(user: UserEntity, category: String, duration: Int64, intensity: Int64, start: Date) -> WorkoutSessionEntity {
        let workout = WorkoutSessionEntity(context: context)
        workout.id = UUID()
        workout.category = category
        workout.duration = duration
        workout.intensity = intensity
        workout.start = start
        workout.user = user
        user.addToExercises(workout)
        try! context.save()
        return workout
    }

    @discardableResult
    private func createSleepSession(user: UserEntity, duration: Int64, quality: Int64, start: Date) -> SleepSessionEntity {
        let sleep = SleepSessionEntity(context: context)
        sleep.id = UUID()
        sleep.duration = duration
        sleep.quality = quality
        sleep.start = start
        sleep.user = user
        user.addToSleeps(sleep)
        try! context.save()
        return sleep
    }

    
    // MARK: - Tests
    
    func testMapToUser() {
        let user = createUser(firstName: "John", lastName: "Doe", passwordHash: "hash123")
        let workout = createWorkoutSession(user: user, category: "Fitness", duration: 60, intensity: 5, start: Date())
        let sleep = createSleepSession(user: user, duration: 480, quality: 8, start: Date())
        
        let mappedUser = mapToUser(from: user)
        
        // Vérifiez les attributs de l'utilisateur
        XCTAssertEqual(mappedUser.id, user.id)
        XCTAssertEqual(mappedUser.firstName, "John")
        XCTAssertEqual(mappedUser.lastName, "Doe")
        XCTAssertEqual(mappedUser.passwordHash, "hash123")
        
        // Vérifiez les relations
        XCTAssertEqual(mappedUser.exercises.count, 1)
        XCTAssertEqual(mappedUser.sleeps.count, 1)
        
        XCTAssertEqual(mappedUser.exercises.first?.id, workout.id)
        XCTAssertEqual(mappedUser.sleeps.first?.id, sleep.id)
    }

    func testMapToWorkoutSession() {
        let user = createUser(firstName: "Jane", lastName: "Doe", passwordHash: "hash456")
        let workout = createWorkoutSession(user: user, category: "Running", duration: 90, intensity: 8, start: Date())
        
        let mappedWorkout = mapToWorkoutSession(from: workout)
        
        XCTAssertNotNil(mappedWorkout)
        XCTAssertEqual(mappedWorkout?.id, workout.id)
        XCTAssertEqual(mappedWorkout?.category.rawValue, "Running")
        XCTAssertEqual(mappedWorkout?.duration, 90)
        XCTAssertEqual(mappedWorkout?.intensity, 8)
        XCTAssertEqual(mappedWorkout?.start, workout.start)
    }
    
    func testMapToWorkoutSession_InvalidCategory() {
        let user = createUser(firstName: "Alice", lastName: "Smith", passwordHash: "hash789")
        let workout = createWorkoutSession(user: user, category: "InvalidCategory", duration: 45, intensity: 3, start: Date())
        
        let mappedWorkout = mapToWorkoutSession(from: workout)
        
        XCTAssertNil(mappedWorkout, "Mapping should fail for invalid category.")
    }
    
    func testMapToSleepSession() {
        let user = createUser(firstName: "Mike", lastName: "Johnson", passwordHash: "hash012")
        let sleep = createSleepSession(user: user, duration: 540, quality: 7, start: Date())
        
        let mappedSleep = mapToSleepSession(from: sleep)
        
        XCTAssertNotNil(mappedSleep)
        XCTAssertEqual(mappedSleep?.id, sleep.id)
        XCTAssertEqual(mappedSleep?.duration, 540)
        XCTAssertEqual(mappedSleep?.quality, 7)
        XCTAssertEqual(mappedSleep?.start, sleep.start)
    }
    
    func testMapToSleepSession_NoUser() {
        let sleep = SleepSessionEntity(context: context)
        sleep.id = UUID()
        sleep.duration = 600
        sleep.quality = 9
        sleep.start = Date()
        
        let mappedSleep = mapToSleepSession(from: sleep)
        
        XCTAssertNil(mappedSleep, "Mapping should fail for sleep session without a user.")
    }
}
