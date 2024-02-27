import Foundation
import SwiftUI

struct ReviewsListView: View {
    var beer: Beer
    @ObservedObject var viewModel: ViewModel
    @State private var showingAddReview = false
    @State private var isShowingSortOptions = false
    @State private var searchText = ""

    var body: some View {
        VStack {
            //Barra de busqueda para filtrar
            SearchBar(searchText: $searchText)
                .padding(.horizontal)
                .padding(.top, 8)
            
            List {
                ForEach(beer.reviews.filter {
                    searchText.isEmpty || $0.description.localizedCaseInsensitiveContains(searchText)
                }) { review in
                    NavigationLink(destination: ReviewDetailView(viewModel: viewModel, review: review, beer: beer)) {
                        //Informacion
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Puntuación: \(review.rating)")
                                .font(.headline)
                            Text("Descripción: \(review.description)")
                                .foregroundColor(.secondary)
                            Text("Fecha: \(formattedDate(review.date))")
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 8)
                    }
                }
                
                Button(action: {
                    showingAddReview = true
                }) { //Boton agregar resena
                    Text("Agregar Reseña")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.horizontal, 20)
                }
                .sheet(isPresented: $showingAddReview) {
                    AddReviewView(viewModel: viewModel, beer: beer, isAddingReview: $showingAddReview)
                }
            }//Ordenar Resena
            .actionSheet(isPresented: $isShowingSortOptions) {
                ActionSheet(title: Text("Ordenar por"), buttons: [
                    .default(Text("Descripcion Ascendente")) {
                        viewModel.sortReviews("description", ascending: true, for: beer.id)
                    },
                    .default(Text("Descripcion Descendente")) {
                        viewModel.sortReviews("description", ascending: false, for: beer.id)
                    },
                    .default(Text("Nota Ascendente")) {
                        viewModel.sortReviews("rating", ascending: true, for: beer.id)
                    },
                    .default(Text("Nota Descendente")) {
                        viewModel.sortReviews("rating", ascending: false, for: beer.id)
                    },
                    .default(Text("Fecha Ascendente")) {
                        viewModel.sortReviews("date", ascending: true, for: beer.id)
                    },
                    .default(Text("Fecha Descendente")) {
                        viewModel.sortReviews("date", ascending: false, for: beer.id)
                    },
                    .cancel()
                ])
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Reseñas de \(beer.name)")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isShowingSortOptions = true
                    }) {
                        Image(systemName: "arrow.up.arrow.down")
                    }
                }
            }
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
