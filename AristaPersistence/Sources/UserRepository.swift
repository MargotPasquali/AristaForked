//
//  UserRepository.swift
//  AristaPersistence
//
//  Created by Margot Pasquali on 06/11/2024.
//

import Foundation
import CoreData

// MARK: - UserRepository Protocol Definition
public protocol UserRepositoryProtocol {
    func getUser() -> UserEntity?
}

// MARK: - UserRepository Implementation
public struct UserRepository: UserRepositoryProtocol {
    
    // MARK: Properties
    private let context: NSManagedObjectContext
    
    // MARK: Initializer
    public init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
    }
    
    // MARK: Public Methods
    
    // Fetches a User model object from Core Data
    public func getUser() -> UserEntity? {
        let request = UserEntity.fetchRequest()
        request.fetchLimit = 1
        
        guard let userEntity = try? context.fetch(request).first else {
            return nil
        }
        
        return userEntity
    }
    
}
