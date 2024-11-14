//
//  SleepSessionRepositoryTests.swift
//  AristaPersistenceTests
//
//  Created by Margot Pasquali on 13/11/2024.
//

import XCTest
import CoreData

@testable import AristaPersistence

final class SleepSessionRepositoryTests: XCTestCase {
    
    // MARK: - Helper Methods
    
    @discardableResult
    private func addSleepSession(context: NSManagedObjectContext, duration: Int64, quality: Int64, start: Date, user: UserEntity) -> SleepSessionEntity {
        let newSleepSession = SleepSessionEntity(context: context)
        newSleepSession.duration = duration
        newSleepSession.quality = quality
        newSleepSession.start = start
        newSleepSession.user = user
        newSleepSession.id = UUID()
        
        try! context.save()
        return newSleepSession
    }
    
    private func emptyEntities(context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<SleepSessionEntity> = SleepSessionEntity.fetchRequest()
        let objects = try! context.fetch(fetchRequest)
        
        for session in objects {
            context.delete(session)
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
    
    func test_WhenNoSleepSessionIsInDatabase_GetSleepSessions_ReturnsEmptyList() {
        let persistenceController = PersistenceController(inMemory: true)
        let repository = SleepSessionRepository(context: persistenceController.container.viewContext)
        
        emptyEntities(context: persistenceController.container.viewContext)
        
        let sleepSessions = try! repository.getSleepSessions()
        
        XCTAssertTrue(sleepSessions.isEmpty)
    }
    
    func test_WhenAddingOneSleepSessionInDatabase_GetSleepSessions_ReturnsAListContainingTheSleepSession() {
        let persistenceController = PersistenceController(inMemory: true)
        
        let user = addUser(context: persistenceController.container.viewContext, firstName: "John", lastName: "Doe", passwordHash: "hash")
        let date = Date()
        
        addSleepSession(context: persistenceController.container.viewContext, duration: 480, quality: 8, start: date, user: user)
        
        let repository = SleepSessionRepository(context: persistenceController.container.viewContext)
        let sleepSessions = try! repository.getSleepSessions()
        
        XCTAssertFalse(sleepSessions.isEmpty)
        XCTAssertEqual(sleepSessions.count, 1)
        XCTAssertEqual(sleepSessions.first?.duration, 480)
        XCTAssertEqual(sleepSessions.first?.quality, 8)
        XCTAssertEqual(sleepSessions.first?.start, date)
    }
    
    func test_WhenAddingMultipleSleepSessionsInDatabase_GetSleepSessions_ReturnsListInDescendingOrder() {
        let persistenceController = PersistenceController(inMemory: true)
        
        let user = addUser(context: persistenceController.container.viewContext, firstName: "Alice", lastName: "Smith", passwordHash: "hash123")
        
        let date1 = Date()
        let date2 = Date(timeIntervalSinceNow: -(60*60*24)) // 1 jour avant
        let date3 = Date(timeIntervalSinceNow: -(60*60*24*2)) // 2 jours avant
        
        addSleepSession(context: persistenceController.container.viewContext, duration: 420, quality: 7, start: date3, user: user)
        addSleepSession(context: persistenceController.container.viewContext, duration: 300, quality: 5, start: date2, user: user)
        addSleepSession(context: persistenceController.container.viewContext, duration: 600, quality: 9, start: date1, user: user)
        
        let repository = SleepSessionRepository(context: persistenceController.container.viewContext)
        let sleepSessions = try! repository.getSleepSessions()
        
        XCTAssertEqual(sleepSessions.count, 3)
        XCTAssertEqual(sleepSessions[0].start, date1) // Le plus récent en premier
        XCTAssertEqual(sleepSessions[1].start, date2) // Ensuite le second plus récent
        XCTAssertEqual(sleepSessions[2].start, date3) // Le plus ancien en dernier
    }
}


