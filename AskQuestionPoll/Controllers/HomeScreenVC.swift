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
        self.firstTabVC = storyboardOfMain.instantiateViewController(withIdentifier: "ViewQuestionVC") as! ViewQuestionVC
        self.secondTabVC = storyboardOfMain.instantiateViewController(withIdentifier: "AddQuestionVC") as! AddQuestionVC
        self.thirdTabVC = storyboardOfMain.instantiateViewController(withIdentifier: "LogOutVC") as! LogOutVC
        self.fourthTabVC = storyboardOfMain.instantiateViewController(withIdentifier: "AllQuestionVC") as! AllQuestionVC
        self.setupTab(tabFirst, index: 0)
        self.setupTab(tabSecond, index: 1)
        self.setupTab(tabThird, index: 2)
        self.setupTab(tabFourth, index: 3)
        self.selectTab(index: 1)
    }
    
    func setupTab(_ tab: UIControl, index: Int) {
        tab.tag = index
        tab.addTarget(self, action: #selector(self.tabTapped(_:)), for: .touchUpInside)
    }
    
    @objc func tabTapped(_ sender: UIControl) {
        self.selectTab(index: sender.tag)
    }
    
    func selectTab(index: Int) {
        // Update tab UI
        let tabs = [self.tabFirst, self.tabSecond, self.tabThird, self.tabFourth]
        for (i, tab) in tabs.enumerated() {
            tab?.backgroundColor = (i == index) ? .white : .systemYellow// selected tab = white, all others = yellow
        }
        // Switch first (IMPORTANT)
        self.switchToVC(index: index)
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
            selectedVC = self.firstTabVC
        case 1:
            selectedVC = self.secondTabVC
        case 2:
            selectedVC = self.thirdTabVC
        case 3:
            selectedVC = self.fourthTabVC
        default:
            return
        }
        // Add new VC
        addChild(selectedVC)
        selectedVC.view.frame = self.containerView.bounds
        self.containerView.addSubview(selectedVC.view)
        selectedVC.didMove(toParent: self)
    }
}
