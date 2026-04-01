//
//  AuthTextFieldView.swift
//  AskQuestionPoll
//
//  Created by OBMac-7 on 18/03/26.
//

import UIKit

class AuthTextFieldView: NibView {

    @IBOutlet weak var widthOfTextFieldImage: NSLayoutConstraint!
    @IBOutlet weak var heightOfIconImage: NSLayoutConstraint!
    @IBOutlet weak var textfieldContainer: UIView!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var imgForTextField: UIImageView!
    @IBOutlet weak var actualTextField: UITextField!
    @IBOutlet weak var labelofView: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        heightOfIconImage.constant = labelofView.font.pointSize
        widthOfTextFieldImage.constant = actualTextField.font!.pointSize + 8
    }

    func setupUI(){
        textfieldContainer.backgroundColor = .systemGray3
        setCornerRadius(view: textfieldContainer,cornerRadius: 4)
        setBorder(view: textfieldContainer, color: UIColor.white.cgColor, width: 2)
        textfieldContainer.clipsToBounds = true
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: actualTextField.frame.height))
        actualTextField.leftView = paddingView
        actualTextField.leftViewMode = .always
        actualTextField.font = UIFont.systemFont(ofSize: CGFloat(0.048 * screenWidth),weight: .light)
    }
    
    func configure(labelText: String,iconImageName: String = "",textFieldPlaceholder: String,textFieldImageName: String = ""){
        if iconImageName == ""{
            iconImage.isHidden = true
            heightOfIconImage.constant = 0
        }
        if textFieldImageName == ""{
            imgForTextField.isHidden = true
            widthOfTextFieldImage.constant = 0
        }
        labelofView.text = labelText
        labelofView.textColor = UIColor.systemYellow
        labelofView.font = UIFont(name: "SFAtarianSystemExtended", size: CGFloat(0.048 * screenWidth), type: .DEFAULT)
        iconImage.image = UIImage(named: iconImageName)
        actualTextField.placeholder = textFieldPlaceholder
        imgForTextField.image = UIImage(named: textFieldImageName)
    }

}
