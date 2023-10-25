

import Foundation

struct NoteModel: Codable { //codable para implementar a json de manera mas facil
    let id: String
    var isFavorited: Bool
    let description: String
    
    init(id: String = UUID().uuidString,
         isFavorited: Bool = false,
         description: String) {
        
        self.id = id
        self.isFavorited = isFavorited
        self.description = description
        
    }
}



