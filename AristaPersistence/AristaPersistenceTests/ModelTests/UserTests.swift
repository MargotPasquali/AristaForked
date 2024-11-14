//
//  UserTests.swift
//  AristaPersistenceTests
//
//  Created by Margot Pasquali on 14/11/2024.
//

import XCTest

@testable import AristaPersistence

final class UserTests: XCTestCase {

    func test_UserInitialization_SetsPropertiesCorrectly() {
        // Préparation des données
        let id = UUID()
        let firstName = "Alice"
        let lastName = "Smith"
        let passwordHash = "securePasswordHash"
        let exercises: [WorkoutSessionEntity] = [] // Liste vide pour ce test
        let sleeps: [SleepSessionEntity] = [] // Liste vide pour ce test
        
        // Initialisation de User
        let user = User(
            id: id,
            firstName: firstName,
            lastName: lastName,
            passwordHash: passwordHash,
            exercises: exercises,
            sleeps: sleeps
        )
        
        // Vérifications
        XCTAssertEqual(user.id, id, "L'ID devrait être initialisé correctement.")
        XCTAssertEqual(user.firstName, firstName, "Le prénom devrait être initialisé correctement.")
        XCTAssertEqual(user.lastName, lastName, "Le nom de famille devrait être initialisé correctement.")
        XCTAssertEqual(user.passwordHash, passwordHash, "Le hash du mot de passe devrait être initialisé correctement.")
        XCTAssertTrue(user.exercises.isEmpty, "La liste des exercices devrait être initialisée vide.")
        XCTAssertTrue(user.sleeps.isEmpty, "La liste des sessions de sommeil devrait être initialisée vide.")
    }
    
    func test_UserInitialization_WithExercisesAndSleeps() {
        // Préparation des données avec des exercices et des sessions de sommeil
        let id = UUID()
        let firstName = "John"
        let lastName = "Doe"
        let passwordHash = "anotherSecureHash"

        // Crée des entités fictives de WorkoutSessionEntity et SleepSessionEntity
        let exercise1 = WorkoutSessionEntity()
        let exercise2 = WorkoutSessionEntity()
        let sleep1 = SleepSessionEntity()
        let sleep2 = SleepSessionEntity()
        
        // Initialisation avec des exercices et des sessions de sommeil
        let user = User(
            id: id,
            firstName: firstName,
            lastName: lastName,
            passwordHash: passwordHash,
            exercises: [exercise1, exercise2],
            sleeps: [sleep1, sleep2]
        )
        
        // Vérifications
        XCTAssertEqual(user.exercises.count, 2, "Le nombre d'exercices devrait être de 2.")
        XCTAssertEqual(user.sleeps.count, 2, "Le nombre de sessions de sommeil devrait être de 2.")
    }
    
    func test_UserInitialization_WithEmptyStrings() {
        // Test avec des chaînes de caractères vides
        let id = UUID()
        let firstName = ""
        let lastName = ""
        let passwordHash = ""
        let exercises: [WorkoutSessionEntity] = []
        let sleeps: [SleepSessionEntity] = []
        
        // Initialisation de User
        let user = User(
            id: id,
            firstName: firstName,
            lastName: lastName,
            passwordHash: passwordHash,
            exercises: exercises,
            sleeps: sleeps
        )
        
        // Vérifications
        XCTAssertEqual(user.firstName, "", "Le prénom devrait être une chaîne vide.")
        XCTAssertEqual(user.lastName, "", "Le nom de famille devrait être une chaîne vide.")
        XCTAssertEqual(user.passwordHash, "", "Le hash du mot de passe devrait être une chaîne vide.")
    }

    func test_UserInitialization_WithInvalidUUID() {
        // Test avec un UUID spécifique pour vérifier la cohérence de l'ID
        let id = UUID(uuidString: "00000000-0000-0000-0000-000000000000")!
        let firstName = "Test"
        let lastName = "User"
        let passwordHash = "hash"
        
        let user = User(
            id: id,
            firstName: firstName,
            lastName: lastName,
            passwordHash: passwordHash,
            exercises: [],
            sleeps: []
        )
        
        XCTAssertEqual(user.id, id, "L'ID devrait correspondre à l'UUID spécifié.")
    }
}
