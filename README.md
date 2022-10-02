## Usage

```swift
import GradientButton

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

```

## License

**GradientButton** is available under the **MIT license**. See the `LICENSE` file for more info.
