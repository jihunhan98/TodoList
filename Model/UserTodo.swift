// get UserInfo

import Foundation

struct UserTodo: Codable {
    var email: String
    var age: Int
    var name: String
    var todoList: [Todo]
}
