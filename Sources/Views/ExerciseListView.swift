//
//  ExerciseListView.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import SwiftUI
import AristaPersistence

// MARK: - ExerciseListView

struct ExerciseListView: View {
    
    // MARK: - Properties
    
    @ObservedObject var viewModel: ExerciseListViewModel
    @State private var showingAddExerciseView = false
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            List(viewModel.exercises) { exercise in
                exerciseRow(for: exercise)
                    .listRowBackground(Color(hex: "#FFF9EC"))
                    .listRowSeparator(.hidden)
                
                
            }
            .listStyle(PlainListStyle())
            .scrollContentBackground(.hidden)
            .background(Color(hex: "#FFF9EC")
                .ignoresSafeArea())
            .toolbar{
                ToolbarItem(placement: .topBarLeading) {
                    Text("Exercices")
                        .font(Font.custom("Outfit", size: 25))
                        .font(.largeTitle)
                        .fontWeight(.medium)
                        .foregroundColor(Color(hex: "#BC1C20"))
                }
            }
            .navigationBarItems(trailing: addExerciseButton)
            .sheet(isPresented: $showingAddExerciseView) {
                AddExerciseView(
                    viewModel: AddExerciseViewModel(context: viewModel.viewContext)) {
                        viewModel.fetchExercises() // Rafraîchit la liste après ajout d’un exercice
                    }
            }
        }

    }
    
    
    // MARK: - Subviews
    
    private func exerciseRow(for exercise: WorkoutSession) -> some View {
        HStack {
            Image(systemName: iconForCategory(exercise.category.rawValue))
            VStack(alignment: .leading) {
                Text(exercise.category.rawValue)
                    .font(.headline)
                Text("Durée: \(Int64(exercise.duration)) min")
                    .font(.subheadline)
                Text(exercise.start.formatted())
                    .font(.subheadline)
            }
            Spacer()
            IntensityIndicator(intensity: Int64(exercise.intensity))
        }
    }
    
    private var addExerciseButton: some View {
        Button(action: {
            showingAddExerciseView = true
        }) {
            Image(systemName: "plus")
        }
    }
    
    // MARK: - Helper Functions
    
    func iconForCategory(_ category: String) -> String {
        switch category {
        case "Fitness":
            return "figure.mixed.cardio"
        case "Football":
            return "sportscourt"
        case "Swimming":
            return "figure.pool.swim"
        case "Running":
            return "figure.run"
        case "Walking":
            return "figure.walk"
        case "Biking":
            return "bicycle"
        case "Yoga":
            return "figure.yoga"
        case "Pilates":
            return "figure.pilates"
        default:
            return "questionmark"
        }
    }
}

// MARK: - IntensityIndicator View

struct IntensityIndicator: View {
    
    // MARK: - Properties
    
    var intensity: Int64  // Utilise Int64 pour la cohérence
    
    // MARK: - Body
    
    var body: some View {
        Circle()
            .fill(colorForIntensity(intensity))
            .frame(width: 10, height: 10)
    }
    
    // MARK: - Helper Functions
    
    func colorForIntensity(_ intensity: Int64) -> Color {
        switch intensity {
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
    ExerciseListView(viewModel: ExerciseListViewModel(context: PersistenceController.preview.container.viewContext))
}
