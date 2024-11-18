//
//  UserDataViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import Foundation
import CoreData
import AristaPersistence

// MARK: - UserDataViewModel

final class UserDataViewModel: ObservableObject {
    
    // MARK: - Enums

    enum UserDataViewModelError: Error {
        case userNotFound
        case fetchingUserFailed
        
        var localizedDescription: String {
            switch self {
            case .userNotFound:
                return "Aucun utilisateur trouvé."
            case .fetchingUserFailed:
                return "Erreur lors de la récupération des données de l'utilisateur."
            }
        }
    }
    
    // MARK: - Published Properties
    
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var errorMessage : String?
    
    // MARK: - Core Data Context
    
    private var viewContext: NSManagedObjectContext
    
    // MARK: - Initializer
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
        fetchUserData()
    }
    
    // MARK: - Data Fetching
    
    private func fetchUserData() {
        let userRepository = UserRepository(context: viewContext)
        
        do {
            if let user = userRepository.getUser() {
                firstName = user.firstName
                lastName = user.lastName
            } else {
                errorMessage = UserDataViewModelError.userNotFound.localizedDescription
                firstName = "Invité"
                lastName = "Utilisateur"
            }
        } catch {
            errorMessage = UserDataViewModelError.fetchingUserFailed.localizedDescription
        }
    }
}
