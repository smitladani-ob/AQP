//
//  RadioButtonsView.swift
//  AskQuestionPoll
//
//  Created by OBMac-7 on 19/03/26.
//

import UIKit

enum Selection {
    case one
    case two
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
    var selectedGender: Gender {
        switch selectedOption {
        case .one:
            return .male
        case .two:
            return .female
        }
    }
    
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
    func config(categoryName: String, itemOne: String, itemTwo: String) {
        self.textColorAndFont(label: categoryLabel, text: categoryName)
        self.textColorAndFont(label: lblOptionOne, text: itemOne)
        self.textColorAndFont(label: lblOptionTwo, text: itemTwo)
    }
    func textColorAndFont(label: UILabel,text: String) {
        label.text = text
        let font = UIFont(name: "SFAtarianSystemExtended", size: CGFloat(0.048 * screenWidth))
        label.textColor = UIColor.systemYellow
        label.font = font
    }
    //For Button Actions
    @objc private func selectOne() {
        selectedOption = .one
        updateUI()
    }

    @objc private func selectTwo() {
        selectedOption = .two
        updateUI()
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
        imgOptionOne.tintColor = .white
        imgOptionTwo.tintColor = .white
    }
}
