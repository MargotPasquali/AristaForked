//
//  EntitiesTransformationToModels.swift
//  AristaMapping
//
//  Created by Margot Pasquali on 11/11/2024.
//

import Foundation
import CoreData

// MARK: - Mapping Functions

// MARK: User Mapping
public func mapToUser(from entity: UserEntity) -> User {
    print("Mapping UserEntity to User")
    return User(
        id: entity.id,
        firstName: entity.firstName,
        lastName: entity.lastName,
        passwordHash: entity.passwordHash,
        exercises: (entity.exercises.allObjects as? [WorkoutSessionEntity]) ?? [],
        sleeps: (entity.sleeps.allObjects as? [SleepSessionEntity]) ?? []
    )
}

// MARK: WorkoutSession Mapping
public func mapToWorkoutSession(from entity: WorkoutSessionEntity) -> WorkoutSession? {
    guard let start = entity.start else {
        print("Mapping WorkoutSessionEntity to WorkoutSession failed: 'start' is nil.")
        return nil
    }

    guard let category = WorkoutSession.Category(rawValue: entity.category) else {
        print("Mapping WorkoutSessionEntity to WorkoutSession failed: Invalid category '\(entity.category)' in Core Data.")
        return nil
    }

    guard let user = entity.user else {
        print("Mapping WorkoutSessionEntity to WorkoutSession failed: 'user' is nil.")
        return nil
    }
    
    print("Mapping WorkoutSessionEntity to WorkoutSession succeeded")
    return WorkoutSession(
        id: entity.id,
        category: category,
        duration: entity.duration,
        intensity: entity.intensity,
        start: start
    )
}

// MARK: SleepSession Mapping
public func mapToSleepSession(from entity: SleepSessionEntity) -> SleepSession? {
    guard let user = entity.user else {
        print("Mapping SleepSessionEntity to SleepSession failed: User is nil.")
        return nil
    }

    print("Mapping SleepSessionEntity to SleepSession succeeded")
    return SleepSession(
        id: entity.id,
        duration: entity.duration,
        quality: entity.quality,
        start: entity.start
    )
}
