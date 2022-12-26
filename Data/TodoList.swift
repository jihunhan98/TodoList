import Foundation

struct TodoList: Codable {
    var title: String
    var count: Int
    var checkCompleted = false
    var name: String
    init(title: String, name: String, count: Int) {
        self.title = title
        self.name = name
        self.count = count
    }
}

