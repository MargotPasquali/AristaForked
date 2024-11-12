//
//  WorkoutSessionRepository.swift
//  AristaPersistence
//
//  Created by Margot Pasquali on 07/11/2024.
//

import Foundation
import CoreData

// MARK: - WorkoutSessionRepository Protocol Definition
public protocol WorkoutSessionRepositoryProtocol {
    func getWorkoutSessions() throws -> [WorkoutSession]
    func addNewWorkout(category: String, duration: Int, intensity: Int, start: Date, user: UserEntity) throws
}

// MARK: - WorkoutSessionRepository Implementation
public struct WorkoutSessionRepository: WorkoutSessionRepositoryProtocol {
    
    // MARK: Properties
    private let context: NSManagedObjectContext
    
    // MARK: Initializer
    public init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
    }
    
    // MARK: Public Methods
    
    /// Fetches all workout sessions from Core Data, sorted by start date in descending order.
    public func getWorkoutSessions() throws -> [WorkoutSession] {
        let request = WorkoutSessionEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \WorkoutSessionEntity.start, ascending: false)]
        
        // Fetches entities and maps them to WorkoutSession
        let workoutEntities = try context.fetch(request)
        return workoutEntities.compactMap { entity in
            mapToWorkoutSession(from: entity)
        }
    }
    
    /// Adds a new workout session to Core Data with a specified category, duration, intensity, and user.
    public func addNewWorkout(category: String, duration: Int, intensity: Int, start: Date, user: UserEntity) throws {
        // Validate category
        guard let validCategory = WorkoutSession.Category(rawValue: category) else {
            print("Erreur: La catégorie spécifiée '\(category)' n'est pas valide.")
            return
        }
        
        // Create and configure a new WorkoutSessionEntity
        let newWorkout = WorkoutSessionEntity(context: context)
        newWorkout.id = UUID()
        newWorkout.category = validCategory.rawValue
        newWorkout.duration = Int64(duration)
        newWorkout.intensity = Int64(intensity)
        newWorkout.start = start
        newWorkout.user = user

        // Log pour confirmer que `user` est assigné
        print("Nouvel exercice créé avec user: \(newWorkout.user?.firstName ?? "aucun")")

        // Save context
        try context.save()
    }
}
