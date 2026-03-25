//
//  PreviewScreenVC.swift
//  AskQuestionPoll
//
//  Created by OBMac-7 on 25/03/26.
//

import UIKit

class PreviewScreenVC: UIViewController {

    
    @IBOutlet weak var selectorImage: UIImageView!
    @IBOutlet weak var optionsView: OptionsView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var closeButton: yellowButtonView!
    
    
    var descriptionText: String?
    var optionType: OptionType?
    var option1Text: String?
    var option2Text: String?
    var option1Image: UIImage?
    var option2Image: UIImage?
    var questionImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionLabel.text = descriptionText
        descriptionLabel.lineBreakMode = .byTruncatingTail
        selectorImage.image = questionImage
        optionsView.configureForPreview(optionType: optionType ?? .text,option1Text: option1Text,option2Text: option2Text,option1Image:option1Image,option2Image: option2Image)
        self.setupUI()
    }

    func setupUI(){
        closeButton.config(text: "CLOSE", textColor: UIColor.black)
        closeButton.loginButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
    
    @objc func closeButtonTapped(){
        self.navigationController?.popViewController(animated: true)
    }
}
