//
//  QuestionsVC.swift
//  PokerUIKit
//
//  Created by Aziz Bibitov on 04/01/2026.
//

import UIKit
import EasyPeasy

class QuestionsVC: UIViewController {
    
    
    var mainView: QuestionsView {
        return view as! QuestionsView
    }

    override func loadView() {
        super.loadView()
        view = QuestionsView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavbar()
    }
    
    
    private func setupNavbar() {
        let closeButton = UIButton(type: .system)
        closeButton.setImage(UIImage(named: "close")?.withRenderingMode(.alwaysOriginal), for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        closeButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: closeButton)

        let label = UILabel()
        label.text = "Question 1/10"
        label.textColor = .pokerBlack
        label.font = .systemFont(ofSize: 30, weight: .regular)
        let labelBarButtonItem = UIBarButtonItem(customView: label)
        if #available(iOS 26.0, *) {
            labelBarButtonItem.hidesSharedBackground = true
        }
        navigationItem.leftBarButtonItem = labelBarButtonItem

        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    @objc func closeButtonTapped() {
        self.dismiss(animated: true)
    }
}

class QuestionsView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
