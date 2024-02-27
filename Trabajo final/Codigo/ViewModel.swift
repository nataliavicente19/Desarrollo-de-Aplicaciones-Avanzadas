//
//  ViewModel.swift
//  Beer App
//
//  Created by Natalia Vicente on 10/12/23.
//

import Foundation
import SwiftUI

//enumeracion para ordenar
enum SortType {
    case name(ascending: Bool)
    case alcoholContent(ascending: Bool)
    case calories(ascending: Bool)
}

final class ViewModel: ObservableObject {
    @Published var manufacturers: [ManufacturerModel] = []
    
    init() {
        subscribeToAppEvents()
        loadData()
    }
    
    //Guardar FABRICANTE
    
    func saveManufacturer(name: String, isImported: Bool, imageData: Data?) {
        let newManufacturer = ManufacturerModel(
                    name: name,
                    isImported: isImported,
                    logoImageData: imageData,
                    beers: []
        )
        
        manufacturers.insert(newManufacturer, at: 0)
        // encodeAndSaveAllNotes()
    }
    
    //Borrar FABRICANTE
    
    func removeManufacturer(withId id: String) {
        manufacturers.removeAll(where: { $0.id == id })
        //encodeAndSaveAllNotes()
    }
    
    //Guardar CERVEZA
    
    func saveBeer(name: String, type: String, alcoholContent:String, calories: String, logoImageData: Data?, manufacturer: ManufacturerModel) {
        var modifiedManufacturer = manufacturer // Crear una copia mutable
            
            let newBeer = Beer(
                name: name,
                type: type,
                alcoholContent: alcoholContent,
                calories: calories,
                logoImageData: logoImageData,
                reviews: []
            )
            
            modifiedManufacturer.beers.insert(newBeer, at: 0) // Modificar la copia
            
            if let index = manufacturers.firstIndex(where: { $0.id == modifiedManufacturer.id }) {
                manufacturers[index] = modifiedManufacturer // Actualizar en la lista de fabricantes
            }
    }
    
    //Borrar CERVEZA
    
    func removeBeer(withId id: String) {
        for index in 0..<manufacturers.count {
                if let beerIndex = manufacturers[index].beers.firstIndex(where: { $0.id == id }) {
                    manufacturers[index].beers.remove(at: beerIndex)
                    return
                }
            }
    }
    
    //Ordenar CERVEZAS
    
    func sortBeers(_ sortBy: SortType, for manufacturerID: String) {
            guard let index = manufacturers.firstIndex(where: { $0.id == manufacturerID }) else { return }
            
            switch sortBy {
            case .name(let ascending):
                manufacturers[index].beers.sort { ascending ? $0.name < $1.name : $0.name > $1.name }
            case .alcoholContent(let ascending):
                manufacturers[index].beers.sort { ascending ? $0.alcoholContent < $1.alcoholContent : $0.alcoholContent > $1.alcoholContent }
            case .calories(let ascending):
                manufacturers[index].beers.sort { ascending ? $0.calories < $1.calories : $0.calories > $1.calories }
            }
        }
    
    func sortReviews(_ sortBy: String, ascending: Bool, for beerID: String) {
        for index in 0..<manufacturers.count {
            if let beerIndex = manufacturers[index].beers.firstIndex(where: { $0.id == beerID }) {
                switch sortBy {
                case "description":
                    manufacturers[index].beers[beerIndex].reviews.sort { ascending ? $0.description < $1.description : $0.description > $1.description }
                case "rating":
                    manufacturers[index].beers[beerIndex].reviews.sort { ascending ? $0.rating < $1.rating : $0.rating > $1.rating }
                case "date":
                    manufacturers[index].beers[beerIndex].reviews.sort { ascending ? $0.date < $1.date : $0.date > $1.date }
                // Agrega más casos para otros criterios de ordenación si es necesario
                default:
                    break
                }
                return
            }
        }
    }


    
    func updateBeerDetails(_ editedBeer: Beer) {
        for index in 0..<manufacturers.count {
            if let beerIndex = manufacturers[index].beers.firstIndex(where: { $0.id == editedBeer.id }) {
                manufacturers[index].beers[beerIndex] = editedBeer
                return
            }
        }
    }
    
    //REVIEWS
    
    func addReview(_ review: Review, to beerID: String) {
            for index in 0..<manufacturers.count {
                if let beerIndex = manufacturers[index].beers.firstIndex(where: { $0.id == beerID }) {
                    manufacturers[index].beers[beerIndex].reviews.append(review)
                    return
                }
            }
    }

    func editReview(_ review: Review, for beerID: String) {
            for index in 0..<manufacturers.count {
                if let beerIndex = manufacturers[index].beers.firstIndex(where: { $0.id == beerID }) {
                    if let reviewIndex = manufacturers[index].beers[beerIndex].reviews.firstIndex(where: { $0.id == review.id }) {
                        manufacturers[index].beers[beerIndex].reviews[reviewIndex] = review
                        return
                    }
                }
            }
        }
        
        // Función para eliminar una reseña
        func deleteReview(_ reviewID: String, from beerID: String) {
            for index in 0..<manufacturers.count {
                if let beerIndex = manufacturers[index].beers.firstIndex(where: { $0.id == beerID }) {
                    manufacturers[index].beers[beerIndex].reviews.removeAll(where: { $0.id == reviewID })
                    return
                }
            }
        }
    
    func updateReviewDetails(_ editedReview: Review, for beerID: String) {
        for index in 0..<manufacturers.count {
            if let beerIndex = manufacturers[index].beers.firstIndex(where: { $0.id == beerID }) {
                if let reviewIndex = manufacturers[index].beers[beerIndex].reviews.firstIndex(where: { $0.id == editedReview.id }) {
                    manufacturers[index].beers[beerIndex].reviews[reviewIndex] = editedReview
                    return
                }
            }
        }
    }
    
    // DATOS
    
    func hasLaunchedBefore() -> Bool {
        let hasBeenLaunchedBefore = UserDefaults.standard.bool(forKey: "hasBeenLaunchedBefore")
        print("El valor de hasBeenLaunchedBefore es: \(hasBeenLaunchedBefore)")
        return hasBeenLaunchedBefore
    }
       
    
    func setAppLaunched() {
        UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
    }
    
    
    func subscribeToAppEvents() {
        NotificationCenter.default.addObserver(self, selector: #selector(saveDataOnAppExit), name: UIApplication.willResignActiveNotification, object: nil)
        print("Se han agregado observadores para eventos de la app")
    }

    
    @objc func saveDataOnAppExit() {
        print("La app está siendo minimizada o cerrada. Guardando datos...")
        saveDataToDocuments()
    }
    
    
    func loadData() {
            if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileURL = documentsDirectory.appendingPathComponent("Manufacturers.json")
                
                /*if hasLaunchedBefore() {
                    // Si es la primera vez, cargar datos del bundle
                    print("PRIMERA VEZ")
                    loadManufacturersFromBundle()
                } else */if FileManager.default.fileExists(atPath: fileURL.path) {
                    print("YA ACCEDI, ABRO DOCUMENTOS")
                    // Si no es la primera vez y hay datos en Documents, cargar desde allí
                    loadManufacturersFromJSON(fileURL: fileURL)

                } else {
                    // Si no es la primera vez pero no hay datos en Documents, cargar del bundle
                    print("YA ACCEDI, ABRO BUNDLE")
                    loadManufacturersFromBundle()
                }
            }
        }
    
    
    func loadManufacturersFromJSON(fileURL: URL) {
        do {
            let jsonData = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            let decodedManufacturers = try decoder.decode([ManufacturerModel].self, from: jsonData)
            self.manufacturers = decodedManufacturers
        } catch {
            print("Error cargando datos desde el archivo JSON en Documents: \(error.localizedDescription)")
        }
    }
        
    
    func loadManufacturersFromBundle() {
        if let path = Bundle.main.path(forResource: "Manufacturers", ofType: "json") {
            do {
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: path))
                let decoder = JSONDecoder()
                let decodedManufacturers = try decoder.decode([ManufacturerModel].self, from: jsonData)
                self.manufacturers = decodedManufacturers
                setAppLaunched()
            } catch {
                print("Error cargando datos desde el bundle: \(error.localizedDescription)")
            }
        }
    }
    
    
    func saveDataToDocuments() {
        if let encodedData = try? JSONEncoder().encode(manufacturers) {
            if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileURL = documentsDirectory.appendingPathComponent("Manufacturers.json")
                do {
                    try encodedData.write(to: fileURL)
                    print("Datos guardados correctamente en \(fileURL)")
                } catch {
                    print("Error al guardar datos en Documents: \(error)")
                }
            }
        }
    }
        
}


