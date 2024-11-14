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
    
    @Published var category: String = ""
    @Published var start: Date = Date()
    @Published var duration: Int64 = 0
    @Published var intensity: Int64 = 0

    // MARK: - Private Properties
    
    private var viewContext: NSManagedObjectContext

    // MARK: - Initializer
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
    }

//    func addExercise(for user: UserEntity) -> Bool {
//        let repository = WorkoutSessionRepository(context: viewContext)
//        
//        do {
//            try repository.addNewWorkout(
//                category: category,
//                duration: Int(duration),
//                intensity: Int(intensity),
//                start: start,
//                user: user // Passe un UserEntity
//            )
//            return true
//        } catch {
//            print("Erreur lors de l'ajout de l'exercice : \(error)")
//            return false
//        }
//    }
    // MARK: - Public Methods
        
    func addExercise(onExerciseAdded: () -> Void) -> Bool {
        // Utilise `getCurrentUser` pour obtenir un `User`
        guard let currentUser = getCurrentUser() else {
            print("Aucun utilisateur disponible pour l'exercice.")
            return false
        }

        let repository = WorkoutSessionRepository(context: viewContext)

        do {
            // Utilise l'ID de `User` pour ajouter un exercice
            try repository.addNewWorkout(
                category: category,
                duration: Int(duration),
                intensity: Int(intensity),
                start: start,
                userID: currentUser.id // Utilise l'ID de `User`
            )
            onExerciseAdded()
            return true
        } catch {
            print("Erreur lors de l'ajout de l'exercice : \(error)")
            return false
        }
    }


        // MARK: - Private Methods
        
    private func getCurrentUser() -> User? {
        let userRepository = UserRepository(context: viewContext)
        return userRepository.getUser()
    }

    }
