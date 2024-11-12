//
//  DefaultData.swift
//  AristaPersistence
//
//  Created by Margot Pasquali on 07/11/2024.
//

import Foundation
import CoreData

// MARK: - DefaultData Protocol Definition
protocol DefaultDataProtocol {
    func apply() throws
}

// MARK: - DefaultData Implementation
struct DefaultData: DefaultDataProtocol {
    
    // MARK: - Properties
    private let context: NSManagedObjectContext
    
    // MARK: - Initializer
    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
    }
    
    // MARK: - Public Methods
    
    /// Applies default data if no user exists.
    func apply() throws {
        let userRepository = UserRepository(context: context)
        let sleepSessionRepository = SleepSessionRepository(context: context)
        
        // MARK: Check for Existing User
        if (try? userRepository.getUser()) == nil {
            let initialUser = createInitialUser()
            
            // MARK: Add Default Sleep Sessions
            if try sleepSessionRepository.getSleepSessions().isEmpty {
                addDefaultSleepSessions(for: initialUser)
            }
            
            // MARK: Add Default Workout Sessions
            addDefaultWorkoutSessions(for: initialUser)
            
            // MARK: Save Context
            try saveContext()
        } else {
            print("Utilisateur par défaut déjà existant")
        }
    }
    
    // MARK: - Private Helper Methods
    
    /// Creates the initial user with default values.
    private func createInitialUser() -> UserEntity {
        let initialUser = UserEntity(context: context)
        initialUser.firstName = "Charlotte"
        initialUser.lastName = "Razoul"
        initialUser.passwordHash = "defaultHashValue"
        initialUser.id = UUID()
        return initialUser
    }
    
    /// Adds a set of default sleep sessions for the provided user.
    private func addDefaultSleepSessions(for user: UserEntity) {
        let sleepSessions = (1...5).map { index -> SleepSessionEntity in
            let sleep = SleepSessionEntity(context: context)
            sleep.id = UUID()
            sleep.duration = Int64.random(in: 0...900)
            sleep.quality = Int64.random(in: 0...10)
            sleep.start = Date(timeIntervalSinceNow: TimeInterval(60 * 60 * 24 * (6 - index)))
            sleep.user = user
            return sleep
        }
        print("Ajout de \(sleepSessions.count) sessions de sommeil pour l'utilisateur \(user.firstName)")
    }
    
    /// Adds a set of default workout sessions for the provided user.
    private func addDefaultWorkoutSessions(for user: UserEntity) {
        for i in 1...5 {
            let workoutSession = WorkoutSessionEntity(context: context)
            workoutSession.id = UUID()
            workoutSession.category = WorkoutSession.Category.running.rawValue
            workoutSession.duration = Int64.random(in: 30...120)
            workoutSession.intensity = Int64.random(in: 1...10)
            workoutSession.start = Date(timeIntervalSinceNow: TimeInterval(60 * 60 * 24 * i))
            workoutSession.user = user
            print("Exercice ajouté avec user: \(workoutSession.user?.firstName ?? "aucun")")
        }
    }
    
    /// Attempts to save the context and logs an error if it fails.
    private func saveContext() throws {
        do {
            try context.save()
            print("Utilisateur par défaut sauvegardé avec succès")
        } catch {
            print("Erreur lors de la sauvegarde de l'utilisateur par défaut : \(error)")
            throw error
        }
    }
}
