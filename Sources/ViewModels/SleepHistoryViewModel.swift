//
//  SleepHistoryViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import Foundation
import CoreData
import AristaPersistence

// MARK: - SleepHistoryViewModel

final class SleepHistoryViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var sleepSessions = [SleepSession]()
    
    // MARK: - Core Data Context
    
    private var viewContext: NSManagedObjectContext
    
    // MARK: - Initializer
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
        fetchSleepSessions()
    }
    
    // MARK: - Fetching Data
    
    private func fetchSleepSessions() {
        do {
            let repository = SleepSessionRepository(context: viewContext)
            sleepSessions = try repository.getSleepSessions()
        } catch {
            print("Erreur lors de la récupération des sessions de sommeil: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Fake Data for Preview

    struct FakeSleepSession: Identifiable {
        var id = UUID()
        var startDate: Date = Date()
        var duration: Int = 695
        var quality: Int = (0...10).randomElement()!
    }
}
