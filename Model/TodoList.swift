//TodoList

import Foundation

struct Todo: Codable {
    var createdAt: String = ""
    var updatedAt: String = ""
    var id: Int // TodoID
    var content: String
    var isCompleted: Bool = false
    
    init(id: Int, content: String) {
        self.id = id
        self.content = content
    }
}

