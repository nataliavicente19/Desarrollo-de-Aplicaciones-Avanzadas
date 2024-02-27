//
//  EditReviewView.swift
//  Beer App
//
//  Created by Natalia Vicente on 20/12/23.
//

import Foundation
import SwiftUI

struct EditReviewView: View {
    @ObservedObject var viewModel: ViewModel
    var review: Review
    var beer: Beer
    @State private var editedReview: Review
    
    @Environment(\.presentationMode) var presentationMode // Para controlar la presentación de la vista
    
    init(viewModel: ViewModel, review: Review, beer: Beer) {
        self.viewModel = viewModel
        self.review = review
        self.beer = beer
        _editedReview = State(initialValue: review)
    }
    
    var body: some View {
        NavigationView {
            Form {
                HStack {
                    Text("Descripcion:")
                    TextField("Descripcion", text: $editedReview.description)
                }
                DatePicker("fecha", selection: $editedReview.date, displayedComponents: .date)
                Stepper(value: $editedReview.rating, in: 1...5) {
                    Text("Valoracion: \(editedReview.rating)")
                }
            }
            .navigationTitle("Editar Reseña")
            .navigationBarItems(
                leading: Button("Cancelar") {
                    presentationMode.wrappedValue.dismiss() // Cerrar la vista sin guardar cambios
                },
                trailing: Button("Guardar") {
                    viewModel.updateReviewDetails(editedReview, for: beer.id) // Guardar los cambios en la reseña
                    presentationMode.wrappedValue.dismiss() // Cerrar la vista después de guardar
                }
            )
        }
    }
}
