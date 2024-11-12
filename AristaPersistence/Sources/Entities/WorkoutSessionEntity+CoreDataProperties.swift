//
//  WorkoutSessionEntity+CoreDataProperties.swift
//  
//
//  Created by Margot Pasquali on 06/11/2024.
//
//

import Foundation
import CoreData

// MARK: - WorkoutSessionEntity Core Data Properties
extension WorkoutSessionEntity {

    // MARK: Fetch Request
    @nonobjc public class func fetchRequest() -> NSFetchRequest<WorkoutSessionEntity> {
        return NSFetchRequest<WorkoutSessionEntity>(entityName: "WorkoutSession")
    }
    
    // MARK: Attributes
    @NSManaged public var id: UUID
    @NSManaged public var category: String
    @NSManaged public var duration: Int64
    @NSManaged public var intensity: Int64
    @NSManaged public var start: Date?
    
    // MARK: Relationships
    @NSManaged public var user: UserEntity?
}
