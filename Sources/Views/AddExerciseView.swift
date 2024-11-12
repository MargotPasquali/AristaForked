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
                    TextField("Catégorie", text: $viewModel.category)
                    DatePicker("Heure de démarrage", selection: $viewModel.start, displayedComponents: [.date, .hourAndMinute])
                    TextField("Durée (en minutes)", value: $viewModel.duration, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                    TextField("Intensité (0 à 10)", value: $viewModel.intensity, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
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
