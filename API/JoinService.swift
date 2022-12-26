//
//  JoinService.swift
//  TodoList
//
//  Created by 한지훈 on 2022/11/21.
//

import Foundation
import UIKit
import Alamofire
import SwiftUI

class JoinService {
    static let shared = JoinService()
    
    func join(member: MyMembrer, completion: @escaping(Bool) -> Void) {
        let url = ApiConstants.baseURL + "new"
        let header: HTTPHeaders = ["Content-Type" : "application/json"]
        let body: Parameters = ["age" : MyMembrer.age, "email" : MyMembrer.email, "name" : MyMembrer.name, "password" : MyMembrer.password]
        let request = AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header)
        
        request.responseData { response in
            switch response.result {
            case .success:
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }
}
