//
//  ExerciseListViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import Foundation
import CoreData
import AristaPersistence

// MARK: - ExerciseListViewModel

final class ExerciseListViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var exercises = [WorkoutSession]()
    
    // MARK: - Core Data Context
    
    var viewContext: NSManagedObjectContext

    // MARK: - Initializer
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
        fetchExercises()
    }

    // MARK: - Fetching Exercises
    
    func fetchExercises() {
        do {
            let data = WorkoutSessionRepository(context: viewContext)
            exercises = try data.getWorkoutSessions()
        } catch {
            print("Erreur lors de la récupération des sessions d'entraînement : \(error)")
        }
    }
}
