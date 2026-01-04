//
//  File.swift.swift
//  PokerUIKit
//
//  Created by Aziz Bibitov on 04/01/2026.
//

import UIKit

class CenterSnapFlowLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        scrollDirection = .horizontal
        minimumLineSpacing = 20
        itemSize = CGSize(width: 310, height: 484)
        sectionInset = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 40)
    }

    required init?(coder: NSCoder) { fatalError() }

    // Snap items to center
    override func targetContentOffset(
        forProposedContentOffset proposedContentOffset: CGPoint,
        withScrollingVelocity velocity: CGPoint
    ) -> CGPoint {

        guard let collectionView = collectionView else { return proposedContentOffset }
        
        let collectionViewCenterX = collectionView.bounds.width / 2
        let proposedCenterX = proposedContentOffset.x + collectionViewCenterX

        guard let attributes = layoutAttributesForElements(in: collectionView.bounds) else {
            return proposedContentOffset
        }

        // Find the closest item
        var closest = attributes.min(by: {
            abs($0.center.x - proposedCenterX) < abs($1.center.x - proposedCenterX)
        }) ?? UICollectionViewLayoutAttributes()

        // Use velocity to move to next/previous item if flicked fast
        if velocity.x > 0.2 {
            // Flicked to right → next item
            if let index = attributes.firstIndex(of: closest), index < attributes.count - 1 {
                closest = attributes[index + 1]
            }
        } else if velocity.x < -0.2 {
            // Flicked to left → previous item
            if let index = attributes.firstIndex(of: closest), index > 0 {
                closest = attributes[index - 1]
            }
        }

        let targetX = closest.center.x - collectionViewCenterX
        return CGPoint(x: targetX, y: proposedContentOffset.y)
    }

}
