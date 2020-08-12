//
//  PageControl.swift
//  stretchy-header
//
//  Created by Abzal Toremuratuly on 8/12/20.
//  Copyright © 2020 Abzal Toremuratuly. All rights reserved.
//

import UIKit
import FlexiblePageControl

class PageControl: UIView {
    public var numberOfPages = 0 {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsLayout()
            foregroundPageControl.numberOfPages = numberOfPages
            backgroundPageControl.numberOfPages = numberOfPages
            foregroundPageControl.setNeedsLayout()
            backgroundPageControl.setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    public var currentPage = 0 {
        didSet {
            foregroundPageControl.setCurrentPage(at: currentPage)
            backgroundPageControl.setCurrentPage(at: currentPage)
        }
    }
    
    override var intrinsicContentSize: CGSize {
        print(backgroundPageControl.intrinsicContentSize)
        return backgroundPageControl.intrinsicContentSize
    }
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    private lazy var foregroundPageControl: FlexiblePageControl = {
        let view = FlexiblePageControl()
        view.pageIndicatorTintColor = .white
        view.currentPageIndicatorTintColor = .white
        let config = FlexiblePageControl.Config(
            displayCount: 7,
            dotSize: 6,
            dotSpace: 8,
            smallDotSizeRatio: 4/6,
            mediumDotSizeRatio: 5/6
        )
        view.setConfig(config)
        
        return view
    }()
    
    private lazy var backgroundPageControl: FlexiblePageControl = {
        let view = FlexiblePageControl()
        view.pageIndicatorTintColor = .clear
        view.currentPageIndicatorTintColor = UIColor.white.withAlphaComponent(0.5)
        let config = FlexiblePageControl.Config(
            displayCount: 7,
            dotSize: 10,
            dotSpace: 4,
            smallDotSizeRatio: 4/6,
            mediumDotSizeRatio: 5/6
        )
        view.setConfig(config)
        
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        markup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func markup() {
        backgroundColor = .clear
        
        addSubview(containerView)
        [backgroundPageControl, foregroundPageControl].forEach { containerView.addSubview($0) }
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        backgroundPageControl.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.left.equalToSuperview().offset(12)
            $0.right.equalToSuperview().offset(-12)
            $0.bottom.equalToSuperview().offset(-5)
        }
        
        foregroundPageControl.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
