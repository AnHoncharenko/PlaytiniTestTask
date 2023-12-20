//
//  ViewController.swift
//  PlaytiniTestTask
//
//  Created by Anton Honcharenko on 20.12.2023.
//

import UIKit

class ViewController: UIViewController {
    
    private var alreadyExistingBarriers: [UIView] = []
    private var obstacles: [UIView] = []
    private var collisionCount = 0
    
    private let appConfigurator = AppConfigurator.shared
    private let plusButton = UIButton()
    private let minusButton = UIButton()
    private lazy var circleView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setConstraint()
        setup()
        setActions()
        rotateCircle()
        setTimers()
    }
    
    private func setTimers() {
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            self.createObstacle()
        }
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.checkCollisions()
        }
    }

    private func rotateCircle() {
        UIView.animate(withDuration: appConfigurator.circleRotationAnimationDuration, delay: 0, options: .curveLinear, animations: {
            self.circleView.transform = self.circleView.transform.rotated(by: .pi / 2)
        }) { _ in
            self.rotateCircle()
        }
    }

    private func createObstacle() {
        let obstacleHeight: CGFloat = 20
        let obstacle = UIView(frame: CGRect(x: view.frame.width, y: CGFloat.random(in: 0...(view.frame.height - obstacleHeight * 2)), width: 100, height: obstacleHeight))
        obstacle.layer.zPosition = -1
        obstacle.backgroundColor = UIColor.systemYellow
        obstacle.clipsToBounds = true
        obstacle.layer.cornerRadius = obstacleHeight/2
        view.addSubview(obstacle)
        obstacles.append(obstacle)
        UIView.animate(withDuration: 5.0, delay: 0, options: .curveLinear, animations: {
            obstacle.frame.origin.x = -obstacle.frame.width
        }) { _ in
            obstacle.removeFromSuperview()
            self.obstacles.removeFirst()
        }
    }
    
    private func checkCollisions() {
        for obstacle in obstacles {
            if circleView.frame.intersects(obstacle.layer.presentation()?.frame ?? .zero) && !alreadyExistingBarriers.contains(obstacle) {
                alreadyExistingBarriers.append(obstacle)
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                collisionCount += 1
                if collisionCount >= appConfigurator.maxCollisionCount {
                    showWarningAlert()
                }
            }
        }
    }
    
    private func showWarningAlert() {
        let alert = UIAlertController(title: "Warning", message: "Need restart the screen.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "RESTART", style: .default, handler: { _ in
            UIView.animate(withDuration: 0.3, animations: {
                self.circleView.transform = .identity
                self.obstacles.forEach({ $0.removeFromSuperview() })
            })
            self.rotateCircle()
            self.collisionCount = 0
            self.alreadyExistingBarriers.removeAll()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    private func animateTransform(scaleFactor: CGFloat) {
        let scaledTransform = self.circleView.transform.scaledBy(x: scaleFactor, y: scaleFactor)
        UIView.animate(withDuration: 0.15) {
            self.circleView.transform = scaledTransform
        }
    }

    @objc private func plusButtonTapped() {
        animateTransform(scaleFactor: 1.1)
    }

    @objc private func minusButtonTapped() {
        animateTransform(scaleFactor: 0.9)
    }
    
    private func setup() {
        plusButton.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        plusButton.backgroundColor = .green
        plusButton.layer.cornerRadius = 15
        plusButton.layer.zPosition = 1
        minusButton.setImage(UIImage(systemName: "minus.circle.fill"), for: .normal)
        minusButton.backgroundColor = .red
        minusButton.layer.cornerRadius = 15
        minusButton.layer.zPosition = 1
        circleView.backgroundColor = UIColor.blue
    }
    
    private func setActions() {
        plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        minusButton.addTarget(self, action: #selector(minusButtonTapped), for: .touchUpInside)
    }
    
    private func setConstraint() {
        let buttonsStack = UIStackView(arrangedSubviews: [minusButton, plusButton])
        buttonsStack.spacing = 20
        let circleRadius: CGFloat = 50
        circleView.image = UIImage(systemName: "steeringwheel")
        circleView.layer.cornerRadius = circleRadius
        view.addSubview(circleView)
        view.addSubview(buttonsStack)
        circleView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            circleView.heightAnchor.constraint(equalToConstant: 100),
            circleView.widthAnchor.constraint(equalToConstant: 100),
            circleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            circleView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            buttonsStack.heightAnchor.constraint(equalToConstant: 60),
            minusButton.heightAnchor.constraint(equalToConstant: 60),
            plusButton.heightAnchor.constraint(equalToConstant: 60),
            minusButton.widthAnchor.constraint(equalToConstant: 60),
            plusButton.widthAnchor.constraint(equalToConstant: 60),
            buttonsStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100)
        ])
    }
}
