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
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: AddExerciseViewModel
    @State private var showAlert = false
    var onExerciseAdded: () -> Void
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "#FFF9EC")
                    .ignoresSafeArea()
                
                VStack {
                    ZStack {
                        Color(hex: "#FFF9EC")
                        Form {
                            Section(header: Text("Quel type d'exercice ? ")) {
                                Picker("Catégorie", selection: $viewModel.category) {
                                    ForEach(WorkoutSession.Category.allCases, id: \.rawValue) { category in
                                        Text(category.rawValue).tag(category)
                                    }
                                }
                            }.listRowBackground(Color(hex: "#FFFFFF"))
                            
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
                            }.listRowBackground(Color(hex: "#FFFFFF"))
                            Section {
                                DatePicker("Heure de démarrage", selection: $viewModel.start, displayedComponents: [.date, .hourAndMinute])
                            }.listRowBackground(Color(hex: "#FFFFFF"))
                        }
                        .padding(.top, 14.0)
                        .scrollContentBackground(.hidden)
                    }
                    .cornerRadius(12)
                    
                    Spacer()
                    
                    Button("Ajouter l'exercice") {
                        if !viewModel.addExercise(onExerciseAdded: onExerciseAdded) {
                            showAlert = true
                        } else {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    .buttonStyle(.automatic)
                    .font(Font.custom("Outfit", size: 25))
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "#BC1C20"))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                }
            }
            .toolbar{
                ToolbarItem(placement: .topBarLeading) {
                    Text("Nouvel Exercice ...")
                        .font(Font.custom("Outfit", size: 30))
                        .font(.largeTitle)
                        .fontWeight(.medium)
                        .foregroundColor(Color(hex: "#BC1C20"))
                        .padding(.top, 22.0)
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Erreur"),
                    message: Text(viewModel.errorMessage ?? "Une erreur inconnue est survenue."),
                    dismissButton: .default(Text("OK"))
                )
            }
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
