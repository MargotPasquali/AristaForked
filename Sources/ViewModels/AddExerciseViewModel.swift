//
//  AddExerciseViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import Foundation
import CoreData
import AristaPersistence

// MARK: - AddExerciseViewModel

final class AddExerciseViewModel: ObservableObject {
    
    // MARK: - Enums

    enum AddExerciseViewModelError: Error {
        case NewWorkoutNotValid
        case NoUserAvailable
        case SavingError
        
        var localizedDescription: String {
            switch self {
            case .NewWorkoutNotValid:
                return "L'exercice n'est pas valide."
            case .NoUserAvailable:
                return "Au moins un utilisateur doit être connecté."
            case .SavingError:
                return "Erreur de sauvegarde de l'exercice. Veuillez réessayer."
            }
        }
    }
    
    // MARK: - Published Properties
    
    @Published var category: WorkoutSession.Category
    @Published var start: Date = Date()
    @Published var duration: Int64 = 0
    @Published var intensity: Int64 = 0
    @Published var errorMessage: String?

    // MARK: - Private Properties
    
    private var viewContext: NSManagedObjectContext

    // MARK: - Initializer
    
    init(context: NSManagedObjectContext, category: WorkoutSession.Category = .fitness) {
        self.viewContext = context
        self.category = category // Initialisation de `category`
    }
    
    // MARK: - Public Methods
    
    func isNewWorkoutValid() -> Bool {
        let now = Date()
        return duration > 0 && intensity > 0 && start <= now
    }

    func addExercise(onExerciseAdded: () -> Void) -> Bool {
        guard isNewWorkoutValid() else {
            errorMessage = AddExerciseViewModelError.NewWorkoutNotValid.localizedDescription
            return false
        }
        
        guard let currentUser = getCurrentUser() else {
            errorMessage = AddExerciseViewModelError.NoUserAvailable.localizedDescription
            return false
        }

        let repository = WorkoutSessionRepository(context: viewContext)

        do {
            try repository.addNewWorkout(
                category: category.rawValue,
                duration: Int(duration),
                intensity: Int(intensity),
                start: start,
                userID: currentUser.id
            )
            onExerciseAdded()
            return true
        } catch {
            errorMessage = AddExerciseViewModelError.SavingError.localizedDescription
            return false
        }
    }

    // MARK: - Private Methods
    
    private func getCurrentUser() -> UserEntity? {
        let userRepository = UserRepository(context: viewContext)
        return userRepository.getUser()
    }
}
