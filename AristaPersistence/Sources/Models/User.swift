//
//  User.swift
//  AristaModels
//
//  Created by Margot Pasquali on 06/11/2024.
//

import Foundation

// MARK: - User Structure
public struct User {
    
    // MARK: - Properties
    public let id: UUID
    public let firstName: String
    public let lastName: String
    public let passwordHash: String
    public let exercises: [WorkoutSessionEntity]
    public let sleeps: [SleepSessionEntity]
    
    // MARK: - Initializer
    /// Initializes a `User` with the given attributes.
    public init(
        id: UUID,
        firstName: String,
        lastName: String,
        passwordHash: String,
        exercises: [WorkoutSessionEntity],
        sleeps: [SleepSessionEntity]
    ) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.passwordHash = passwordHash
        self.exercises = exercises
        self.sleeps = sleeps
    }
}
