//
//  AllQuestionVC.swift
//  AskQuestionPoll
//
//  Created by OBMac-7 on 25/03/26.
//

import UIKit

class AllQuestionVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var questions: [Question] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        if fourthTabNeedsRefresh {
            fetchQuestions()
        }
    }
    
    func fetchQuestions() {
        APIManager.sharedInstance.getQuestions { response, error, isSuccess in
            if isSuccess {
                fourthTabNeedsRefresh = false
                let nested = response?.data?.result ?? []
                self.questions = nested.flatMap { $0 }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                print(error ?? "")
            }
        }
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        let question = questions[sender.tag]
        print("Tapped:", question.questionId ?? 0)
    }
}

extension AllQuestionVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath) as! QuestionCell
        cell.selectionStyle = .none
        let question = questions[indexPath.row]
        cell.descriptionLabel.text = question.description
        cell.actionButton.tag = indexPath.row
        cell.actionButton.loginButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return cell
    }
}
