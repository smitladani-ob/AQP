//
//  SelectCatagoryView.swift
//  AskQuestionPoll
//
//  Created by OBMac-7 on 21/03/26.
//

import UIKit

class SelectCatagoryView: NibView {
    
    @IBOutlet weak var underLineView: UIView!
    @IBOutlet weak var imageOfTextFIeld: UIImageView!
    @IBOutlet weak var textFIeld: UITextField!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    var onTap: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        heightConstraint.constant = textFIeld.font!.pointSize
    }
    
    func setupUI() {
        underLineView.setCornerRadius(cornerRadius: 2.5)
        self.imageOfTextFIeld.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        imageOfTextFIeld.addGestureRecognizer(tap)
    }
    
    @objc func handleTap() {
        onTap?()
    }
    
    func configure(placeHolder: String,imageName: String = ""){
        let fontSize = CGFloat(0.048 * screenWidth)
        guard let font = UIFont(name: "SFAtarianSystemExtended", size: fontSize) else {
            print("Font not found")
            return
        }
        textFIeld.font = font
        let paragraphStyle = NSMutableParagraphStyle()
        textFIeld.attributedPlaceholder = NSAttributedString(
            string: placeHolder,
            attributes: [
                .foregroundColor: UIColor.white,
                .font: font,
                .paragraphStyle: paragraphStyle
            ]
        )
        imageOfTextFIeld.image = UIImage(named: imageName)
        
    }
}
