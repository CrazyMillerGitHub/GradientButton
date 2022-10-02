//
//  ViewController.swift
//  GradientEffectExample
//
//  Created by Mikhail Borisov on 01.10.2022.
//

import UIKit
import GradientEffect

final class ViewController: UIViewController {

    private struct Constants {

        struct Button {
            static let title: String = "Button example"
            static let cornerRadius: Double = 15.0
            static let height: CGFloat = 46.0
            static let leadingOffset: CGFloat = 20.0
            static let trailingOffset: CGFloat = -20.0
        }
    }

    private let palette: [CGColor] = [
        UIColor(red: 142/255, green: 45/255, blue: 226/255, alpha: 1).cgColor,
        UIColor(red: 74/255, green: 0/255, blue: 224/255, alpha: 1).cgColor
    ]

    private lazy var button: UIButton = {
        let primaryAction: () -> Void = { [weak self] in
            self?.didTapButton()
        }
        let button = GradientButton(
            palette: palette,
            primaryAction: primaryAction,
            animated: true
        )
        button.setTitleColor(.white, for: .normal)
        button.setTitle(Constants.Button.title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = Constants.Button.cornerRadius
        button.layer.masksToBounds = true
        return button
    }()

    override func loadView() {
        super.loadView()

        view.addSubview(button)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.heightAnchor.constraint(equalToConstant: Constants.Button.height),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.Button.leadingOffset),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Constants.Button.trailingOffset)
        ])
    }

    private func didTapButton() {
        debugPrint(#function)
    }
}
