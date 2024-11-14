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
    
    // MARK: - Published Properties
    
    @Published var category: WorkoutSession.Category
    @Published var start: Date = Date()
    @Published var duration: Int64 = 0
    @Published var intensity: Int64 = 0

    // MARK: - Private Properties
    
    private var viewContext: NSManagedObjectContext

    // MARK: - Initializer
    
    init(context: NSManagedObjectContext, category: WorkoutSession.Category = .fitness) {
        self.viewContext = context
        self.category = category // Initialisation de `category`
    }
    
    // MARK: - Public Methods
    func addExercise(onExerciseAdded: () -> Void) -> Bool {
        guard let currentUser = getCurrentUser() else {
            print("Aucun utilisateur disponible pour l'exercice.")
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
            print("Erreur lors de l'ajout de l'exercice : \(error)")
            return false
        }
    }

    // MARK: - Private Methods
    
    private func getCurrentUser() -> UserEntity? {
        let userRepository = UserRepository(context: viewContext)
        return userRepository.getUser()
    }
}
