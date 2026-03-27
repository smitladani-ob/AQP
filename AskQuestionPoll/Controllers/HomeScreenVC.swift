//
//  HomeScreenVC.swift
//  AskQuestionPoll
//
//  Created by OBMac-7 on 21/03/26.
//

import UIKit

class HomeScreenVC: UIViewController, UITabBarDelegate {

    @IBOutlet weak var tabFourth: UIControl!
    @IBOutlet weak var tabThird: UIControl!
    @IBOutlet weak var tabSecond: UIControl!
    @IBOutlet weak var tabFirst: UIControl!
    @IBOutlet weak var containerView: UIView!
    
    var firstTabVC: UIViewController!
    var secondTabVC: UIViewController!
    var thirdTabVC: UIViewController!
    var fourthTabVC: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Instantiate Once
        firstTabVC = storyboardOfMain.instantiateViewController(withIdentifier: "ViewQuestionVC") as! ViewQuestionVC
        secondTabVC = storyboardOfMain.instantiateViewController(withIdentifier: "AddQuestionVC") as! AddQuestionVC
        thirdTabVC = storyboardOfMain.instantiateViewController(withIdentifier: "LogOutVC") as! LogOutVC
        fourthTabVC = storyboardOfMain.instantiateViewController(withIdentifier: "AllQuestionVC") as! AllQuestionVC
        setupTab(tabFirst, index: 0)
        setupTab(tabSecond, index: 1)
        setupTab(tabThird, index: 2)
        setupTab(tabFourth, index: 3)
        selectTab(index: 1)
    }
    
    func setupTab(_ tab: UIControl, index: Int) {
        tab.tag = index
        tab.addTarget(self, action: #selector(tabTapped(_:)), for: .touchUpInside)
    }
    
    @objc func tabTapped(_ sender: UIControl) {
        selectTab(index: sender.tag)
    }
    
    func selectTab(index: Int) {
        // Update tab UI
        let tabs = [tabFirst, tabSecond, tabThird, tabFourth]
        for (i, tab) in tabs.enumerated() {
            tab?.backgroundColor = (i == index) ? .white : .systemYellow// selected tab = white, all others = yellow
        }
        // Switch first (IMPORTANT)
        switchToVC(index: index)
    }
    
    func switchToVC(index: Int) {
        // Remove whichever VC is currently showing
        self.children.forEach {
            $0.view.removeFromSuperview()
            $0.removeFromParent()
        }
//        Pick which VC to show
        let selectedVC: UIViewController
        switch index {
        case 0:
            selectedVC = firstTabVC
        case 1:
            selectedVC = secondTabVC
        case 2:
            selectedVC = thirdTabVC
        case 3:
            selectedVC = fourthTabVC
        default:
            return
        }
        // Add new VC
        addChild(selectedVC)
        selectedVC.view.frame = containerView.bounds
        containerView.addSubview(selectedVC.view)
        selectedVC.didMove(toParent: self)
    }
}
