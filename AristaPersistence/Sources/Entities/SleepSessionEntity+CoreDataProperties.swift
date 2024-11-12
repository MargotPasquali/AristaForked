//
//  SleepSessionEntity+CoreDataProperties.swift
//  
//
//  Created by Margot Pasquali on 06/11/2024.
//
//

import Foundation
import CoreData

// MARK: - SleepSessionEntity Extension for Core Data Properties
extension SleepSessionEntity {

    // MARK: - Fetch Request
    @nonobjc public class func fetchRequest() -> NSFetchRequest<SleepSessionEntity> {
        return NSFetchRequest<SleepSessionEntity>(entityName: "SleepSession")
    }

    // MARK: - Attributes
    @NSManaged public var id: UUID
    @NSManaged public var duration: Int64
    @NSManaged public var quality: Int64
    @NSManaged public var start: Date

    // MARK: - Relationships
    @NSManaged public var user: UserEntity?
}
