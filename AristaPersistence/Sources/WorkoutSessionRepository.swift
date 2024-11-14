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
    func addNewWorkout(category: String, duration: Int, intensity: Int, start: Date, userID: UUID) throws
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
    public func addNewWorkout(category: String, duration: Int, intensity: Int, start: Date, userID: UUID) throws {
        guard let validCategory = WorkoutSession.Category(rawValue: category) else {
            print("Erreur: La catégorie spécifiée '\(category)' n'est pas valide.")
            return
        }

        // Récupère `UserEntity` en fonction de l'ID
        let userFetchRequest = UserEntity.fetchRequest()
        userFetchRequest.predicate = NSPredicate(format: "id == %@", userID as CVarArg)
        
        guard let userEntity = try? context.fetch(userFetchRequest).first else {
            print("Erreur: Aucun utilisateur trouvé pour l'ID \(userID).")
            return
        }
        
        // Crée un nouvel exercice
        let newWorkout = WorkoutSessionEntity(context: context)
        newWorkout.id = UUID()
        newWorkout.category = validCategory.rawValue
        newWorkout.duration = Int64(duration)
        newWorkout.intensity = Int64(intensity)
        newWorkout.start = start
        newWorkout.user = userEntity // Associe `UserEntity` récupéré

        try context.save()
    }

}
