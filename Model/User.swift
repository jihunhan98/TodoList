//UserAccount

import Foundation

struct User: Codable {
    var email: String
    var passwd: String
    var age: Int
    var name: String
    
    init(email: String, passwd: String, age: Int, name: String) {
        self.email = email
        self.passwd = passwd
        self.age = age
        self.name = name
    }
}
