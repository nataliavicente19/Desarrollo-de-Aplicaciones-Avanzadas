//
//  ContentView.swift
//  HelloSwiftUI
//
//  Created by nati on 29/9/23.
//

import SwiftUI

struct ContentView: View {
    var emojis = ["👻","💩","🐹","🇨🇳"]
    var body: some View {
        NavigationStack{
            VStack{
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))], spacing: 2){
                    ForEach(0..<4, id: \.self){
                        index in
                        Box(content: emojis[index] )
                            .aspectRatio(2/3, contentMode: .fit)
                    }
                }
                //Text("xd")
                
                NavigationLink(destination: SecondView(), label: {
                    Text("Second view")
                        .foregroundColor(.blue)
                        .padding(.top)
                })
            }
            .foregroundColor(.gray)
            .padding()
        }
    }
}


struct Box: View {
    @State var visible:Bool = true
    var content:String
    var body: some View {
        ZStack {
            if(visible){
                RoundedRectangle(cornerRadius: 10)
                Text(content).imageScale(.large)
                    .aspectRatio(1/2, contentMode: .fit)
            }else{
                RoundedRectangle(cornerRadius: 10)
            }
        }.onTapGesture {
            print("hola")
            self.visible.toggle()
            print(visible)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
