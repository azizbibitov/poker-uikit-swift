//
//  OnboardingView.swift
//  PokerUIKit
//
//  Created by Aziz Bibitov on 29/12/2025.
//

import UIKit
import EasyPeasy
import AdvancedPageControl

class OnboardingView: UIView, UIScrollViewDelegate {
    
    var finishOnboarding: (() -> Void)?
    var currentPage = 0
    
    let vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .center
        return stack
    }()
    
    let cloudView = CloudView()

    let scrollview: UIScrollView = {
        let scr = UIScrollView()
        scr.isPagingEnabled = true
        scr.showsHorizontalScrollIndicator = false
        return scr
    }()
    
    let imagesHStack: UIStackView = {
       let stack = UIStackView()
        stack.axis = .horizontal
        return stack
    }()
    
    let pageControl = AdvancedPageControlView()
    
    let nextBtn = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        addSubview(vStack)
        vStack.easy.layout([
            Edges()
        ])
        
        
        setupPageControl(with: onboardings)
        setupVStackSubviews()
    }
    
    
    func setupVStackSubviews() {
        let topSpacer = UIView()
        let bottomSpacer = UIView()
        
        vStack.addArrangedSubview(cloudView)
        cloudView.easy.layout(Height(143), Top().to(safeAreaLayoutGuide, .top))
        
        vStack.addArrangedSubview(topSpacer)
        
        vStack.addArrangedSubview(scrollview)
        scrollview.easy.layout([
            Height(330), Width(UIScreen.main.bounds.width)
        ])
        vStack.setCustomSpacing(50, after: scrollview)
        scrollview.delegate = self
        
        scrollview.addSubview(imagesHStack)
        imagesHStack.easy.layout([
            Top(),
            Bottom(),
            Leading(),
            Trailing(),
            Height(330)
        ])
        imagesHStack.widthAnchor.constraint(
            equalTo: scrollview.widthAnchor,
            multiplier: CGFloat(onboardings.count)
        ).isActive = true
        imagesHStack.spacing = 0
        scrollview.contentInset = .zero

        
        
        onboardings.forEach { onboarding in
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage(named: onboarding.image)

            imagesHStack.addArrangedSubview(imageView)

            imageView.easy.layout([
                Width(UIScreen.main.bounds.width),
                Height(330)
            ])
        }
        
        vStack.addArrangedSubview(pageControl)
       
        
        
        vStack.addArrangedSubview(bottomSpacer)
        topSpacer.easy.layout([
            Height().like(bottomSpacer)
        ])
        
        nextBtn.makeGlassButton(title: "Next", titleColor: .white, backgroundColor: .main, font: .regular(size: 18), cornerRadius: 14)
        vStack.addArrangedSubview(nextBtn)
        nextBtn.easy.layout([Height(50), Width(135), Bottom().to(safeAreaLayoutGuide, .bottom)])
        nextBtn.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    @objc private func nextButtonTapped() {
        let totalPages = onboardings.count
        let page = scrollview.currentPage  // use UIScrollView extension

        if page < totalPages - 1 {
            // Scroll to next page
            let nextOffset = CGPoint(x: CGFloat(page + 1) * scrollview.frame.width, y: 0)
            scrollview.setContentOffset(nextOffset, animated: true)
        } else {
            // Last page tapped ("Go!")
//            finishOnboarding()
            finishOnboarding?()
        }
    }


    
    func setupPageControl(with data: [OnboardingData]){
        pageControl.drawer = ExtendedDotDrawer(numberOfPages: 4,
                                               height: 6.0,
                                               width: 6.0,
                                               space: CGFloat(10),
                                               indicatorColor: UIColor.main.withAlphaComponent(0.7),
                                               dotsColor: UIColor.systemOrange,
                                               isBordered: false,
                                               borderWidth: 0.0,
                                               indicatorBorderColor: .clear,
                                               indicatorBorderWidth: 0.0)
        
        let ad = CGFloat(10*Float(4-1) + Float(14*(4+3)))
        pageControl.easy.layout([Width(ad)])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSet = scrollView.contentOffset.x
        let width = scrollView.frame.width

        pageControl.setPageOffset(offSet / width)
        
        if self.currentPage != self.scrollview.currentPage {
            self.currentPage = self.scrollview.currentPage
            self.cloudView.titleLabel.text = onboardings[currentPage].text
            
            if currentPage == 3 {
                nextBtn.makeGlassButton(title: "Go!", titleColor: .white, backgroundColor: .main, font: .regular(size: 18), cornerRadius: 14)
            }else{
                nextBtn.makeGlassButton(title: "Next", titleColor: .white, backgroundColor: .main, font: .regular(size: 18), cornerRadius: 14)
            }
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class CloudView: UIView {
    
    var cloudBgImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "cloud_image")?.withTintColor(.lightGr, renderingMode: .alwaysOriginal)
        return image
    }()
    
    var titleLabel: UILabel = {
       let lbl = UILabel()
        lbl.text = "Study Combinations"
        lbl.textColor = UIColor(hex: "#532448")
        lbl.font = .bold(size: 24)
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(cloudBgImage)
        cloudBgImage.easy.layout([
            Height(143), Leading(-23), Trailing(-23)
        ])
        cloudBgImage.addSubview(titleLabel)
        titleLabel.easy.layout([
            Center()
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
