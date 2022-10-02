//
//  GradientButton.swift
//  GradientEffect
//
//  Created by Mikhail Borisov on 02.10.2022.
//

import UIKit

/// Protocol ofr Gradient button
public protocol GradientButtonProtocol where Self: UIControl {

    /// Duration of animation
    var duration: CFTimeInterval { get }
}

/// Instance of Gradient Button
final public class GradientButton: UIButton, GradientButtonProtocol {

    /// Duration of animation
    /// - Note: default value - 2
    public var duration: CFTimeInterval = 2 {
        didSet {
            gradient.duration = duration
        }
    }

    /// Action when button tapped
    public var primaryAction: (() -> Void)?

    public override var isHighlighted: Bool {
        didSet {
            highlightLayer.isHidden = !isHighlighted
        }
    }

    private var currentGradient: Int = 0
    private let palette: [CGColor]

    private lazy var gradient: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = gradientStates[currentGradient]
        layer.startPoint = CGPoint(x:0, y: 0)
        layer.endPoint = CGPoint(x:1, y: 0)
        layer.drawsAsynchronously = true

        return layer
    }()

    private lazy var gradientStates: [[CGColor]] = {
        var result: [[CGColor]] = []
        for (idx, color) in palette.enumerated() {
            var gradient: [CGColor] = []
            for offset in 0..<palette.count {
                gradient.append(palette[(offset + idx) % palette.count])
            }
            result.append(gradient)
        }
        return result
    }()

    private lazy var highlightLayer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.black.withAlphaComponent(0.2).cgColor
        layer.isHidden = true
        return layer
    }()

    /// Inizialization
    /// - Parameters:
    ///   - palette: list of colors
    ///   - primaryAction: action when button tapped
    ///   - animated: should animate gradient layer
    /// - Note: If you pass empty palette, gradient will be clear by default
    public init(palette: [CGColor], primaryAction: (() -> Void)? = nil, animated: Bool = false) {
        self.primaryAction = primaryAction
        self.palette = palette.isEmpty ? [UIColor.clear.cgColor] : palette
        super.init(frame: .zero)

        addTarget(self, action: #selector(didSelect), for: .touchUpInside)

        layer.insertSublayer(gradient, at: 0)
        layer.insertSublayer(highlightLayer, above: gradient)

        if animated {
            animateGradient()
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        [gradient, highlightLayer].forEach { layer in
            layer.frame = .init(x: 0, y: 0, width: frame.width, height: frame.height)
        }
    }

    private func animateGradient() {
        CATransaction.begin()

        CATransaction.setCompletionBlock { [weak self] in
            guard let self else {
                return
            }
            self.gradient.colors = self.gradientStates[self.currentGradient]
            self.animateGradient()
        }
        currentGradient = (currentGradient + 1) % palette.count
        let gradientChangeAnimation = CABasicAnimation(keyPath: "colors")
        gradientChangeAnimation.duration = duration
        gradientChangeAnimation.toValue = gradientStates[currentGradient]
        gradientChangeAnimation.fillMode = .forwards
        gradientChangeAnimation.isRemovedOnCompletion = false
        gradient.add(gradientChangeAnimation, forKey: "colorChange")

        CATransaction.commit()
    }

    @objc
    private func didSelect() {
        primaryAction?()
    }
}
