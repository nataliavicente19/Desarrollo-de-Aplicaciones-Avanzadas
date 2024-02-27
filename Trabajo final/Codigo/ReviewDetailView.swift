//
//  ReviewDetailView.swift
//  Beer App
//
//  Created by Natalia Vicente on 20/12/23.
//

import Foundation
import SwiftUI

struct ReviewDetailView: View {
    @ObservedObject var viewModel: ViewModel
    var review: Review
    var beer: Beer
    
    @State private var isEditing = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            VStack(alignment: .leading, spacing: 8) {
                Text("Puntuación:")
                    .font(.headline)
                Text("\(review.rating)")
                    .foregroundColor(.secondary)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Descripción:")
                    .font(.headline)
                Text("\(review.description)")
                    .foregroundColor(.secondary)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Fecha:")
                    .font(.headline)
                Text("\(formattedDate(review.date))")
                    .foregroundColor(.secondary)
            }

            Spacer()

            HStack(spacing: 16) {
                Button(action: {
                    isEditing = true
                }) {
                    Text("Editar")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(8)
                }

                Button(action: {
                    viewModel.deleteReview(review.id, from: beer.id)
                }) {
                    Text("Eliminar")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(8)
                }
            }
            .padding(.bottom, 16)
        }
        .padding()
        .sheet(isPresented: $isEditing) {
                    EditReviewView(viewModel: viewModel, review: review, beer: beer)
        }
        .navigationBarTitle("Detalles de la Reseña")
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
