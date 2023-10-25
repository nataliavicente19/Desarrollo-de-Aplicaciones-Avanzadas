//
//  ContentView.swift
//  TodoListApp
//
//  Created by Luis Augusto Silva on 20/10/23.
//

import SwiftUI

struct ContentView: View {
    @State var descriptionNote: String = "" //conexion entre modelo y vista
    @StateObject var notesViewModel = NotesViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Añade una tarea")
                    .underline()
                    .foregroundColor(.gray)
                    .padding(.horizontal, 16)
                TextEditor(text: $descriptionNote)
                    .foregroundColor(.gray)
                    .frame(height: 100)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.green, lineWidth: 2)
                    )
                    .padding(.horizontal, 12)
                    .cornerRadius(3.0)
                Button("Crear") { //crea el acceso al modelo
                    notesViewModel.saveNote(description: descriptionNote)
                    descriptionNote = "" //para que no se quede el mismo estado
                }
                .buttonStyle(.bordered)
                .tint(.green) //dar tono al boton
                
                Spacer()
                List {
                    if ($notesViewModel.notes.count > 1) { //>1 para que quede mas estetico y no tan pegado
                        ForEach($notesViewModel.notes, id: \.id) { $note in //para hacer el binding uso $, esta usando la de NoteModel por si alguien la cambia se cambia aqui
                            HStack {
                                if note.isFavorited {
                                    Text("⭐️")
                                }
                                Text(note.description)
                            }
                            .swipeActions(edge: .trailing) { //acciones adicionales para deslizar, cada Hstack tendra esa accion. Trailing izq a derecha el deslizamiento.
                                Button {
                                    notesViewModel.updateFavoriteNote(note: $note)
                                } label : {
                                    Label("Favorito", systemImage: "star.fill")
                                }
                                .tint(.yellow)
                            }
                            .swipeActions(edge: .leading) {
                                Button {
                                    notesViewModel.removeNote(withId: note.id)
                                } label : {
                                    Label("Borrar", systemImage: "trash.fill")
                                }
                                .tint(.red)
                            }
                        }
                    } else {
                        Text("No hay tareas")
                    }
                
                    
                }
            }
            .navigationTitle("TODO") //titulo de arriba del todo
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Text(notesViewModel.getNumberOfNotes())
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            //.preferredColorScheme(.dark)
    }
}
