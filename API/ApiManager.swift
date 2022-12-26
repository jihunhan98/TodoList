//
//  ApiManager.swift
//  TodoList
//
//  Created by 한지훈 on 2022/11/23.
//

// https://velog.io/@parkgyurim/Swift-escaping-closure

import Alamofire
import Foundation

class ApiManager {
    
    let baseURL = "https://yj-todo.inuappcenter.kr/"
    
    static let shared = ApiManager()
    
    func createAccunt(_ user: User, completion: @escaping(Bool) -> Void) {
        let url = baseURL + "members/new"
        let header: HTTPHeaders = ["Content-Type" : "application/json"]
        let data: Parameters = ["age" : user.age, "email" : user.email, "name" : user.name, "password" : user.passwd]
        let request = AF.request(url, method: .post, parameters: data, encoding: JSONEncoding.default, headers: header)
        
        request.validate(statusCode: 200..<300).responseData{ response in
            print(response.response?.statusCode)
            switch response.result {
            case .success:
                completion(true)
            default:
                completion(false)
                print("Create Account Fail!")
            }
        }
    }
    
    func createTodoList(_ todo: Todo, completion: @escaping(String) -> Void) {
        let url = baseURL + "todo/new"
        let header: HTTPHeaders = ["Content-Type" : "application/json"]
        let data: Parameters = ["content": todo.content, "isCompleted": todo.isCompleted, "memberId": loginUser.memberId]
        let request = AF.request(url, method: .post, parameters: data, encoding: JSONEncoding.default, headers: header)
        
        request.validate(statusCode: 200..<300).responseString { response in
            guard let todoId = response.value else {return}
            
            switch response.result {
            case .success:
                completion(todoId)
                print("Add New TodoList Success!")
            case .failure:
                completion("22")
                print("Add new TodoList Fail!")
            }
        }
        
        
    }
    
    func loginAccount(email: String, password: String, completion: @escaping(ApiInfo) -> Void) {
        let url = baseURL + "members/login"
        let header: HTTPHeaders = ["Content-Type" : "application/json"]
        let data: Parameters = ["email" : email, "password" : password]
        
        let request = AF.request(url, method: .post, parameters: data, encoding: JSONEncoding.default, headers: header)
        request.validate(statusCode: 200..<300).responseString {response in
        }.responseDecodable(of: ApiInfo.self){ response in
            guard let loginUser = response.value else { return }
            
            switch response.result {
            case .success:
                completion(loginUser)
                print("Login Success!")
            case .failure:
                print("Login Fail")
            }
        }
    }
    
    func getTodoList(_ memberId: String, completion: @escaping([Todo]) -> Void) {
        let url = baseURL + "members/" + memberId
        let header: HTTPHeaders = ["Content-Type" : "application/json"]
        let request = AF.request(url, method: .get, encoding: JSONEncoding.default, headers: header)
        
        request.validate(statusCode: 200..<300).responseDecodable(of: UserTodo.self) { response in
            guard let statusCode = response.response?.statusCode else {return}
            guard let result = response.value else {return}
            
            switch response.result {
            case .success:
                completion(result.todoList) // UserTodo의 todoList만 보냄.
                print("Get TodoList Success")
            case .failure:
                print("StatusCode: \(statusCode) Get TodoList Fail")
            }
            
        }
    }
    
    func deleteTodoList(_ todoId: Int, completion: @escaping(Bool) -> Void) {
        let url = baseURL + "todo/" + String(todoId)
        let header: HTTPHeaders = ["Content-Type" : "application/json"]
        let request = AF.request(url, method: .delete, encoding: JSONEncoding.default, headers: header)
        
        request.validate(statusCode: 200..<300).responseData { response in
            guard let statusCode = response.response?.statusCode else { return }
            
            switch response.result {
            case .success:
                completion(true)
            case .failure:
                print("Delete Fail!!")
            }
        }
    }
    
    func updateTodoList(_ todoList: Todo, completion: @escaping(Bool) -> Void) {
        let url = baseURL + "todo/" + String(todoList.id)
        let header: HTTPHeaders = ["Content-Type" : "application/json"]
        let data: Parameters = ["content" : todoList.content, "isCompleted" : todoList.isCompleted]
        let request = AF.request(url, method: .put, parameters: data, encoding: JSONEncoding.default, headers: header)
        request.validate(statusCode: 200..<300).responseData { response in
            guard let statusCode = response.response?.statusCode else { return }
            switch response.result {
            case .success:
                completion(true)
            case .failure:
                print("Update Fail!!(StatusCode : \(statusCode)")
            }
        }
    }
}


        

