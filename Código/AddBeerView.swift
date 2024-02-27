//
//  AddBeerView.swift
//  Beer App
//
//  Created by Natalia Vicente on 20/12/23.
//

import Foundation
import SwiftUI

struct AddBeerView: View {
    @ObservedObject var viewModel: ViewModel
    var manufacturer: ManufacturerModel
    @Binding var isAddingBeer: Bool
    
    @State private var beerName = ""
    @State private var type = ""
    @State private var alcoholContent = ""
    @State private var calories = ""
    
    @State private var selectedImage: UIImage? // Variable para almacenar la imagen seleccionada
    @State private var isShowingImagePicker = false
    
    var body: some View {
        NavigationView {
            Form {
                //Anadir los datos
                Section(header: Text("Detalles de la cerveza")) {
                    TextField("Nombre", text: $beerName)
                    TextField("Tipo", text: $type)
                    TextField("Contenido de alcohol", text: $alcoholContent)
                    TextField("Calorías", text: $calories)
                    
                    Button("Seleccionar Imagen") {
                        isShowingImagePicker.toggle()
                    }
                    .sheet(isPresented: $isShowingImagePicker) {
                        ImagePicker(selectedImage: $selectedImage)
                    }
                    
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 200)
                    }
                }
                
                //Guardar
                Section {
                    Button(action: {
                        guard let imageData = selectedImage?.pngData() else { return }
                        viewModel.saveBeer(name: beerName, type: type, alcoholContent: alcoholContent, calories: calories, logoImageData: imageData, manufacturer: manufacturer)
                        
                        isAddingBeer = false
                    }) {
                        Text("Guardar")
                    }
                }
            }
            .navigationTitle("Añadir Cerveza")
            //Boton hacia atras
            .navigationBarItems(leading:
                Button(action: {
                    isAddingBeer = false
                }) {
                    Image(systemName: "chevron.left")
                        .imageScale(.large)
                }
            )
        }
    }
}
