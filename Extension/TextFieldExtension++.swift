import UIKit

//TextField의 이미지를 넣기위한 Padding 추가, Image추가 Extension
extension UITextField {
    func addLeftPadding() {
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: frame.height))
        self.leftView = padding
        self.leftViewMode = .always
    }
    
    func addLeftImage(_ image: UIImage) {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 5, height: image.size.height))
        imageView.image = image
        self.leftView = imageView
        self.leftViewMode = .always
    }
}
