//
//  Model.swift
//  Beer App
//
//  Created by Natalia Vicente on 10/12/23.
//

import Foundation

struct Review: Codable, Identifiable, Hashable {
    let id: String
    let beer: Beer // Referencia a la cerveza asociada a la reseña
    var rating: Int // Puntuación de la reseña
    var description: String // Descripción de la reseña
    var date: Date // Fecha de la reseña
    
    init(id: String = UUID().uuidString,
         beer: Beer,
         rating: Int,
         description: String,
         date: Date) {
        
        self.id = id
        self.beer = beer
        self.rating = rating
        self.description = description
        self.date = date
    }
    
}


//datos cervezas

struct Beer: Codable, Identifiable, Hashable {
    
    let id: String
    var name: String
    var type: String
    var alcoholContent: String
    var calories: String
    var logoImageData: Data?
    var reviews: [Review]
    
    init(id: String = UUID().uuidString,
         name: String,
         type: String,
         alcoholContent: String,
         calories: String,
         logoImageData: Data?,
         reviews: [Review]) {
        
        self.id = id
        self.name = name
        self.type = type
        self.alcoholContent = alcoholContent
        self.calories = calories
        self.logoImageData = logoImageData
        self.reviews = reviews
    }
}

//Datos fabricante

struct ManufacturerModel: Codable, Identifiable, Hashable {
    let id: String
    var name: String
    var isImported: Bool
    var logoImageData: Data?
    var beers: [Beer]
    
    init(id: String = UUID().uuidString,
         name: String,
         isImported: Bool = false,
         logoImageData: Data?,
         beers: [Beer]) {
        
        self.id = id
        self.name = name
        self.isImported = isImported
        self.logoImageData = logoImageData
        self.beers = beers
        
    }
}

