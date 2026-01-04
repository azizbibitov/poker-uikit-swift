//
//  CombinationsVC.swift
//  PokerUIKit
//
//  Created by Aziz Bibitov on 28/12/2025.
//

import UIKit
import EasyPeasy

class CombinationsVC: UIViewController {

    var mainView: CombinationsView {
        return view as! CombinationsView
    }

    override func loadView() {
        super.loadView()
        view = CombinationsView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavbar()
        setupCollectionView()
    }

    private func setupNavbar() {
        let closeButton = UIButton(type: .system)
        closeButton.setImage(UIImage(named: "gear")?.withRenderingMode(.alwaysOriginal), for: .normal)
        closeButton.addTarget(self, action: #selector(gearButtonTapped), for: .touchUpInside)
        closeButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: closeButton)

        let label = UILabel()
        label.text = "Combinations"
        label.textColor = .pokerBlack
        label.font = .systemFont(ofSize: 30, weight: .regular)
        let labelBarButtonItem = UIBarButtonItem(customView: label)
        if #available(iOS 26.0, *) {
            labelBarButtonItem.hidesSharedBackground = true
        }
        navigationItem.leftBarButtonItem = labelBarButtonItem

        navigationController?.navigationBar.prefersLargeTitles = false
    }

    private func setupCollectionView() {
        mainView.collectionView.dataSource = self
        mainView.collectionView.delegate = self
    }

    @objc private func gearButtonTapped() {
        print("gear tapped")
    }
}

// MARK: - UICollectionViewDataSource + Delegate
extension CombinationsVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return combinations.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

      
        
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CombinationCardCollectionViewCell.cellId, for: indexPath) as! CombinationCardCollectionViewCell
            cell.layer.cornerRadius = 12
            cell.clipsToBounds = true
            cell.setupData(combination: combinations[indexPath.item])
            cell.hideAllButDescription()
            return cell
        }else if indexPath.item == 10 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CombinationReadyCollectionCell.cellId, for: indexPath) as! CombinationReadyCollectionCell
            cell.layer.cornerRadius = 12
            cell.clipsToBounds = true
            cell.setupData(combination: combinations[indexPath.item])
            cell.noBtnCallback = { [weak self] in
                let index = IndexPath(item: 0, section: 0)
                collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            }
            cell.yesBtnCallback = { [weak self] in
                self?.tabBarController?.switchToTab(index: 1)
            }
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CombinationCardCollectionViewCell.cellId, for: indexPath) as! CombinationCardCollectionViewCell
            cell.layer.cornerRadius = 12
            cell.clipsToBounds = true
            cell.setupData(combination: combinations[indexPath.item])
            return cell
        }
        
    }

    // Optional: enforce item size
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: mainView.itemWidth, height: mainView.itemHeight)
    }
}
