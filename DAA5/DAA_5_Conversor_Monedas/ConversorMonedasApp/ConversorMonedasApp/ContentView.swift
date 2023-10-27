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
    
    private let currencyCodes = ["USD", "EUR", "JPY", "GBP"]
    
    var body: some View {
        
        VStack(spacing:20) {
            TextField("Cantidad", text: $viewModel.amount).multilineTextAlignment(.center)
                .keyboardType(.decimalPad)
                .padding()
                .border(Color.gray, width: 0.5)
            
            HStack{
                Picker("Desde [Moneda]", selection: $viewModel.baseCurrency){
                    ForEach(currencyCodes, id: \.self){ currency in
                        Text(currency)
                    }
                } .pickerStyle(MenuPickerStyle())
                
                Text("➡️").foregroundColor(.blue)
                
                Picker("A [Moneda]", selection: $viewModel.targetCurrency){
                    ForEach(currencyCodes, id: \.self){ currency in
                        Text(currency)
                    }
                } .pickerStyle(MenuPickerStyle())
            }
            
            Button("Convertir"){
                viewModel.fetchRate()
                print(viewModel.amount)
            }
            .padding(20)
            .frame(height: 50)
            .foregroundColor(.white)
            .background(Color.blue.opacity(0.7))
            .cornerRadius(10)
               
            Text(viewModel.result).multilineTextAlignment(.center).foregroundColor(.gray)
                
        }.padding()
        .navigationTitle("Conversor de divisas")
        .navigationBarTitleDisplayMode(.inline)
        
        }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
