//
//  ExerciseListViewModelTests.swift
//  AristaTests
//
//  Created by Margot Pasquali on 13/11/2024.
//

import XCTest
import CoreData
import AristaPersistence
import Combine

@testable import Arista

final class ExerciseListViewModelTests: XCTestCase {
    
    private var persistenceController: PersistenceController!
    private var context: NSManagedObjectContext!
    
    var cancellables = Set<AnyCancellable>()
    
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
        let fetchRequest = WorkoutSessionEntity.fetchRequest()
        let objects = try! context.fetch(fetchRequest)
        
        for exercise in objects {
            context.delete(exercise)
        }
        try! context.save()
    }

    private func addExercice(category: String, duration: Int, intensity: Int, startDate: Date, userFirstName: String, userLastName: String) {
        
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
    
    func test_WhenNoExerciseIsInDatabase_FetchExercise_ReturnEmptyList() {
        
        // Clean manually all data
        let viewModel = ExerciseListViewModel(context: context)
        let expectation = XCTestExpectation(description: "fetch empty list of exercise")
        
        viewModel.$exercises
        
            .sink { exercises in
                XCTAssert(exercises.isEmpty)
                expectation.fulfill()
            }
        
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 10)
        
    }
    
    func test_WhenAddingOneExerciseInDatabase_FEtchExercise_ReturnAListContainingTheExercise() {
        
        // Clean manually all data
        
        let date = Date()
        
        addExercice(category: "Football", duration: 10, intensity: 5, startDate: date, userFirstName: "Eric", userLastName: "Marcus")
        
        let viewModel = ExerciseListViewModel(context: context)
        
        let expectation = XCTestExpectation(description: "fetch empty list of exercise")
        
        
        viewModel.$exercises
        
            .sink { exercises in
                
                XCTAssert(exercises.isEmpty == false)
                XCTAssert(exercises.first?.category == WorkoutSession.Category.football)
                XCTAssert(exercises.first?.duration == 10)
                XCTAssert(exercises.first?.intensity == 5)
                XCTAssert(exercises.first?.start == date)
                
                expectation.fulfill()
                
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 10)
        
    }
    
    func test_WhenAddingMultipleExerciseInDatabase_FetchExercise_ReturnAListContainingTheExerciseInTheRightOrder() {
        
        // Clean manually all data
        
        let date1 = Date()
        let date2 = Date(timeIntervalSinceNow: -(60*60*24))
        let date3 = Date(timeIntervalSinceNow: -(60*60*24*2))
        
        addExercice(
                    category: "Football",
                    duration: 10,
                    intensity: 5,
                    startDate: date1,
                    userFirstName: "Ericn",
                    userLastName: "Marcusi")
        
        addExercice(
                    category: "Running",
                    duration: 120,
                    intensity: 1,
                    startDate: date3,
                    userFirstName: "Ericb",
                    userLastName: "Marceau")
        
        addExercice(
                    category: "Fitness",
                    duration: 30,
                    intensity: 5,
                    startDate: date2,
                    userFirstName: "Frédericp",
                    userLastName: "Marcus")
        
        let viewModel = ExerciseListViewModel(context: context)
        
        let expectation = XCTestExpectation(description: "fetch exercises in correct order")
        
        viewModel.$exercises
            .sink { exercises in
                XCTAssertEqual(exercises.count, 3)
                XCTAssertEqual(exercises[0].category, WorkoutSession.Category.football)
                XCTAssertEqual(exercises[1].category, WorkoutSession.Category.fitness)
                XCTAssertEqual(exercises[2].category, WorkoutSession.Category.running)
                
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 10)
    }


}
