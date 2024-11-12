//
//  SleepSessionRepository.swift
//  AristaPersistence
//
//  Created by Margot Pasquali on 07/11/2024.
//

import Foundation
import CoreData

// MARK: - SleepSessionRepository Protocol Definition
public protocol SleepSessionRepositoryProtocol {
    func getSleepSessions() throws -> [SleepSession]
}

// MARK: - SleepSessionRepository Implementation
public struct SleepSessionRepository: SleepSessionRepositoryProtocol {
    
    // MARK: Properties
    private let context: NSManagedObjectContext
    
    // MARK: Initializer
    public init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
    }
    
    // MARK: Public Methods
    
    /// Fetches all sleep sessions from Core Data, sorted by start date in descending order.
    public func getSleepSessions() throws -> [SleepSession] {
        // Création de la requête pour SleepSessionEntity
        let request = SleepSessionEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \SleepSessionEntity.start, ascending: false)]
        
        // Exécution de la requête et récupération des entités
        let sleepSessionEntities = try context.fetch(request)
        
        // Conversion de chaque SleepSessionEntity en modèle SleepSession
        return sleepSessionEntities.compactMap { entity in
            mapToSleepSession(from: entity)
        }
    }
}
