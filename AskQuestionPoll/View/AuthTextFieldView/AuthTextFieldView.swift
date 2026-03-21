//
//  AuthTextFieldView.swift
//  AskQuestionPoll
//
//  Created by OBMac-7 on 18/03/26.
//

import UIKit

class AuthTextFieldView: NibView {

    @IBOutlet weak var textfieldContainer: UIView!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var imgForTextField: UIImageView!
    @IBOutlet weak var actualTextField: UITextField!
    @IBOutlet weak var labelofView: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI(){
        textfieldContainer.backgroundColor = .systemGray3
        textfieldContainer.layer.cornerRadius = 4
        textfieldContainer.layer.borderWidth = 2
        textfieldContainer.clipsToBounds = true
        textfieldContainer.layer.borderColor = UIColor.white.cgColor
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: actualTextField.frame.height))
        actualTextField.leftView = paddingView
        actualTextField.leftViewMode = .always
        actualTextField.font = UIFont.systemFont(ofSize: CGFloat(0.048 * screenWidth),weight: .light)
        
    }
    
    func configure(labelText: String,
                   iconImageName: String = "",
                   textFieldPlaceholder: String,
                   textFieldImageName: String = ""){
        if iconImageName == ""{
            iconImage.isHidden = true
        }
        if textFieldImageName == ""{
            imgForTextField.isHidden = true
        }
        labelofView.text = labelText
        labelofView.textColor = UIColor.systemYellow
        labelofView.font = UIFont(name: "SFAtarianSystemExtended", size: CGFloat(0.048 * screenWidth))
        iconImage.image = UIImage(named: iconImageName)
        actualTextField.placeholder = textFieldPlaceholder
        imgForTextField.image = UIImage(named: textFieldImageName)
    }

}
