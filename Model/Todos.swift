//
//  Todos.swift
//  TodoList
//
//  Created by 한지훈 on 2022/11/26.
//

import Foundation

struct Todos: Codable {
    var todo: [Todo]
    var todoId: Int
    
    init() {
        self.todo = [Todo()]
        self.todoId = -1
    }
}
