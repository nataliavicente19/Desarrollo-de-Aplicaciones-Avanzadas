import SwiftUI

struct BeerDetailView: View {
    @ObservedObject var viewModel: ViewModel
    @State private var editedBeer: Beer
    @State private var selectedImage: UIImage?
    @State private var isShowingImagePicker = false
    @Environment(\.presentationMode) var presentationMode
    var beer: Beer

    init(viewModel: ViewModel, beer: Beer) {
        self.viewModel = viewModel
        self._editedBeer = State(initialValue: beer)
        self.beer = beer
    }

    var body: some View {
        VStack {
            Form {
                //Informacion
                Section(header: Text("Detalles de la cerveza")) {
                    TextField("Nombre", text: $editedBeer.name)
                    TextField("Tipo", text: $editedBeer.type)
                        .textContentType(.oneTimeCode)
                        .keyboardType(.default)
                    TextField("Contenido de alcohol", text: $editedBeer.alcoholContent)
                        .keyboardType(.decimalPad)
                    TextField("Calorías", text: $editedBeer.calories)
                        .keyboardType(.numberPad)
                    HStack {
                        if let imageData = selectedImage ?? UIImage(data: beer.logoImageData ?? Data()) {
                            Image(uiImage: imageData)
                                .resizable()
                                .frame(width: 50, height: 50)
                                .cornerRadius(8)
                        }
                        Spacer()
                        Button(action: { isShowingImagePicker.toggle() }) {
                            Text("Cambiar Imagen")
                        }
                        .sheet(isPresented: $isShowingImagePicker) {
                            ImagePicker(selectedImage: $selectedImage)
                        }
                        .padding()
                    }
                }
                //Aceptar
                Button(action: {
                    if let image = selectedImage {
                        editedBeer.logoImageData = image.jpegData(compressionQuality: 0.5)
                    }
                    viewModel.updateBeerDetails(editedBeer)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Aceptar")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
            .navigationTitle("Detalles de la cerveza")
            //Ir a las reviews
            .navigationBarItems(trailing:
                NavigationLink(destination: ReviewsListView(beer: beer, viewModel: viewModel)) {
                    Image(systemName: "text.bubble")
                        .imageScale(.large)
                        .padding(.vertical)
                        .foregroundColor(.blue)
                }
            )
        }
    }
}
