//
//  UserDataView.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import SwiftUI
import AristaPersistence

// MARK: - UserDataView

struct UserDataView: View {
    @ObservedObject var viewModel: UserDataViewModel
    
    var body: some View {
        ZStack {
            Color(hex: "#FFF9EC")
                .ignoresSafeArea()
            VStack(alignment: .leading) {
                Spacer()
                Text("Bonjour")
                    .font(Font.custom("Outfit", size: 40))
                    .foregroundColor(Color(hex: "#C8A095"))
                    .font(.largeTitle)
                    .multilineTextAlignment(.leading)
                Text("\(viewModel.firstName) \(viewModel.lastName)")
                    .font(Font.custom("Outfit", size: 35))
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "#BC1C20"))
                    .padding()
                    .scaleEffect(1.2)
                    .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: UUID())
                Spacer()
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}


// MARK: - Preview
#Preview {
    UserDataView(viewModel: UserDataViewModel(context: PersistenceController.preview.container.viewContext))
}
