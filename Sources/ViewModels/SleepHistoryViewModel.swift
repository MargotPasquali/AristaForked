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
    
    // MARK: - Enums
    
    enum SleepHistoryViewModelError: Error {
        case fetchingSleepSessionsError
        
        var localizedDescription: String {
            switch self {
            case .fetchingSleepSessionsError:
                return "Erreur lors de la récupération des sessions de sommeil."
            }
        }
    }
    
    // MARK: - Published Properties
    
    @Published var sleepSessions = [SleepSession]()
    @Published var errorMessage: String?
    
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
            errorMessage = SleepHistoryViewModelError.fetchingSleepSessionsError.localizedDescription
        }
    }
}
