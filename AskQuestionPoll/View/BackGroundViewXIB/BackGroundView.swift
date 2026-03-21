//
//  BackGroundView.swift
//  AskQuestionPoll
//
//  Created by OBMac-7 on 18/03/26.
//

import UIKit

class BackGroundView: UIView {
    
    @IBOutlet var containerView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        
        let view = Bundle.main.loadNibNamed("BackGroundView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(view, at: 0)
        
        containerView.layer.borderColor = UIColor.systemYellow.cgColor
        containerView.layer.borderWidth = 1
        containerView.layer.cornerRadius = 6
        containerView.clipsToBounds = true
    }
}
