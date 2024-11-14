//
//  SleepSessionTests.swift
//  AristaPersistenceTests
//
//  Created by Margot Pasquali on 14/11/2024.
//

import XCTest

@testable import AristaPersistence

final class SleepSessionTests: XCTestCase {

    func test_SleepSessionInitialization_SetsPropertiesCorrectly() {
        // Préparation des données
        let id = UUID()
        let duration: Int64 = 480
        let quality: Int64 = 8
        let start = Date()
        
        // Initialisation de SleepSession
        let sleepSession = SleepSession(id: id, duration: duration, quality: quality, start: start)
        
        // Vérifications
        XCTAssertEqual(sleepSession.id, id, "L'ID devrait être initialisé correctement.")
        XCTAssertEqual(sleepSession.duration, duration, "La durée devrait être initialisée correctement.")
        XCTAssertEqual(sleepSession.quality, quality, "La qualité devrait être initialisée correctement.")
        XCTAssertEqual(sleepSession.start, start, "La date de début devrait être initialisée correctement.")
    }

    func test_SleepSession_DefaultInitialization_WithZeroValues() {
        // Préparation des données
        let id = UUID()
        let duration: Int64 = 0
        let quality: Int64 = 0
        let start = Date()
        
        // Initialisation de SleepSession avec des valeurs par défaut
        let sleepSession = SleepSession(id: id, duration: duration, quality: quality, start: start)
        
        // Vérifications pour des valeurs par défaut de durée et qualité
        XCTAssertEqual(sleepSession.duration, 0, "La durée devrait pouvoir être initialisée avec la valeur par défaut zéro.")
        XCTAssertEqual(sleepSession.quality, 0, "La qualité devrait pouvoir être initialisée avec la valeur par défaut zéro.")
    }
    
    func test_SleepSession_NegativeValuesForDurationAndQuality_AreAllowed() {
        // Préparation des données avec des valeurs négatives
        let id = UUID()
        let duration: Int64 = -480
        let quality: Int64 = -1
        let start = Date()
        
        // Initialisation de SleepSession
        let sleepSession = SleepSession(id: id, duration: duration, quality: quality, start: start)
        
        // Vérifications pour des valeurs négatives
        XCTAssertEqual(sleepSession.duration, duration, "La durée devrait pouvoir être initialisée avec une valeur négative.")
        XCTAssertEqual(sleepSession.quality, quality, "La qualité devrait pouvoir être initialisée avec une valeur négative.")
    }
    
    func test_SleepSession_ValidDateInitialization() {
        // Préparation de données
        let id = UUID()
        let duration: Int64 = 480
        let quality: Int64 = 8
        let start = Date()
        
        // Initialisation de SleepSession avec une date spécifique
        let sleepSession = SleepSession(id: id, duration: duration, quality: quality, start: start)
        
        // Vérifie que la date de début correspond bien à la date utilisée
        XCTAssertEqual(sleepSession.start, start, "La date de début devrait correspondre à la date fournie.")
    }
}
