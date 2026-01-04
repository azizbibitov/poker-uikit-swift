//
//  Quiz.swift
//  PokerUIKit
//
//  Created by Aziz Bibitov on 28/12/2025.
//

import UIKit
import EasyPeasy

class QuizVC: UIViewController {
    
    var mainView: QuizView {
        return view as! QuizView
    }

    override func loadView() {
        super.loadView()
        view = QuizView()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavbar()
        setupCallbacks()
    }
    
    func setupCallbacks() {
        mainView.readyTestView.controlsView.yesBtnCallback = { [weak self] in
            let vc = QuestionsVC()
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self?.tabBarController?.present(navVC, animated: true)
        }
        
        mainView.readyTestView.controlsView.noBtnCallback = { [weak self] in
            self?.tabBarController?.switchToTab(index: 0)
        }
    }
    
    private func setupNavbar() {
        let closeButton = UIButton(type: .system)
        closeButton.setImage(UIImage(named: "gear")?.withRenderingMode(.alwaysOriginal), for: .normal)
        closeButton.addTarget(self, action: #selector(gearButtonTapped), for: .touchUpInside)
        closeButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: closeButton)

        let label = UILabel()
        label.text = "Quiz"
        label.textColor = .pokerBlack
        label.font = .systemFont(ofSize: 30, weight: .regular)
        let labelBarButtonItem = UIBarButtonItem(customView: label)
        if #available(iOS 26.0, *) {
            labelBarButtonItem.hidesSharedBackground = true
        }
        navigationItem.leftBarButtonItem = labelBarButtonItem

        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    @objc private func gearButtonTapped() {
        print("gear tapped")
    }
    
}

class QuizView: UIView {
    
    let vStack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 48
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .center
        return stack
    }()
    
    var labelsHStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 5
        stack.alignment = .lastBaseline
        return stack
    }()

    var resultLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .regular(size: 20)
        lbl.textColor = .pokerBlack
        return lbl
    }()
    
    var resultValueLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .regular(size: 36)
        lbl.textColor = .pokerBlack
        return lbl
    }()
    
    let readyTestView = ReadyTestView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        backgroundColor = .white
    }
    
    func setupViews() {
        addSubview(vStack)
        vStack.easy.layout([
            Edges().to(safeAreaLayoutGuide)
        ])
        setupVStack()
    }
    
    func setupVStack() {
        let topSpacer = UIView()
        let bottomSpacer = UIView()
        
        vStack.addArrangedSubview(topSpacer)
        
        vStack.addArrangedSubview(labelsHStack)
        
        labelsHStack.addArrangedSubview(resultLabel)
        labelsHStack.addArrangedSubview(resultValueLabel)
        resultLabel.text = "Your best result:"
        resultValueLabel.text = "9"
        
        vStack.addArrangedSubview(readyTestView)
        
        vStack.addArrangedSubview(bottomSpacer)
        topSpacer.easy.layout([
            Height().like(bottomSpacer)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class ReadyTestView: UIView {
    
    let vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = -7
        return stack
    }()
    
    let imageWrapper = UIView()
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "quiz_image")
        return imageView
    }()
    
    let controlsView = ReadyTestControlsView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(vStack)
        vStack.easy.layout(Edges())
        vStack.addArrangedSubview(imageWrapper)
        imageWrapper.easy.layout([
            Width(354), Height(263), Leading(), Trailing()
        ])
        imageWrapper.addSubview(imageView)
        imageView.easy.layout([
            Width(354), Height(263), CenterX(-8)
        ])
        imageWrapper.layer.zPosition = 1
        
        vStack.addArrangedSubview(controlsView)
        controlsView.easy.layout([
            Width(310), Height(250)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class ReadyTestControlsView: UIView {
    
    var yesBtnCallback: (() -> Void)?
    var noBtnCallback: (() -> Void)?
    
    let vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0
        stack.alignment = .center
        return stack
    }()
    
    var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.text = "Ready to test you knowledge?"
        lbl.textAlignment = .center
        lbl.textColor = .white
        lbl.font = .regular(size: 20)
        return lbl
    }()
    
    let yesBtn = UIButton()
    let noBtn = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .main
        layer.cornerRadius = 20
        setupViews()
    }
    
    func setupViews() {
        addSubview(vStack)
        vStack.easy.layout(Edges())
        
        let topSpacer = UIView()
        let bottomSpacer = UIView()
        
        vStack.addArrangedSubview(topSpacer)
        
        vStack.addArrangedSubview(titleLabel)
        vStack.setCustomSpacing(28, after: titleLabel)
        
        yesBtn.makeGlassButton(title: "Yes, I am!", titleColor: .main, backgroundColor: .white, font: .regular(size: 18), cornerRadius: 14)
        yesBtn.easy.layout([
            Width(242), Height(47)
        ])
        yesBtn.addTarget(self, action: #selector(yesButtonTapped), for: .touchUpInside)
        vStack.addArrangedSubview(yesBtn)
        vStack.setCustomSpacing(25, after: yesBtn)
        
        noBtn.makeGlassButton(title: "I need more time", titleColor: .white, backgroundColor: .main, font: .regular(size: 18), cornerRadius: 14, borderWidth: 1, borderColor: .white)
        noBtn.easy.layout([
            Width(242), Height(47)
        ])
        noBtn.addTarget(self, action: #selector(noButtonTapped), for: .touchUpInside)
        vStack.addArrangedSubview(noBtn)
        
        vStack.addArrangedSubview(bottomSpacer)
        topSpacer.easy.layout([
            Height().like(bottomSpacer)
        ])
    }
    
    
    @objc private func yesButtonTapped() {
        yesBtnCallback?()
    }
    
    @objc private func noButtonTapped() {
        noBtnCallback?()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

import SwiftUI

struct PreviewView: SwiftUI.View {
    var body: some SwiftUI.View {
        QuizVC().swiftUIView()
    }
}

#Preview {
    PreviewView()
}
