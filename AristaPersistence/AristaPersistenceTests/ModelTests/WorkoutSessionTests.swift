//
//  WorkoutSessionTests.swift
//  AristaPersistenceTests
//
//  Created by Margot Pasquali on 14/11/2024.
//

import XCTest

@testable import AristaPersistence

final class WorkoutSessionTests: XCTestCase {

    func test_WorkoutSessionInitialization_SetsPropertiesCorrectly() {
        // Préparation des données
        let id = UUID()
        let category: WorkoutSession.Category = .fitness
        let duration: Int64 = 60
        let intensity: Int64 = 5
        let start = Date()
        
        // Initialisation de WorkoutSession
        let workoutSession = WorkoutSession(id: id, category: category, duration: duration, intensity: intensity, start: start)
        
        // Vérifications
        XCTAssertEqual(workoutSession.id, id, "L'ID devrait être initialisé correctement.")
        XCTAssertEqual(workoutSession.category, category, "La catégorie devrait être initialisée correctement.")
        XCTAssertEqual(workoutSession.duration, duration, "La durée devrait être initialisée correctement.")
        XCTAssertEqual(workoutSession.intensity, intensity, "L'intensité devrait être initialisée correctement.")
        XCTAssertEqual(workoutSession.start, start, "La date de début devrait être initialisée correctement.")
    }
    
    func test_WorkoutSession_AllCategoryCasesExist() {
        // Vérifie que tous les cas de catégorie sont présents
        let categories = WorkoutSession.Category.allCases
        let expectedCategories: [WorkoutSession.Category] = [
            .fitness, .swimming, .running, .riding, .biking, .yoga, .pilates, .football
        ]
        
        XCTAssertEqual(categories.count, expectedCategories.count, "Le nombre de catégories devrait être égal à \(expectedCategories.count).")
        XCTAssertEqual(categories, expectedCategories, "Les catégories devraient correspondre aux valeurs définies.")
    }

    func test_WorkoutSessionInitialization_WithBoundaryValues() {
        // Test avec des valeurs limites pour la durée et l'intensité
        let id = UUID()
        let category: WorkoutSession.Category = .running
        let duration: Int64 = 0
        let intensity: Int64 = 10
        let start = Date()
        
        // Initialisation de WorkoutSession
        let workoutSession = WorkoutSession(id: id, category: category, duration: duration, intensity: intensity, start: start)
        
        // Vérifications
        XCTAssertEqual(workoutSession.duration, 0, "La durée devrait être initialisée à la limite inférieure de 0.")
        XCTAssertEqual(workoutSession.intensity, 10, "L'intensité devrait être initialisée à la limite supérieure de 10.")
    }

    func test_WorkoutSessionInitialization_WithNegativeValues() {
        // Test avec des valeurs négatives pour la durée et l'intensité
        let id = UUID()
        let category: WorkoutSession.Category = .biking
        let duration: Int64 = -30
        let intensity: Int64 = -3
        let start = Date()
        
        // Initialisation de WorkoutSession
        let workoutSession = WorkoutSession(id: id, category: category, duration: duration, intensity: intensity, start: start)
        
        // Vérifications
        XCTAssertEqual(workoutSession.duration, -30, "La durée devrait pouvoir être initialisée avec une valeur négative.")
        XCTAssertEqual(workoutSession.intensity, -3, "L'intensité devrait pouvoir être initialisée avec une valeur négative.")
    }
    
    func test_WorkoutSession_EnumRawValueInitialization() {
        // Test pour valider les valeurs brutes de chaque cas d'enum
        XCTAssertEqual(WorkoutSession.Category.fitness.rawValue, "Fitness")
        XCTAssertEqual(WorkoutSession.Category.swimming.rawValue, "Swimming")
        XCTAssertEqual(WorkoutSession.Category.running.rawValue, "Running")
        XCTAssertEqual(WorkoutSession.Category.riding.rawValue, "Riding")
        XCTAssertEqual(WorkoutSession.Category.biking.rawValue, "Biking")
        XCTAssertEqual(WorkoutSession.Category.yoga.rawValue, "Yoga")
        XCTAssertEqual(WorkoutSession.Category.pilates.rawValue, "Pilates")
        XCTAssertEqual(WorkoutSession.Category.football.rawValue, "Football")
    }
}
