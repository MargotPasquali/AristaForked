//
//  User+CoreDataProperties.swift
//  AristaModels
//
//  Created by Margot Pasquali on 05/11/2024.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var motDePasseHash: String?
    @NSManaged public var sleeps: NSSet?
    @NSManaged public var excercises: NSSet?

}

// MARK: Generated accessors for sleeps
extension User {

    @objc(addSleepsObject:)
    @NSManaged public func addToSleeps(_ value: SleepSession)

    @objc(removeSleepsObject:)
    @NSManaged public func removeFromSleeps(_ value: SleepSession)

    @objc(addSleeps:)
    @NSManaged public func addToSleeps(_ values: NSSet)

    @objc(removeSleeps:)
    @NSManaged public func removeFromSleeps(_ values: NSSet)

}

// MARK: Generated accessors for excercises
extension User {

    @objc(addExcercisesObject:)
    @NSManaged public func addToExcercises(_ value: WorkoutSession)

    @objc(removeExcercisesObject:)
    @NSManaged public func removeFromExcercises(_ value: WorkoutSession)

    @objc(addExcercises:)
    @NSManaged public func addToExcercises(_ values: NSSet)

    @objc(removeExcercises:)
    @NSManaged public func removeFromExcercises(_ values: NSSet)

}

extension User : Identifiable {

}
