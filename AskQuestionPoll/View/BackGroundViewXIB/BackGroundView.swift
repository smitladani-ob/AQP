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
        commonInit()
    }
    
    private func commonInit() {
        
        let view = Bundle.main.loadNibNamed("BackGroundView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(view, at: 0)
//        containerView.backgroundColor = UIColor.systemGray.withAlphaComponent(<#T##alpha: CGFloat##CGFloat#>)
        containerView.setBorder(color: UIColor.systemYellow.cgColor, width: 1)
        containerView.setCornerRadius(cornerRadius: 6)
        containerView.clipsToBounds = true
    }
}
