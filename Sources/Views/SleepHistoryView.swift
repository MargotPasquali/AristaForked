//
//  SleepHistoryView.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import SwiftUI
import AristaPersistence

// MARK: - SleepHistoryView

struct SleepHistoryView: View {
    
    // MARK: - Properties
    
    @ObservedObject var viewModel: SleepHistoryViewModel

    // MARK: - Body
    
    var body: some View {
        List(viewModel.sleepSessions) { session in
            sessionRow(for: session)
        }
        .navigationTitle("Historique de Sommeil")
    }

    // MARK: - Subviews
    
    private func sessionRow(for session: SleepSession) -> some View {
        HStack {
            QualityIndicator(quality: session.quality)
                .padding()
            VStack(alignment: .leading) {
                Text("Début : \(session.start.formatted())")
                Text("Durée : \(session.duration / 60) heures") // Affichage en heures
            }
        }
    }
}

// MARK: - QualityIndicator View

struct QualityIndicator: View {
    
    // MARK: - Properties
    
    let quality: Int64

    // MARK: - Body
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(qualityColor(quality), lineWidth: 5)
                .foregroundColor(qualityColor(quality))
                .frame(width: 30, height: 30)
            Text("\(quality)")
                .foregroundColor(qualityColor(quality))
        }
    }

    // MARK: - Helper Functions

    func qualityColor(_ quality: Int64) -> Color {
        switch (10 - quality) {
        case 0...3:
            return .green
        case 4...6:
            return .yellow
        case 7...10:
            return .red
        default:
            return .gray
        }
    }
}

// MARK: - Preview

#Preview {
    SleepHistoryView(viewModel: SleepHistoryViewModel(context: PersistenceController.preview.container.viewContext))
}
