//
//  WorkoutSession.swift
//  AristaModels
//
//  Created by Margot Pasquali on 06/11/2024.
//

import Foundation

// MARK: - WorkoutSession Structure
public struct WorkoutSession: Identifiable {

    // MARK: - Category Enum
    public enum Category: String {
        case fitness = "Fitness"
        case swimming = "Swimming"
        case running = "Running"
        case riding = "Riding"
        case biking = "Biking"
        case yoga = "Yoga"
        case pilates = "Pilates"
        case football = "Football"
    }

    // MARK: - Properties
    public let id: UUID
    public let category: Category
    public let duration: Int64
    public let intensity: Int64
    public let start: Date

    // MARK: - Initializer
    public init(id: UUID, category: Category, duration: Int64, intensity: Int64, start: Date) {
        self.id = id
        self.category = category
        self.duration = duration
        self.intensity = intensity
        self.start = start
    }
}
