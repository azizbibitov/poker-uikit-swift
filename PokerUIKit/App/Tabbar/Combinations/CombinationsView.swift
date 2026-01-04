//
//  CombinationsView.swift
//  PokerUIKit
//
//  Created by Aziz Bibitov on 04/01/2026.
//

import UIKit
import EasyPeasy

class CombinationsView: UIView {

    // MARK: - Properties
    let itemWidth: CGFloat = 310
    let itemHeight: CGFloat = 484
    let itemSpacing: CGFloat = 20
    let sideInset: CGFloat = 40

    // UICollectionView with custom snapping layout
    let collectionView: UICollectionView = {
        let layout = CenterSnapFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.decelerationRate = .fast
        cv.backgroundColor = .clear
        return cv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionView)
        collectionView.easy.layout([
            Edges().to(safeAreaLayoutGuide)
        ])
        collectionView.register(CombinationCardCollectionViewCell.self, forCellWithReuseIdentifier: CombinationCardCollectionViewCell.cellId)
        collectionView.register(CombinationReadyCollectionCell.self, forCellWithReuseIdentifier: CombinationReadyCollectionCell.cellId)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
