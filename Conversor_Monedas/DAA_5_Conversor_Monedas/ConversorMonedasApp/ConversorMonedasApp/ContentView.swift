//
//  ContentView.swift
//  ConversorMonedasApp
//
//  Created by nati on 20/10/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var coinsViewModel = CoinsViewModel()
    @ObservedObject var viewModel = CoinsViewModel.shared
    
    private let currencyCodes = ["USD", "EUR", "GBP", "JPY"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Seleccione las divisas")) {
                    TextField("Introduzca la cantidad", text: $viewModel.amount).keyboardType(.decimalPad)
                    
                    Picker("Desde  ➡️", selection: $viewModel.baseCurrency){
                        ForEach(currencyCodes, id: \.self){ currency in
                            Text(currency)
                        }
                    } .pickerStyle(MenuPickerStyle())
                    
                    Picker("A  ⬅️", selection: $viewModel.targetCurrency){
                        ForEach(currencyCodes, id: \.self){ currency in
                            Text(currency)
                        }
                    } .pickerStyle(MenuPickerStyle())
                }
                
                
                Section(header: Text("Resultado")){
                    Text(viewModel.result).multilineTextAlignment(.center).foregroundColor(.gray)
                                        
                    Button("Convertir"){
                        viewModel.fetchRate()
                        print(viewModel.amount)
                    }
                    .padding(20)
                    .frame(height: 50)
                    .foregroundColor(.white)
                    .background(Color.blue.opacity(0.7))
                    .cornerRadius(10)
                }
            }
            .navigationTitle("CONVERSOR DE DIVISAS 💰")//.font(.system(size: 20))
            .navigationBarTitleDisplayMode(.inline)
        }
        //.padding()
    }
}
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
