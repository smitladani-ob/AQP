//
//  SCLAlertHelper.swift
//  AskQuestionPoll
//
//  Created by OBMac-7 on 20/03/26.
//

import Foundation
import SCLAlertView

func showError(_ message: String,subtitileMsg: String? = nil) {
    SCLAlertView().showError(message, subTitle: "")
    
}

func showSuccess(_ message: String,subtitileMsg: String? = nil) {
    SCLAlertView().showSuccess(message, subTitle: "")
}

let appearance = SCLAlertView.SCLAppearance(
    showCloseButton: false,
    shouldAutoDismiss: false
)

let alert = SCLAlertView(appearance: appearance)

func showNoDataAlert(on viewController: UIViewController,
                     title: String = "No Questions",
                     message: String = "Please add question first") {
    
    guard let homeVC = viewController.parent as? HomeScreenVC else { return }

    let alert = SCLAlertView(appearance: appearance)
    
    alert.addButton("OK") {
        // Go back to AddQuestion tab (index 1)
        homeVC.selectTab(index: 1)
        alert.hideView()
    }
    
    alert.showInfo(title, subTitle: message, closeButtonTitle: nil, colorStyle: 0x007BFF)
}

