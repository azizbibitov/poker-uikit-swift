//
//  CombinationReadyCollectionCell.swift
//  PokerUIKit
//
//  Created by Aziz Bibitov on 04/01/2026.
//

import UIKit
import EasyPeasy

class CombinationReadyCollectionCell: UICollectionViewCell {
    
    static let cellId = String(describing: CombinationReadyCollectionCell.self)
    
    var yesBtnCallback: (() -> Void)?
    var noBtnCallback: (() -> Void)?
    
    let vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .center
        return stack
    }()
    
    var descriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.textColor = .white
        lbl.font = .regular(size: 20)
        return lbl
    }()
    
    let buttonsVStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 26
        return stack
    }()
    
    // MARK: Spacers
    let topSpacer = UIView()
    let height43Spacer = UIView.spacer(height: 43)
    let height85Spacer = UIView.spacer(height: 85)
    
    let yesBtn = UIButton()
    let noBtn = UIButton()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews(){
        contentView.backgroundColor = .main
        contentView.addSubview(vStack)
        vStack.easy.layout([
            Edges()
        ])
        setupVStackSubviews()
    }
    
    func setupVStackSubviews() {
        vStack.addArrangedSubview(topSpacer)
        
        vStack.addArrangedSubview(descriptionLabel)
        descriptionLabel.easy.layout([
            Leading(26), Trailing(26)
        ])
        vStack.addArrangedSubview(height85Spacer)
        
        
        yesBtn.makeGlassButton(title: "Yes, I am!", titleColor: .main, backgroundColor: .white, font: .regular(size: 18), cornerRadius: 14)
        yesBtn.easy.layout([
            Width(242), Height(47)
        ])
        yesBtn.addTarget(self, action: #selector(yesButtonTapped), for: .touchUpInside)
        
        noBtn.makeGlassButton(title: "I need more time", titleColor: .white, backgroundColor: .main, font: .regular(size: 18), cornerRadius: 14, borderWidth: 1, borderColor: .white)
        noBtn.easy.layout([
            Width(242), Height(47)
        ])
        noBtn.addTarget(self, action: #selector(noButtonTapped), for: .touchUpInside)
        
        buttonsVStack.addArrangedSubview(yesBtn)
        buttonsVStack.addArrangedSubview(noBtn)
        
        vStack.addArrangedSubview(buttonsVStack)
        vStack.addArrangedSubview(height43Spacer)
    }
    
    @objc private func yesButtonTapped() {
        yesBtnCallback?()
    }
    
    @objc private func noButtonTapped() {
        noBtnCallback?()
    }
    
    func setupData(combination: CombinationModel) {
        descriptionLabel.text = combination.description
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
