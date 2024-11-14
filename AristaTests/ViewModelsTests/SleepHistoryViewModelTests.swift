//
//  SleepHistoryViewModelTests.swift
//  AristaTests
//
//  Created by Margot Pasquali on 14/11/2024.
//

import XCTest
import CoreData
import AristaPersistence

@testable import Arista

final class SleepHistoryViewModelTests: XCTestCase {
    
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
        let fetchRequest: NSFetchRequest<SleepSessionEntity> = SleepSessionEntity.fetchRequest()
        let objects = try! context.fetch(fetchRequest)
        
        for session in objects {
            context.delete(session)
        }
        try! context.save()
    }
    
    @discardableResult
    private func addSleepSession(duration: Int64, quality: Int64, startDate: Date, user: UserEntity) -> SleepSessionEntity {
        let newSleepSession = SleepSessionEntity(context: context)
        newSleepSession.duration = duration
        newSleepSession.quality = quality
        newSleepSession.start = startDate
        newSleepSession.user = user
        newSleepSession.id = UUID()
        
        try! context.save()
        return newSleepSession
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
    
    func test_WhenNoSleepSessionInDatabase_FetchSleepSessions_ReturnsEmptyList() {
        let viewModel = SleepHistoryViewModel(context: context)
        XCTAssertTrue(viewModel.sleepSessions.isEmpty, "Expected empty list when no sleep sessions are in the database.")
    }

    func test_WhenAddingOneSleepSession_FetchSleepSessions_ReturnsListContainingTheSleepSession() {
        let user = addUser(firstName: "John", lastName: "Doe", passwordHash: "hash")
        let date = Date()
        
        addSleepSession(duration: 480, quality: 8, startDate: date, user: user)
        
        let viewModel = SleepHistoryViewModel(context: context)
        
        XCTAssertEqual(viewModel.sleepSessions.count, 1)
        XCTAssertEqual(viewModel.sleepSessions.first?.duration, 480)
        XCTAssertEqual(viewModel.sleepSessions.first?.quality, 8)
        XCTAssertEqual(viewModel.sleepSessions.first?.start, date)
    }
    
    func test_WhenAddingMultipleSleepSessions_FetchSleepSessions_ReturnsListInDescendingOrder() {
        let user = addUser(firstName: "Alice", lastName: "Smith", passwordHash: "hash123")
        
        let date1 = Date()
        let date2 = Date(timeIntervalSinceNow: -(60*60*24)) // 1 jour avant
        let date3 = Date(timeIntervalSinceNow: -(60*60*24*2)) // 2 jours avant
        
        addSleepSession(duration: 420, quality: 7, startDate: date3, user: user)
        addSleepSession(duration: 300, quality: 5, startDate: date2, user: user)
        addSleepSession(duration: 600, quality: 9, startDate: date1, user: user)
        
        let viewModel = SleepHistoryViewModel(context: context)
        
        XCTAssertEqual(viewModel.sleepSessions.count, 3)
        XCTAssertEqual(viewModel.sleepSessions[0].start, date1) // Le plus récent en premier
        XCTAssertEqual(viewModel.sleepSessions[1].start, date2) // Ensuite le second plus récent
        XCTAssertEqual(viewModel.sleepSessions[2].start, date3) // Le plus ancien en dernier
    }
}
