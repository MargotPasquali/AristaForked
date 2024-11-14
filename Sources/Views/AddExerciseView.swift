//
//  AddExerciseView.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import SwiftUI
import AristaPersistence

// MARK: - AddExerciseView

struct AddExerciseView: View {
    
    // MARK: - Environment & Observed Properties
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: AddExerciseViewModel
    var onExerciseAdded: () -> Void
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            VStack {
                // MARK: Form Section
                Form {
                    Section(header: Text("Quel type d'exercice ? ")) {
                        Picker("Catégorie", selection: $viewModel.category) {
                            ForEach(WorkoutSession.Category.allCases, id: \.rawValue) { category in
                                Text(category.rawValue).tag(category)
                            }
                        }
                    }
                    Section(header: Text("Détails")) {
                        HStack {
                            Text("Durée (en minutes)")
                            Spacer()
                            TextField("15", value: $viewModel.duration, formatter: NumberFormatter())
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                        }
                        HStack {
                            Text("Intensité (0 à 10)")
                            Spacer()
                            TextField("7", value: $viewModel.intensity, formatter: NumberFormatter())
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                        }
                    }
                    
                    DatePicker("Heure de démarrage", selection: $viewModel.start, displayedComponents: [.date, .hourAndMinute])
                }
                .formStyle(.grouped)
                
                
                Spacer()
                
                // MARK: Action Button
                Button("Ajouter l'exercice") {
                    if viewModel.addExercise(onExerciseAdded: onExerciseAdded) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .buttonStyle(.borderedProminent)
                
            }
            .navigationTitle("Nouvel Exercice ...")
        }
    }
}

// MARK: - Preview

#Preview {
    AddExerciseView(
        viewModel: AddExerciseViewModel(context: PersistenceController.preview.container.viewContext),
        onExerciseAdded: {} // Closure vide pour le paramètre onExerciseAdded
    )
}
