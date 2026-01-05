//
//  CombinationCardCollectionViewCell.swift
//  PokerUIKit
//
//  Created by Aziz Bibitov on 04/01/2026.
//

import UIKit
import EasyPeasy

class CombinationCardCollectionViewCell: UICollectionViewCell {
    
    static let cellId = String(describing: CombinationCardCollectionViewCell.self)
    
    let vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .center
        return stack
    }()
    
    var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.pokerBlack
        lbl.font = .regular(size: 34)
        lbl.textAlignment = .center
        return lbl
    }()
    
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var descriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.pokerBlack.withAlphaComponent(0.4)
        lbl.font = .regular(size: 16)
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        return lbl
    }()
    
    // MARK: Spacers
    let topSpacer = UIView()
    let bottomSpacer = UIView()
    let height40Spacer = UIView.spacer(height: 40)
    let height50Spacer = UIView.spacer(height: 50)
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    func setupView(){
        contentView.backgroundColor = .color12
        contentView.addSubview(vStack)
        vStack.easy.layout([
            Edges()
        ])
        setupVStackSubviews()
    }
    
    func setupVStackSubviews() {
        vStack.addArrangedSubview(topSpacer)
        
        vStack.addArrangedSubview(titleLabel)
        
        vStack.addArrangedSubview(height50Spacer)
        
        vStack.addArrangedSubview(imageView)
        imageView.easy.layout([
            Height(136), Width(258)
        ])
        
        vStack.addArrangedSubview(height40Spacer)
     
        vStack.addArrangedSubview(descriptionLabel)
        descriptionLabel.easy.layout([
            Leading(26), Trailing(26)
        ])
        
        vStack.addArrangedSubview(bottomSpacer)
        topSpacer.easy.layout([
            Height().like(bottomSpacer)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetVisibility()
    }

    func resetVisibility() {
        topSpacer.isHidden = false
        titleLabel.isHidden = false
        height50Spacer.isHidden = false
        imageView.isHidden = false
        height40Spacer.isHidden = false
        bottomSpacer.isHidden = false

        descriptionLabel.textColor = UIColor.pokerBlack.withAlphaComponent(0.4)
        descriptionLabel.font = .regular(size: 16)
        contentView.backgroundColor = .color12
    }

    
    func hideAllButDescription() {
        topSpacer.isHidden = true
        titleLabel.isHidden = true
        height50Spacer.isHidden = true
        imageView.isHidden = true
        height40Spacer.isHidden = true
        bottomSpacer.isHidden = true
        
        descriptionLabel.textColor = .white
        descriptionLabel.font = .regular(size: 20)
        contentView.backgroundColor = .main
    }
    
    func setupData(combination: CombinationModel) {
        titleLabel.text = combination.title
        descriptionLabel.text = combination.description
        if let image = combination.image, !image.isEmpty {
            imageView.image = UIImage(named: image)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(codera:) has not been implemented")
    }
    
}
