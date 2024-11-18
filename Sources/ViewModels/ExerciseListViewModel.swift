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
    // MARK: - Enums

    enum ExciseListViewModelError: Error {
        case fetchingExercisesError
        
    var localizedDescription: String {
            switch self {
            case .fetchingExercisesError:
                return "Erreur lors de la récupération des sessions d'entraînement."
            }
        }
    }
    
    // MARK: - Published Properties
    
    @Published var exercises = [WorkoutSession]()
    @Published var errorMessage: String?
    
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
            errorMessage = ExciseListViewModelError.fetchingExercisesError.localizedDescription
        }
    }
}
