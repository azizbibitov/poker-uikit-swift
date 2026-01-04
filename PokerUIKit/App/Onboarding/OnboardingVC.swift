//
//  OnboardingVC.swift
//  PokerUIKit
//
//  Created by Aziz Bibitov on 29/12/2025.
//

import UIKit

class OnboardingVC: UIViewController {
    
    var mainView: OnboardingView {
        return view as! OnboardingView
    }
    
    override func loadView() {
        super.loadView()
        view = OnboardingView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavbar()
        
        mainView.finishOnboarding = { [weak self] in
            self?.finishOnboarding()
        }
    }
    
    func setupNavbar() {
        let closeButton = UIButton(type: .system)
        closeButton.setImage(UIImage(named: "close")?.withRenderingMode(.alwaysOriginal), for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        closeButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)

        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: closeButton)
    }
    
    @objc private func closeButtonTapped() {
        finishOnboarding()
    }
    
    private func finishOnboarding() {
        Defaults.userOnboarded = true
        guard let window = UIApplication.shared.windows.first else { return }
        
        let nextVC = TabbarController()
        nextVC.view.frame = window.bounds.offsetBy(dx: window.bounds.width, dy: 0) // Start off-screen right
        
        window.addSubview(nextVC.view)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            // Slide the new VC in
            nextVC.view.frame = window.bounds
            // Slide the current onboarding view out
            self.view.frame = self.view.frame.offsetBy(dx: -self.view.frame.width, dy: 0)
        } completion: { _ in
            // Optional: remove onboarding view from hierarchy
            self.view.removeFromSuperview()
            window.rootViewController = nextVC // set root VC to new VC
        }
    }
    
}


