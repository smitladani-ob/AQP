import UIKit

class ViewQuestionVC: UIViewController, UIPageViewControllerDelegate {

    @IBOutlet weak var containerView: UIView! // Connect this to your UIView in storyboard

    var pageVC: UIPageViewController!
    var pages: [PreviewScreenVC] = []
    var apiData: [ViewQuestion] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Make sure containerView is not nil
        guard containerView != nil else {
            fatalError("containerView is not connected in storyboard!")
        }
        setupPageVC()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        loadQuestions()
    }

    func setupPageVC() {
        // Create PageViewController programmatically
        pageVC = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil
        )
        pageVC.dataSource = self
        pageVC.delegate = self

        // Add as child
        addChild(pageVC)
        containerView.addSubview(pageVC.view)
        pageVC.view.frame = containerView.bounds
        pageVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        pageVC.didMove(toParent: self)
    }

    func setupPages() {
        pages = apiData.map { item in
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

        if let first = pages.first {
            pageVC.setViewControllers([first], direction: .forward, animated: true)
        }
    }

    func loadQuestions() {
        let waitAlert = alert.showWait("Loading...", subTitle: "", colorStyle: 0xFFEB3B)
        APIManager.sharedInstance.viewQuestions { result in
            DispatchQueue.main.async {
                waitAlert.close()
                switch result {
                case .success(let response):
                    if response.code == 200 {
                        self.apiData = response.data?.result ?? []
                        self.setupPages()
                    } else {
                        print(response.message ?? "Error")
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}

// MARK: - PageViewController DataSource
extension ViewQuestionVC: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController as! PreviewScreenVC),
              index > 0 else { return nil }
        return pages[index - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController as! PreviewScreenVC),
              index < pages.count - 1 else { return nil }
        return pages[index + 1]
    }
}
