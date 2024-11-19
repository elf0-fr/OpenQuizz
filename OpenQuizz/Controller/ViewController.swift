//
//  ViewController.swift
//  OpenQuizz
//
//  Created by Elfo on 18/11/2024.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var questionView: QuestionView!
    
    var game = Game()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let name = Notification.Name(rawValue: "QuestionsLoaded")
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(questionLoaded),
            name: name,
            object: nil
        )
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dragQuestionView))
        questionView.addGestureRecognizer(panGestureRecognizer)
        
        startNewGame()
    }

    @IBAction func didTapNewGameButton() {
        startNewGame()
    }
    
    private func startNewGame() {
        activityIndicator.isHidden = false
        newGameButton.isHidden = true
        
        questionView.title = "Loading..."
        questionView.style = .standard
        
        scoreLabel.text = "0 / 10"
        
        game.refresh()
    }
    
    @objc private func questionLoaded() {
        activityIndicator.isHidden = true
        newGameButton.isHidden = false
        
        questionView.title = game.currentQuestion.title
        questionView.style = .standard
    }
    
    @objc private func dragQuestionView(_ sender: UIPanGestureRecognizer) {
        guard game.state == .ongoing else { return }
        
        switch sender.state {
        case .began, .changed:
            transformQuestionView(sender)
        case .ended, .cancelled:
            answerQuestion()
        default:
            break
        }
    }
    
    private func transformQuestionView(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: questionView)
        let translationTransform = CGAffineTransform(translationX: translation.x, y: translation.y)
        
        let screenWidth = UIScreen.main.bounds.width
        let translationPercentage = translation.x / (screenWidth / 2)
        let rotationAngle = (CGFloat.pi / 6) * translationPercentage
        let rotationTransform = CGAffineTransform(rotationAngle: rotationAngle)
        
        let transform = translationTransform.concatenating(rotationTransform)
        questionView.transform = transform
        
        questionView.style = translation.x > 0 ?
            .correct :
            .incorrect
    }
    
    private func answerQuestion() {
        let screenWidth = UIScreen.main.bounds.width
        let translationTransform = questionView.style == .correct ?
        CGAffineTransform(translationX: screenWidth, y: 0) :
        CGAffineTransform(translationX: -screenWidth, y: 0)
        
        UIView.animate(withDuration: 0.3) {
            self.questionView.transform = translationTransform
        } completion: { success in
            if success {
                self.showQuestionView()
            }
        }
        
        switch questionView.style {
        case .correct:
            game.answerCurrentQuestion(with: true)
        case .incorrect:
            game.answerCurrentQuestion(with: false)
        case .standard:
            break
        }
        
        scoreLabel.text = "\(game.score) / 10"
    }
    
    private func showQuestionView() {
        questionView.transform = .identity
        questionView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        
        UIView.animate(
            withDuration: 0.4,
            delay: 0.0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.5
        ) {
            self.questionView.transform = .identity
        }
        
        questionView.style = .standard
        
        switch game.state {
        case .ongoing:
            questionView.title = game.currentQuestion.title
        case .over:
            questionView.title = "Game Over"
        }
    }
}

