import Foundation
import SwiftUI

final class NotesViewModel: ObservableObject {
    @Published var notes: [NoteModel] = []
    
    init() {
        notes = getAllNotes()
    }
    
    func saveNote(description: String) {
        let newNote = NoteModel(description: description)
        notes.insert(newNote, at: 0)
        //encodeAndSaveAllNotes()
    }
    
    private func encodeAndSaveAllNotes() { //coge las notas y las tranforma en json y las guarda en UserDefaults, es como una ñapa para no usar la bbdd
        if let encoded = try? JSONEncoder().encode(notes) {
            UserDefaults.standard.setValue(encoded, forKey: "notes")
            UserDefaults.standard.synchronize()
        }
    }
    
    func getAllNotes() -> [NoteModel] {
        if let notesData = UserDefaults.standard.object(forKey: "notes") as? Data {
            if let notes = try? JSONDecoder().decode([NoteModel].self, from: notesData) {
                return notes
            }
        }
        return []
    }
    
    func removeNote(withId id: String) {
        notes.removeAll(where: { $0.id == id })
        encodeAndSaveAllNotes()
    }
    
    func updateFavoriteNote(note: Binding<NoteModel>) {
        note.wrappedValue.isFavorited = !note.wrappedValue.isFavorited
        encodeAndSaveAllNotes()
    }
    
    func getNumberOfNotes() -> String {
        "\(notes.count)"
    }
}
