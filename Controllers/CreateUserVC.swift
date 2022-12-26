//
//  CreateUserVC.swift
//  TodoList
//
//  Created by 한지훈 on 2022/11/21.
//

import Foundation
import UIKit
import SwiftUI
import SnapKit

struct CreateUserVCPreView: PreviewProvider {
    static var previews: some View {
        CreateUserVC().toPreview()
    }
}

class CreateUserVC: UIViewController {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Create Account"
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.textColor = .black
        
        return label
    }()
    
    lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Create an account and manage your TodoList"
        label.font = .systemFont(ofSize: 17)
        label.textColor = .black
        
        return label
    }()
    
    lazy var emailLabel: UILabel = {
        let label = createLabel("Email")
        return label
    }()
    
    lazy var passwordLabel: UILabel = {
        let label = createLabel("Password")
        return label
    }()
    
    lazy var nameLabel: UILabel = {
        let label = createLabel("Name")
        return label
    }()
    
    lazy var ageLabel: UILabel = {
        let label = createLabel("Age")
        return label
    }()
    
    lazy var emailTextField: UITextField = {
        let tf = createTextField()
        return tf
    }()
    
    lazy var passwdTextField: UITextField = {
        let tf = createTextField()
        return tf
    }()
    
    lazy var ageTextField: UITextField = {
        let tf = createTextField()
        return tf
    }()
    
    lazy var nameTextField: UITextField = {
        let tf = createTextField()
        return tf
    }()
    
    lazy var checkPasswordTextField: UITextField = {
       let tf = createTextField()
        
        return tf
    }()
    
    lazy var checkPasswordLabel: UILabel = {
        let label = createLabel("Re-Enter Password")
        
        return label
    }()
    
    lazy var createAccountButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Create Your TodoList Account", for: .normal)
        btn.backgroundColor = .blue
        btn.layer.cornerRadius = 10
        btn.addTarget(self, action: #selector(didTapAccountBtn(_:)), for: .touchUpInside)
        return btn
    }()
    
    @objc func didTapAccountBtn(_ sender: UIButton) {
        
        guard let email = emailTextField.text else {return}
        guard let name = nameTextField.text else {return}
        guard let age = Int(ageTextField.text ?? "") else {return}
        guard let passwd = passwdTextField.text else {return}
        
        let user = User(email: email, passwd: passwd, age: age, name: name)
        
        ApiManager.shared.createAccunt(user, completion: { response in
            if response {
                print("Create Account Success!!")
                self.navigationController?.popViewController(animated: true)
            }
        })
            
    }
    
    func createLabel(_ text: String) -> UILabel{
        let label = UILabel()
        label.text = text
        label.textColor = .black
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.sizeToFit()
        
        return label
    }
    
    func createTextField() -> UITextField {
        let tf = UITextField()
        tf.backgroundColor = .white
        tf.layer.borderWidth = CGFloat(0.5)
        tf.layer.borderColor = UIColor.black.cgColor
    
        return tf
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.title = "Create Account!"
        configureUI()
        setAutoLayout()
    }
    
    func configureUI() {
        [subTitleLabel, emailLabel, emailTextField, nameLabel, nameTextField, ageTextField, ageLabel, passwordLabel, passwdTextField, checkPasswordTextField, checkPasswordLabel, createAccountButton].forEach{view.addSubview($0)}
    }
    
    func setAutoLayout() {
    
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(120)
            $0.left.equalToSuperview().offset(15)
        }
        
        nameTextField.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(10)
            $0.left.equalToSuperview().offset(15)
            $0.height.equalTo(35)
            $0.width.equalTo(300)
        }
        
        ageLabel.snp.makeConstraints {
            $0.top.equalTo(nameTextField.snp.bottom).offset(30)
            $0.left.equalToSuperview().offset(15)
        }
        
        ageTextField.snp.makeConstraints {
            $0.top.equalTo(ageLabel.snp.bottom).offset(10)
            $0.left.equalToSuperview().offset(15)
            $0.height.equalTo(35)
            $0.width.equalTo(300)
        }

        emailLabel.snp.makeConstraints {
            $0.top.equalTo(ageTextField.snp.bottom).offset(30)
            $0.left.equalToSuperview().offset(15)
        }
        
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom).offset(10)
            $0.left.equalToSuperview().offset(15)
            $0.height.equalTo(35)
            $0.width.equalTo(300)
        }

        passwordLabel.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(30)
            $0.left.equalToSuperview().offset(15)
        }
        
        passwdTextField.snp.makeConstraints {
            $0.top.equalTo(passwordLabel.snp.bottom).offset(10)
            $0.left.equalToSuperview().offset(15)
            $0.height.equalTo(35)
            $0.width.equalTo(300)
        }

        checkPasswordLabel.snp.makeConstraints {
            $0.top.equalTo(passwdTextField.snp.bottom).offset(30)
            $0.left.equalToSuperview().offset(15)
        }
        
        checkPasswordTextField.snp.makeConstraints {
            $0.top.equalTo(checkPasswordLabel.snp.bottom).offset(10)
            $0.left.equalToSuperview().offset(15)
            $0.height.equalTo(35)
            $0.width.equalTo(300)
        }
        
        createAccountButton.snp.makeConstraints {
            $0.top.equalTo(checkPasswordTextField.snp.bottom).offset(25)
            $0.width.equalTo(300)
            $0.left.equalToSuperview().offset(15)
        }
    }
}
