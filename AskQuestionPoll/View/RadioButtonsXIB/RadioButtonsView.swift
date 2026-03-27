//
//  RadioButtonsView.swift
//  AskQuestionPoll
//
//  Created by OBMac-7 on 19/03/26.
//

import UIKit

enum RadioMode {
    case gender
    case options
}

enum OptionType: Int{
    case text = 1
    case image = 2
}

enum Selection {
    case one // First option selected
    case two // Second option selected
}

class RadioButtonsView: NibView {
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var viewOptionOne: UIView!
    @IBOutlet weak var viewOptionTwo: UIView!
    @IBOutlet weak var imgOptionOne: UIImageView!
    @IBOutlet weak var imgOptionTwo: UIImageView!
    @IBOutlet weak var lblOptionOne: UILabel!
    @IBOutlet weak var lblOptionTwo: UILabel!
    
    var selectedOption: Selection = .one
    var mode: RadioMode = .gender
    var selectedGender: Gender {
        switch selectedOption {
        case .one:
            return .male
        case .two:
            return .female
        }
    }
    var selectedOptionType: OptionType {
        switch selectedOption {
        case .one:
            return .text
        case .two:
            return .image
        }
    }
    var onSelectionChanged: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTap()
        updateUI()
    }

    private func setupTap() {
        viewOptionOne.isUserInteractionEnabled = true
        viewOptionTwo.isUserInteractionEnabled = true
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(selectOne))
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(selectTwo))
        viewOptionOne.addGestureRecognizer(tap1)
        viewOptionTwo.addGestureRecognizer(tap2)
    }
    // For Configure data
    func config(categoryName: String,itemOne: String,itemTwo: String,textcolor: UIColor,mode: RadioMode) {
        self.mode = mode
        self.textColorAndFont(label: categoryLabel, text: categoryName, textColor: textcolor)
        self.textColorAndFont(label: lblOptionOne, text: itemOne, textColor: textcolor)
        self.textColorAndFont(label: lblOptionTwo, text: itemTwo, textColor: textcolor)
        updateUI()
    }
    
    func textColorAndFont(label: UILabel,text: String,textColor: UIColor) {
        label.text = text
        let font = UIFont(name: "SFAtarianSystemExtended", size: CGFloat(0.048 * screenWidth))
        if label == categoryLabel {
            label.textColor = UIColor.systemYellow
        } else {
            label.textColor = textColor
        }
        label.font = font
    }
    
    //For Button Actions
    @objc private func selectOne() {
        selectedOption = .one
        updateUI()
        onSelectionChanged?()
    }

    @objc private func selectTwo() {
        selectedOption = .two
        updateUI()
        onSelectionChanged?()
    }
    
    // For Update UI (MAIN LOGIC)
    private func updateUI() {
        switch selectedOption {
        case .one:
            imgOptionOne.image = UIImage(systemName: "largecircle.fill.circle")
            imgOptionTwo.image = UIImage(systemName: "circle")
        case .two:
            imgOptionOne.image = UIImage(systemName: "circle")
            imgOptionTwo.image = UIImage(systemName: "largecircle.fill.circle")
        }
        //UI based on mode
        switch mode {
        case .gender:
            imgOptionOne.tintColor = .white
            imgOptionTwo.tintColor = .white
            
        case .options:
            imgOptionOne.tintColor = .white
            imgOptionTwo.tintColor = .white
        }
    }
}
