//
//  AddListVC.swift
//  wwdd
//
//  Created by 한지훈 on 2022/11/17.
//

import UIKit
import SwiftUI
import SnapKit
import Alamofire
import Toast

struct AddListPreview: PreviewProvider {
    static var previews: some View {
        AddListVC().toPreview()
    }
}

class AddListVC: UIViewController {
 
    var dataClosure: (() -> Void)?
    
    lazy var taskTextField: UITextField = {
       let tf = UITextField()
        tf.placeholder = "Input your task"
        tf.textColor = .black
        tf.font = .systemFont(ofSize: 25, weight: .bold)

        return tf
    }()
    
    lazy var uploadButton: UIButton = {
       let btn = UIButton()
        btn.setTitle("Upload   ⇧", for: .normal)
        btn.backgroundColor = .blue
        btn.layer.cornerRadius = 15
        btn.addTarget(self, action: #selector(didTapUpload(_:)), for: .touchUpInside)
        
        return btn
    }()
    
    @objc private func didTapUpload(_ sender: UIButton) {
 
        if self.taskTextField.text == "" {
            view.makeToast("아무것도 입력하지 않았습니다.")
            return
        }
        else {
            if selectedIndexPath == -1 {
               createTodo()
            } else {
                    updateTodo()
                }
            }
    }
    
    private func createTodo() {
        
        let new_todo = Todo(id: todoList.count + 1, content: self.taskTextField.text ?? "")
        
        ApiManager.shared.createTodoList(new_todo) { response in
            print("new TodoList's todoId = \(response)")
            self.dataClosure?()
            self.dismiss(animated: true)
        }
    }
    
    private func updateTodo() {
        
        var todo = todoList[selectedIndexPath]
        todo.content = self.taskTextField.text ?? ""
        
        print("todoId : \(todo.id)")
    
        ApiManager.shared.updateTodoList(todo) { response in
            if response {
                print("Update Success!")
                self.dataClosure?()
                self.dismiss(animated: true)
            }
        }
    }
    
    override func viewDidLoad() {
        
        //Half Modal
        if let sheetPresentationController = sheetPresentationController {
            sheetPresentationController.detents = [.medium(), .large()]
        }
        
        //Update시에 해당 index의 정보 가져오기
        if selectedIndexPath >= 0 {
            self.taskTextField.text = todoList[selectedIndexPath].content
        }
        
        view.backgroundColor = .white
        configureUI()
        setAutoLayout()
    }
    
    private func configureUI() {
        [taskTextField, uploadButton].forEach { view.addSubview($0)}
    }
    
    private func setAutoLayout() {
        taskTextField.snp.makeConstraints {
            $0.top.equalToSuperview().inset(30)
            $0.height.equalTo(100)
            $0.width.equalTo(view.bounds.width - 20)
            $0.centerX.equalToSuperview()
        }
       
        uploadButton.snp.makeConstraints {
            $0.width.equalTo(170)
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview().inset(20)
            $0.right.equalToSuperview().inset(20)
            
        }
    }
}

