//
//  BackGroundView.swift
//  AskQuestionPoll
//
//  Created by OBMac-7 on 18/03/26.
//

import UIKit

class BackGroundView: NibView {
    
    @IBOutlet var containerView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setBorder(view: self.containerView, color: UIColor.systemYellow.cgColor, width: 1.5)
        setCornerRadius(view: self.containerView,cornerRadius: 6)
        self.containerView.clipsToBounds = true
//        commonInit()
    }
    
    private func commonInit() {
        
        let view = Bundle.main.loadNibNamed("BackGroundView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(view, at: 0)
        setBorder(view: containerView, color: UIColor.systemYellow.cgColor, width: 1.5)
        setCornerRadius(view: containerView,cornerRadius: 6)
        containerView.clipsToBounds = true
    }
}
