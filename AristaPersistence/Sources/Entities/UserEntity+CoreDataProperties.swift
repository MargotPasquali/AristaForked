//
//  UserEntity+CoreDataProperties.swift
//  
//
//  Created by Margot Pasquali on 06/11/2024.
//
//

import Foundation
import CoreData

// MARK: - UserEntity Core Data Properties
extension UserEntity {

    // MARK: Fetch Request
    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        return NSFetchRequest<UserEntity>(entityName: "User")
    }
    
    // MARK: Attributes
    @NSManaged public var id: UUID
    @NSManaged public var firstName: String
    @NSManaged public var lastName: String
    @NSManaged public var passwordHash: String

    // MARK: Relationships
    @NSManaged public var exercises: NSSet
    @NSManaged public var sleeps: NSSet
}

// MARK: - Generated Accessors for Relationships
extension UserEntity {

    // MARK: Exercises Accessors
    @objc(addExercisesObject:)
    @NSManaged public func addToExercises(_ value: WorkoutSessionEntity)

    @objc(removeExercisesObject:)
    @NSManaged public func removeFromExercises(_ value: WorkoutSessionEntity)

    @objc(addExercises:)
    @NSManaged public func addToExercises(_ values: NSSet)

    @objc(removeExercises:)
    @NSManaged public func removeFromExercises(_ values: NSSet)
    
    // MARK: Sleeps Accessors
    @objc(addSleepsObject:)
    @NSManaged public func addToSleeps(_ value: SleepSessionEntity)

    @objc(removeSleepsObject:)
    @NSManaged public func removeFromSleeps(_ value: SleepSessionEntity)

    @objc(addSleeps:)
    @NSManaged public func addToSleeps(_ values: NSSet)

    @objc(removeSleeps:)
    @NSManaged public func removeFromSleeps(_ values: NSSet)
}
