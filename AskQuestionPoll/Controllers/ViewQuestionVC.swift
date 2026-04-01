import UIKit

class ViewQuestionVC: UIViewController, UIPageViewControllerDelegate {

    @IBOutlet weak var containerView: UIView! // Connect this to your UIView in storyboard

    var pageVC: UIPageViewController!
    var pages: [PreviewScreenVC] = []
    var apiData: [ViewQuestion] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupPageVC()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        if firstTabNeedsRefresh || self.apiData.isEmpty {
            self.loadQuestions()
        }
    }

    func setupPageVC() {
        // Create PageViewController programmatically
        self.pageVC = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil
        )
        self.pageVC.dataSource = self
        self.pageVC.delegate = self

        // Add as child
        addChild(self.pageVC)
        containerView.addSubview(self.pageVC.view)
        self.pageVC.view.frame = self.containerView.bounds
        self.pageVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.pageVC.didMove(toParent: self)
    }

    func setupPages() {
        self.pages = self.apiData.map { item in
            let vc = UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(withIdentifier: "PreviewScreenVC") as! PreviewScreenVC
            vc.mode = .firstTab
            vc.descriptionText = item.description
            vc.option1Text = item.option1
            vc.option2Text = item.option2
            if let type = item.option_type,
               let optionType = OptionType(rawValue: type) {
                vc.optionType = optionType
            }
            vc.questionImageURL = item.question_compress
            vc.option1ImageURL = item.option1_compress_image
            vc.option2ImageURL = item.option2_compress_image
            return vc
        }

        if let first = self.pages.first {
            self.pageVC.setViewControllers([first], direction: .forward, animated: true)
        }
    }

    func loadQuestions() {
        showWait()
        APIManager.sharedInstance.viewQuestions { response, error, isSuccess in
            DispatchQueue.main.async {
                hideWait()
                if isSuccess {
                    firstTabNeedsRefresh = false
                    let data = response?.data?.result ?? []
                    if data.isEmpty {
                        showNoDataAlert(on: self)
                    }
                    self.apiData = data
                    self.setupPages()
                } else {
                    print(error ?? "")
                }
            }
        }
    }
}

// MARK: - PageViewController DataSource
extension ViewQuestionVC: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController,viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = self.pages.firstIndex(of: viewController as! PreviewScreenVC),
              index > 0 else { return nil }
        return self.pages[index - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController,viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = self.pages.firstIndex(of: viewController as! PreviewScreenVC),
              index < self.pages.count - 1 else { return nil }
        return self.pages[index + 1]
    }
}
