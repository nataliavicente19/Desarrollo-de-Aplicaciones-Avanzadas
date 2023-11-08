//
//  CoinsViewModel.swift
//  ConversorMonedasApp
//
//  Created by nati on 20/10/23.
//

import Foundation
import SwiftUI

struct ExchangeRateResponse: Codable{
    let conversion_rates: [String: Double]
    let base_code: String
    let time_last_update_utc: String
}

class CoinsViewModel: ObservableObject {
    
        @Published var amount: String = ""
        @Published var baseCurrency: String = "EUR" //por defecto
        @Published var targetCurrency: String = "USD" //por defecto
        @Published var rate: Double = 0.9
        @Published var result: String = "Resultado de la conversión"
        
        static let shared = CoinsViewModel()
        let apiKey = "56c78716d2974e9400933fdc"
        
        func fetchRate(){
            guard let url = URL(string: "https://v6.exchangerate-api.com/v6/\(apiKey)/latest/\(baseCurrency)") else {
                return
            }
            
            URLSession.shared.dataTask(with: url){ data, response, error in
                if let data = data {
                    let decoder = JSONDecoder()
                    do{
                        let response = try decoder.decode(ExchangeRateResponse.self, from: data)
                        DispatchQueue.main.async {
                            self.rate = response.conversion_rates[self.targetCurrency] ?? 0.0
                            self.convert()
                        }
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                }
            }.resume()
        }
        
        func convert(){
            guard let amountValue = Double(amount) else{
                result = "Introduce una cantidad válida"
                return
            }
            let convertedAmount = amountValue * rate
            result = "\(convertedAmount) \(targetCurrency)"
            
        }
        
}

