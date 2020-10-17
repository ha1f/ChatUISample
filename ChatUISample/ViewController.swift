//
//  ViewController.swift
//  ChatUISample
//

import UIKit

final class ToolBarButton: UIButton {
    struct Config {
        var title: String?
//        var iconImage: UIImage

        static let camera = Config(title: "📷")
        static let album = Config(title: "🏞")
        static let mic = Config(title: "🎤")
        static let plus = Config(title: "+")
        static let send = Config(title: "✈")
    }

    init(_ config: Config) {
        super.init(frame: .init(x: 0, y: 0, width: ToolBarView.height, height: ToolBarView.height))
        titleLabel?.font = .boldSystemFont(ofSize: 24)
        setTitle(config.title, for: .normal)
        setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        setContentHuggingPriority(.defaultHigh, for: .horizontal)
        setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        CGSize(width: ToolBarView.height, height: ToolBarView.height)
    }
}

final class ToolBarTextFieldContainerView: UIView {
    /// ツールバーの上下とtextFieldの間のマージン
    static let verticalMargin: CGFloat = 4

    let textField = ToolBarTextField(frame: .zero)

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.topAnchor.constraint(equalTo: topAnchor, constant: ToolBarTextFieldContainerView.verticalMargin),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -ToolBarTextFieldContainerView.verticalMargin)
        ])

        setContentHuggingPriority(.defaultLow, for: .horizontal)
        setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class ToolBarTextField: UITextField {
    private let backgroundView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        borderStyle = .none
        placeholder = "Aa"
        layer.cornerRadius = (ToolBarView.height - ToolBarTextFieldContainerView.verticalMargin * 2) / 2
        layer.masksToBounds = true
        backgroundColor = UIColor(white: 1, alpha: 0.5)
        textColor = .white
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: .init(top: 8, left: 8, bottom: 8, right: 8))
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: .init(top: 8, left: 8, bottom: 8, right: 8))
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class ToolBarView: UIView {
    static let height: CGFloat = 44

    private let stackView: UIStackView
    let plusButton = ToolBarButton(.plus)
    let cameraButton = ToolBarButton(.camera)
    let albumButton = ToolBarButton(.album)
    let micButton = ToolBarButton(.mic)
    let sendButton = ToolBarButton(.send)
    let textFieldContainer = ToolBarTextFieldContainerView(frame: .zero)

    override init(frame: CGRect) {
        stackView = UIStackView(frame: frame)
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .bottom
        super.init(frame: frame)

        stackView.addArrangedSubview(plusButton)
        stackView.addArrangedSubview(cameraButton)
        stackView.addArrangedSubview(albumButton)
        stackView.addArrangedSubview(textFieldContainer)
        stackView.addArrangedSubview(micButton)
        stackView.addArrangedSubview(sendButton)
        sendButton.isHidden = true
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            stackView.heightAnchor.constraint(equalToConstant: ToolBarView.height)
        ])

        NSLayoutConstraint.activate([
            textFieldContainer.topAnchor.constraint(equalTo: stackView.topAnchor)
        ])

        backgroundColor = .red

        textFieldContainer.textField.delegate = self
        textFieldContainer.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    private func textFieldDidChange(_ textField: UITextField) {
        if textField.text?.isEmpty ?? true {
            micButton.isHidden = false
            sendButton.isHidden = true
        } else {
            micButton.isHidden = true
            sendButton.isHidden = false
        }
    }
}

extension ToolBarView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        cameraButton.alpha = 0
        albumButton.alpha = 0
        UIView.animate(withDuration: 0.2) {
            self.textFieldContainer.textField.placeholder = "メッセージを入力"
            self.cameraButton.isHidden = true
            self.albumButton.isHidden = true
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.2) {
            self.textFieldContainer.textField.placeholder = "Aa"
            self.cameraButton.isHidden = false
            self.albumButton.isHidden = false
            self.cameraButton.alpha = 1
            self.albumButton.alpha = 1
        }
    }
}

final class DismissimgViewController: UIViewController {
    let button = UIButton(type: .system)

    override func viewDidLoad() {
    super.viewDidLoad()

        view.backgroundColor = .yellow

        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        button.setTitle("Dismiss", for: .normal)
        button.addTarget(self, action: #selector(didButtonTapped), for: .touchUpInside)
    }

    @objc
    func didButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}

class ViewController: UIViewController {
    private let tapGestureRecognizer = UITapGestureRecognizer()
    private(set) lazy var toolBarView = ToolBarView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: ToolBarView.height + view.safeAreaInsets.bottom))

    let presentButton = UIButton(type: .system)

    @objc private func didTapPresentButton() {
        let vc = DismissimgViewController(nibName: nil, bundle: nil)
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(presentButton)
        presentButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            presentButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            presentButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        presentButton.setTitle("present", for: .normal)
        presentButton.addTarget(self, action: #selector(didTapPresentButton), for: .touchUpInside)

        view.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer.addTarget(self, action: #selector(didViewTapped))
    }

    override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }

    override var inputAccessoryView: UIView? {
        toolBarView
    }

    @objc
    private func didViewTapped() {
        print("tap")
        toolBarView.textFieldContainer.textField.resignFirstResponder()
    }
}
