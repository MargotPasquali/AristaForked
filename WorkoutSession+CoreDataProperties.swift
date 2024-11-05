//
//  WorkoutSession+CoreDataProperties.swift
//  AristaModels
//
//  Created by Margot Pasquali on 05/11/2024.
//
//

import Foundation
import CoreData


extension WorkoutSession {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WorkoutSession> {
        return NSFetchRequest<WorkoutSession>(entityName: "WorkoutSession")
    }

    @NSManaged public var start: Date?
    @NSManaged public var duration: Int16
    @NSManaged public var intensity: Int16
    @NSManaged public var category: workoutCategory
    @NSManaged public var user: User?

}

extension WorkoutSession : Identifiable {

}

extension WorkoutSession {
    var workoutCategory: workoutCategory {
        get {
            return workoutCategory(rawValue: self.category ?? "") ?? .autre
        }
        set {
            self.category = newValue.rawValue
        }
    }
}
