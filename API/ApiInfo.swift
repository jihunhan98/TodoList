//
//  ApiInfo.swift
//  TodoList
//
//  Created by 한지훈 on 2022/11/23.
//

import Foundation

struct ApiInfo: Codable {
    var memberId: Int
    var token: String
    
    init(memberId: Int, token: String) {
        self.memberId = memberId
        self.token = token
    }
    
    init() {
        self.memberId = -1
        self.token = ""
    }
}
