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
