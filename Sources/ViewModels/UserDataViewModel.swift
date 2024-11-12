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
    
    // MARK: - Published Properties
    
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    
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
                print("User not found. Utilisation des valeurs par défaut.")
                firstName = "Invité"
                lastName = "Utilisateur"
            }
        } catch {
            print("Erreur lors de la récupération des données utilisateur : \(error)")
        }
    }
}
