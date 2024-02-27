//
//  AddManufacturerView.swift
//  Beer App
//
//  Created by Natalia Vicente on 20/12/23.
//

import Foundation
import SwiftUI

struct AddManufacturerView: View {
    @Environment(\.presentationMode) var presentationMode
        var viewModel: ViewModel
        
        @State private var nameManufacturer: String = ""
        @State private var isImportedManufacturer: Bool = false
        @State private var logoNameManufacturer: String = ""
        
        @State private var selectedImage: UIImage?
        @State private var isShowingImagePicker = false
        
        init(viewModel: ViewModel) {
            self.viewModel = viewModel
        }
        
        var body: some View {
            NavigationView {
                Form {
                    Section(header: Text("Nuevo Fabricante")) {
                        //datos
                        TextField("Nombre", text: $nameManufacturer)
                        Toggle("Importada", isOn: $isImportedManufacturer)
                        
                        Button("Seleccionar Logo") {
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
                    
                    Section {
                        //Boton guardar
                        Button(action: {
                            guard let imageData = selectedImage?.pngData() else { return }
                            viewModel.saveManufacturer(
                                name: nameManufacturer,
                                isImported: isImportedManufacturer,
                                imageData: imageData // Pasa la imagen como Data al ViewModel
                            )
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Guardar")
                        }
                    }
                }
                .navigationBarTitle("Añadir Fabricante")
            }
        }
}
