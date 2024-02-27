//
//  ContentView.swift
//  Beer App
//
//  Created by Natalia Vicente on 10/12/23.
//

import SwiftUI
import UIKit

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    @State private var selectedManufacturer: ManufacturerModel? //var detecta el fabricante seleccionado
    
    //variables a pasar al modelo
    @State var nameManufacturer: String = ""
    @State var isImportedManufacturer: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                List {
                    if (viewModel.manufacturers.count >= 1) { //>0 para que muestre si hay o no fabricantes
                        //SECCION DE NACIONALES
                        Section(header: Text("Nacionales")) {
                            ForEach($viewModel.manufacturers, id: \.id) { $manufacturer in
                                if !manufacturer.isImported {
                                    //Si selecciona un fabricante
                                    NavigationLink(destination: BeersView(manufacturer: manufacturer, viewModel: viewModel),
                                        tag: manufacturer,
                                        selection: $selectedManufacturer) {
                                        //apartado foto y nombre
                                        HStack {
                                           if let imageData = manufacturer.logoImageData,
                                              let uiImage = UIImage(data: imageData) {
                                                    Image(uiImage: uiImage)
                                                    .resizable()
                                                    .frame(width: 50, height: 50)
                                                }
                                           Text(manufacturer.name)
                                        }
                                        //accion de borrar deslizando
                                        .swipeActions(edge: .leading) {
                                            Button {
                                                viewModel.removeManufacturer(withId: manufacturer.id)
                                            } label : {
                                                Label("Borrar", systemImage: "trash.fill")
                                            }
                                            .tint(.red)
                                        }
                                    }
                                }
                            }
                        }
                        //SECCION DE IMPORTADAS
                        Section(header: Text("Importadas")) {
                            ForEach($viewModel.manufacturers, id: \.id) { $manufacturer in
                                if manufacturer.isImported {
                                    NavigationLink(destination: BeersView(manufacturer: manufacturer, viewModel: viewModel),
                                        tag: manufacturer,
                                        selection: $selectedManufacturer) {
                                        
                                        HStack {
                                            if let imageData = manufacturer.logoImageData,
                                                let uiImage = UIImage(data: imageData) {
                                                    Image(uiImage: uiImage)
                                                    .resizable()
                                                    .frame(width: 50, height: 50)
                                                } 
                                            Text(manufacturer.name)
                                        }
                                        .swipeActions(edge: .leading) {
                                            Button {
                                                viewModel.removeManufacturer(withId: manufacturer.id)
                                            } label : {
                                                Label("Borrar", systemImage: "trash.fill")
                                            }
                                            .tint(.red)
                                        }
                                    }
                                }
                            }
                        }
                        
                    } else {
                        Text("No hay fabricantes")
                    }
                    
                }
            }.navigationTitle("Lista de fabricantes") //titulo de arriba del todo
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(trailing:
                NavigationLink(destination: AddManufacturerView(viewModel: viewModel)) {
                Image(systemName: "plus")
                })
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}





















