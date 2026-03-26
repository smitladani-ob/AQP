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
        setupOptionsView()
        loadServerImages()
        setupUIBasedOnMode()
    }
    
    // MARK: - Setup
    
    /// Configures text/image display mode and sets local/picker images as the baseline.
    /// - addQuestion flow: option1Image/option2Image come from the image picker → shown immediately.
    /// - firstTab flow: option1Image/option2Image are nil → loadServerImages() fills via SDWebImage.
    private func setupOptionsView() {
        selectorImage.image = questionImage
        optionsView.configureForPreview(
            optionType: optionType ?? .text,
            option1Text: option1Text,
            option2Text: option2Text,
            option1Image: option1Image,
            option2Image: option2Image
        )
    }
    
    /// Loads server images via SDWebImage (firstTab flow only).
    /// Only overrides a view when a URL is provided; locally-set images are left untouched.
    private func loadServerImages() {
        if let urlStr = questionImageURL, let url = URL(string: urlStr) {
            selectorImage.sd_setImage(with: url, placeholderImage: questionImage)
        }
        if let urlStr = option1ImageURL, let url = URL(string: urlStr) {
            optionsView.optionOneImageBg.sd_setImage(with: url, placeholderImage: option1Image)
        }
        if let urlStr = option2ImageURL, let url = URL(string: urlStr) {
            optionsView.optionTwoImageBg.sd_setImage(with: url, placeholderImage: option2Image)
        }
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
