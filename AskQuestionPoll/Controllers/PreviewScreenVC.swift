//
// PreviewScreenVC.swift
// AskQuestionPoll
//

import UIKit
import SDWebImage

enum PreviewMode {
    case addQuestion
    case firstTab
}

class PreviewScreenVC: UIViewController {

    var mode: PreviewMode = .addQuestion
    
    @IBOutlet weak var selectorImage: UIImageView!
    @IBOutlet weak var optionsView: OptionsView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var closeButton: yellowButtonView!
    
    @IBOutlet weak var reportImage: UIImageView!
    @IBOutlet weak var coinImage: UIImageView!
    @IBOutlet weak var backGroundImage: UIImageView!
    @IBOutlet weak var labelCoinCount: UILabel!
    
    var descriptionText: String?
    var optionType: OptionType?
    var option1Text: String?
    var option2Text: String?
    var option1Image: UIImage?
    var option2Image: UIImage?
    var questionImage: UIImage?
    
    var questionImageURL: String?
    var option1ImageURL: String?
    var option2ImageURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionLabel.lineBreakMode = .byTruncatingTail
        descriptionLabel.text = descriptionText
        
        loadImages()
        setupOptionsView()
        setupUIBasedOnMode()
    }
    
    private func loadImages() {
        // Question image
        if let urlStr = questionImageURL, let url = URL(string: urlStr) {
            selectorImage.sd_setImage(with: url, placeholderImage: questionImage)
        } else {
            selectorImage.image = questionImage
        }
        
        // Option images
        if let urlStr = option1ImageURL, let url = URL(string: urlStr) {
            optionsView.optionOneImageBg.sd_setImage(with: url, placeholderImage: option1Image)
        } else {
            optionsView.optionOneImageBg.image = option1Image
        }
        
        if let urlStr = option2ImageURL, let url = URL(string: urlStr) {
            optionsView.optionTwoImageBg.sd_setImage(with: url, placeholderImage: option2Image)
        } else {
            optionsView.optionTwoImageBg.image = option2Image
        }
    }
    
    private func setupOptionsView() {
        optionsView.configureForPreview(
            optionType: optionType ?? .text,
            option1Text: option1Text,
            option2Text: option2Text,
            option1Image: nil,  // SDWebImage loads separately
            option2Image: nil
        )
    }
    
    private func setupUIBasedOnMode() {
        switch mode {
        case .addQuestion:
            closeButton.isHidden = false
            closeButton.config(text: "CLOSE", textColor: UIColor.black)
            closeButton.loginButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        case .firstTab:
            reportImage.isHidden = true
            coinImage.isHidden = true
            labelCoinCount.isHidden = true
            backGroundImage.isHidden = true
            self.view.backgroundColor = .clear
            closeButton.isHidden = true
        }
    }
    
    @objc private func closeButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}
