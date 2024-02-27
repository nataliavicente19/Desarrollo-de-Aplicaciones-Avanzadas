//
//  BeersView.swift
//  Beer App
//
//  Created by Natalia Vicente on 20/12/23.
//

import Foundation
import SwiftUI

struct BeersView: View {
    var manufacturer: ManufacturerModel
    @ObservedObject var viewModel: ViewModel
    @State private var isShowingSortOptions = false
    @State private var isAddingBeer = false
    @State private var searchText = ""
    @State private var selectedBeer: Beer?
    @State private var activeSheet: ActiveSheet = .none
    @Environment(\.presentationMode) var presentationMode
    
    
    enum ActiveSheet {
        case none, addBeer, beerDetail
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    //Boton para volver hacia atras
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title)
                            .foregroundColor(.blue)
                            .padding(.leading, 8) // Ajustar el espacio a la izquierda
                    }
                    Spacer()
                    //Nombre del fabricante
                    Text(manufacturer.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                    //Boton para ordenar
                    Button(action: {
                        isShowingSortOptions = true
                    }) {
                        Image(systemName: "arrow.up.arrow.down")
                            .font(.title)
                            .padding(.trailing)
                    }
                }
                .padding(.top, 8)
                .padding(.bottom, 4)
                .background(Color(UIColor.systemBackground))

                SearchBar(searchText: $searchText)
                    .padding(.horizontal)
                    .padding(.bottom, 8)

                List {
                    ForEach(Array(groupedBeers.keys.sorted()), id: \.self) { key in
                        Section(header: Text(key)) {
                            ForEach(groupedBeers[key]!.filter {
                                searchText.isEmpty || $0.name.localizedCaseInsensitiveContains(searchText)
                            }) { beer in
                                BeerRow(beer: beer, viewModel: viewModel)
                                    .swipeActions(edge: .trailing) {
                                        Button {
                                            // Eliminar la cerveza
                                            if let index = manufacturer.beers.firstIndex(where: { $0.id == beer.id }) {
                                                viewModel.removeBeer(withId: beer.id)
                                            }
                                        } label: {
                                            Label("Eliminar", systemImage: "trash")
                                        }
                                        .tint(.red)
                                    }
                            }
                        }
                    }
                }
                
                .navigationTitle("")
                .navigationBarHidden(true)
                
                //Boton anadir cerveza
                Button(action: {
                    isAddingBeer = true
                }) {
                    Text("Añadir cerveza")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.blue)
                        .cornerRadius(25)
                        .padding(.horizontal)
                }
                //Ir a anadir cerveza
                .sheet(isPresented: $isAddingBeer) {
                    AddBeerView(viewModel: viewModel, manufacturer: manufacturer, isAddingBeer: $isAddingBeer)
                }
                //Ir a detalles de pulsar cerveza
                .sheet(item: $selectedBeer) { beer in
                    BeerDetailView(viewModel: viewModel, beer: beer)
                }

                Spacer()
            }
            //ordenar las cervezas
            .actionSheet(isPresented: $isShowingSortOptions) {
                ActionSheet(title: Text("Ordenar por"), buttons: [
                    .default(Text("Nombre Ascendente")) {
                        viewModel.sortBeers(.name(ascending: true), for: manufacturer.id)
                    },
                    .default(Text("Nombre Descendente")) {
                        viewModel.sortBeers(.name(ascending: false), for: manufacturer.id)
                    },
                    .default(Text("Graduación Alcohólica Ascendente")) {
                        viewModel.sortBeers(.alcoholContent(ascending: true), for: manufacturer.id)
                    },
                    .default(Text("Graduación Alcohólica Descendente")) {
                        viewModel.sortBeers(.alcoholContent(ascending: false), for: manufacturer.id)
                    },
                    .default(Text("Aporte Calórico Ascendente")) {
                        viewModel.sortBeers(.calories(ascending: true), for: manufacturer.id)
                    },
                    .default(Text("Aporte Calórico Descendente")) {
                        viewModel.sortBeers(.calories(ascending: false), for: manufacturer.id)
                    },
                    .cancel()
                ])
            }
        }.navigationBarBackButtonHidden(true)
    }
    
    private var groupedBeers: [String: [Beer]] {
        Dictionary(grouping: manufacturer.beers, by: { $0.type })
    }
}

//Mostrar informacion de la cerveza

struct BeerRow: View {
    var beer: Beer
    var viewModel: ViewModel // Agrega viewModel como parámetro
    
    @State private var isActive = false
    
    var body: some View {
        NavigationLink(destination: BeerDetailView(viewModel: viewModel, beer: beer), isActive: $isActive) {
            EmptyView()
        }
        .opacity(0)
        .background(
            Button(action: {
                isActive = true
            }) {
                HStack(spacing: 12) {
                    //Imagen
                    if let imageData = beer.logoImageData,
                       let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .frame(width: 50, height: 50)
                            .aspectRatio(contentMode: .fit) // Ajusta la relación de aspecto
                            .cornerRadius(8)
                            .padding(.vertical, 4) // Añade espacio arriba y abajo de la imagen
                            .padding(.leading, 4) // Elimina el espacio a la izquierda de la imagen
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        //Informacion
                        Text(beer.name)
                            .font(.headline)
                        HStack {
                            Text("Alcohol: \(beer.alcoholContent)")
                                .foregroundColor(.secondary)
                            Spacer()
                            Text("Calorías: \(beer.calories)")
                                .foregroundColor(.secondary)
                        }
                        .font(.subheadline)
                    }
                }
                .padding([.top, .bottom], 8) // Agrega espacio arriba y abajo de cada sección de cerveza
                .padding(.trailing, 12) // Ajusta el espacio a la derecha para mantener el equilibrio visual
            }
            .background(Color.white) // Añade un fondo blanco para cada fila de cerveza
            .cornerRadius(8) // Redondea las esquinas de la fila de cerveza
        )
    }
}




