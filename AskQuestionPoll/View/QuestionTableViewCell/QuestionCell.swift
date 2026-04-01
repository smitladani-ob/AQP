//
//  QuestionCell.swift
//  AskQuestionPoll
//
//  Created by OBMac-7 on 25/03/26.
//

import UIKit

class QuestionCell: UITableViewCell {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var actionButton: yellowButtonView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setupCellUI()
    }
    
    func setupCellUI() {
        actionButton.config(text: "VIEW ANALYSIS", textColor: .black, size: 0.048)
    }
}
