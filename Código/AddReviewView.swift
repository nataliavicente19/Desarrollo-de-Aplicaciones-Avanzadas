//
//  AddReviewView.swift
//  Beer App
//
//  Created by Natalia Vicente on 20/12/23.
//

import Foundation
import SwiftUI

struct AddReviewView: View {
    @ObservedObject var viewModel: ViewModel // ViewModel que gestiona las reseñas
    var beer: Beer // La cerveza asociada a esta reseña
    @Binding var isAddingReview: Bool // Binding para controlar la presentación de la vista
    
    @State private var rating = 3 // Puntuación inicial
    @State private var description = ""
    @State private var showingImagePicker = false
    @State private var selectedImage: UIImage?

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Puntuación")) {
                    Stepper(value: $rating, in: 1...5) {
                        Text("Puntuación: \(rating)")
                    }
                }

                Section(header: Text("Descripción")) {
                    TextEditor(text: $description)
                        .frame(minHeight: 100)
                }
                
                Section {
                    Button("Guardar") {
                        let newReview = Review(
                            beer: beer,
                            rating: rating,
                            description: description,
                            date: Date()
                        )
                        viewModel.addReview(newReview, to: beer.id)
                        isAddingReview = false
                    }
                }
            }
            .navigationTitle("Nueva Reseña")
            .navigationBarItems(leading:
                Button(action: {
                    isAddingReview = false
                }) {
                    Image(systemName: "chevron.left")
                        .imageScale(.large)
                }
            )
        }
    }
}
