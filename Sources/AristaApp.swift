//
//  AristaApp.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import SwiftUI
import AristaPersistence

// MARK: - AristaApp Definition

@main
struct AristaApp: App {
    
    // MARK: - Persistence Controller
    
    let persistenceController = PersistenceController.shared
    
    // MARK: - Scene Body
    
    var body: some Scene {
        WindowGroup {
            // MARK: - Main TabView
            
            TabView {
                // MARK: User Tab
                UserDataView(viewModel: UserDataViewModel(context: persistenceController.container.viewContext))
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .tabItem {
                        Label("Utilisateur", systemImage: "person")
                    }
                
                // MARK: Exercise Tab
                ExerciseListView(viewModel: ExerciseListViewModel(context: persistenceController.container.viewContext))
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .tabItem {
                        Label("Exercices", systemImage: "flame")
                    }
                
                // MARK: Sleep Tab
                SleepHistoryView(viewModel: SleepHistoryViewModel(context: persistenceController.container.viewContext))
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .tabItem {
                        Label("Sommeil", systemImage: "moon")
                    }
            }.accentColor(Color("Red"))

        }
    }
}
