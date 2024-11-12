//
//  SleepSession.swift
//  AristaModels
//
//  Created by Margot Pasquali on 06/11/2024.
//

import Foundation

// MARK: - SleepSession Structure
public struct SleepSession: Identifiable {

    // MARK: - Properties
    public let id: UUID
    public let duration: Int64
    public let quality: Int64
    public let start: Date

    // MARK: - Initializer
    /// Initializes a `SleepSession` with specified attributes.
    public init(id: UUID, duration: Int64, quality: Int64, start: Date) {
        self.id = id
        self.duration = duration
        self.quality = quality
        self.start = start
    }
}
