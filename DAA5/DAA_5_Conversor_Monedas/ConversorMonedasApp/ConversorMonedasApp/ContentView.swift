//
//  ContentView.swift
//  ConversorMonedasApp
//
//  Created by nati on 20/10/23.
//

import SwiftUI

struct ContentView: View {
    //@State var descriptionCoin: String = "" //conexion entre modelo y vista
    @StateObject var coinsViewModel = CoinsViewModel()
    
    @State private var selection = "EUR/USD" //por defecto
    let divisas = ["EUR/USD", "EUR/BRL", "USD/BRL"]
    
    @State var divisa1: String = ""
    @State var divisa2: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Selecciona la divisa")
                    .underline()
                    .foregroundColor(.black)
                    .padding(.horizontal, 16)
                Picker("Seleccionar divisa", selection: $selection){
                    ForEach(divisas, id: \.self){
                        Text($0)
                    }
                }
                .pickerStyle(.menu)
                HStack{
                    if(selection == "EUR/USD"){
                        TextField("EUR", text: $divisa1)
                            .padding(.horizontal, 60)
                        TextField("USD", text: $divisa2)
                            .padding()
                    }
                    if(selection == "EUR/BRL"){
                        TextField("EUR", text: $divisa1)
                            .padding(.horizontal, 60)
                        TextField("BRL", text: $divisa2)
                            .padding()
                    }
                    if(selection == "USD/BRL"){
                        TextField("USD", text: $divisa1)
                            .padding(.horizontal, 60)
                        TextField("BRL", text: $divisa2)
                            .padding()
                    }
                }
                Button("Convertir"){
                    coinsViewModel.convertir_divisa(divisa1: divisa1, divisa2: divisa2, selection: selection)
                }
                .buttonStyle(.borderedProminent)
                .tint(.cyan)
                
                Spacer()
            }
            .navigationTitle("Conversor de divisas")
            .navigationBarTitleDisplayMode(.inline)
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
