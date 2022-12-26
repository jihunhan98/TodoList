//
//  FirstVC.swift
//  TodoList
//
//  Created by 한지훈 on 2022/11/21.
//

import Foundation
import SwiftUI
import SnapKit
import UIKit
import Toast

struct LoginVCPreView: PreviewProvider {
    static var previews: some View {
        LoginVC().toPreview()
    }
}

var loginUser = ApiInfo()

class LoginVC: UIViewController {
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Login or Create Your Account"
        label.textColor = .black
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 25, weight: .bold)
        
        return label
    }()
    
    lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.sizeToFit()
        
        return label
    }()
    
    lazy var passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Password"
        label.textColor = .black
        label.font = .systemFont(ofSize: 17, weight: .regular)
        
        return label
    }()
    
    lazy var emailTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .white
        tf.layer.borderWidth = 1.0
        tf.layer.borderColor = UIColor.black.cgColor
        
        return tf
    }()
    
    lazy var passwdTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .white
        tf.layer.borderWidth = 1.0
        tf.layer.borderColor = UIColor.black.cgColor
        
        return tf
    }()
    
    lazy var loginButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Login", for: .normal)
        btn.layer.cornerRadius = 10
        btn.backgroundColor = .red
        btn.addTarget(self, action: #selector(didTapLoginButton(_:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var createButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Create Account", for: .normal)
        btn.layer.cornerRadius = 10
        btn.backgroundColor = .green
        btn.addTarget(self, action: #selector(didTapCreateButton(_:)), for: .touchUpInside)
        
        return btn
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        
        return view
    }()
    
    @objc func didTapLoginButton(_ sender: UIButton) {
        
        if self.emailTextField.text == "" {
            view.makeToast("이메일을 입력하세요!")
        }
        
        else if self.passwdTextField.text == "" {
            view.makeToast("비밀번호를 입력하세요!")
        }
        else {
            ApiManager.shared.loginAccount(email: emailTextField.text ?? "", password: passwdTextField.text ?? "" , completion: { response in
                loginUser = response    //login 정보 전역변수로 저장.
                
                let vc = MainVC()
                let navController = UINavigationController(rootViewController: vc)
                navController.modalTransitionStyle = .coverVertical
                navController.modalPresentationStyle = .fullScreen
                
                self.present(navController, animated: true)
            })}
    }
    
    @objc func didTapCreateButton(_ sender: UIButton) {
        let vc = CreateUserVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setNavigationBar()
        configUI()
        setAutoLayout()
    }
    
    private func configUI() {
        [emailLabel, descriptionLabel, passwordLabel, emailTextField, passwdTextField, loginButton, createButton, lineView].forEach {view.addSubview($0)}
    }
    
    private func setAutoLayout() {
        descriptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(70)
            $0.left.equalToSuperview().offset(20)
            $0.height.equalTo(150)
            $0.width.equalTo(150)
        }
        
        emailLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(15)
            $0.left.equalToSuperview().offset(20)
        }
        
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom).offset(5)
            $0.left.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
        
        passwordLabel.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(15)
            $0.left.equalToSuperview().offset(20)
        }
        
        passwdTextField.snp.makeConstraints {
            $0.top.equalTo(passwordLabel.snp.bottom).offset(5)
            $0.left.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
        
        loginButton.snp.makeConstraints {
            $0.top.equalTo(passwdTextField.snp.bottom).offset(20)
            $0.width.equalTo(300)
            $0.height.equalTo(50)
            $0.centerX.equalToSuperview()
        }
        
        lineView.snp.makeConstraints {
            $0.top.equalTo(loginButton.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(10)
            $0.height.equalTo(1)
        }
        
        createButton.snp.makeConstraints {
            $0.top.equalTo(lineView).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(300)
            $0.height.equalTo(50)
        }
    }
}
private extension LoginVC {
    func setNavigationBar(){
        configureNavigationTitle()
        configureNavigationButton()
    }
    
    func configureNavigationTitle(){
        self.title = "TodoList!"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 25)]
    }
    
    func configureNavigationButton(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: nil)
    }
}
