//
//  CustomButton.swift
//  TodoList
//
//  Created by 한지훈 on 2022/11/28.
//

import Foundation
import UIKit

class CustomButton: UIButton {
    
    init() {
        super.init(frame: CGRect.zero)
    
        self.setImage(nil, for: .normal)
        self.backgroundColor = .white
        self.layer.borderWidth = 2.0
        self.layer.cornerRadius = 15
        self.layer.borderColor = UIColor.blue.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func isCompleted(_ completed: Bool) {
        if completed {

            self.tintColor = .white
            self.layer.borderColor = UIColor.white.cgColor
            self.setImage(UIImage(systemName: "checkmark"), for: .normal)
            self.backgroundColor = .lightGray
        }
    
        else {
            
                self.setImage(nil, for: .normal)
                self.backgroundColor = .white
                self.layer.borderWidth = 2.0
                self.layer.borderColor = UIColor.blue.cgColor
        }
    }
}
