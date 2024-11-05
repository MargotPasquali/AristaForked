//
//  SleepSession+CoreDataProperties.swift
//  AristaModels
//
//  Created by Margot Pasquali on 05/11/2024.
//
//

import Foundation
import CoreData


extension SleepSession {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SleepSession> {
        return NSFetchRequest<SleepSession>(entityName: "SleepSession")
    }

    @NSManaged public var start: Date?
    @NSManaged public var duration: Int16
    @NSManaged public var quality: Int16
    @NSManaged public var user: User?

}

extension SleepSession : Identifiable {

}
