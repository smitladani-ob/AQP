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
        let nib = UINib(nibName: "QuestionCell", bundle: nil)
        tableView.register(nib,forCellReuseIdentifier: "QuestionCell")
        
        fetchQuestions()
    }
    
    func fetchQuestions() {
        APIManager.sharedInstance.getQuestions { result in
            switch result {
            case .success(let response):
                let nested = response.data?.result ?? []
                self.questions = nested.flatMap { $0 }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            case .failure(let error):
                print(error)
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
        let question = questions[indexPath.row]
        cell.descriptionLabel.text = question.description
        cell.actionButton.tag = indexPath.row
        cell.actionButton.loginButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 12
    }
}
