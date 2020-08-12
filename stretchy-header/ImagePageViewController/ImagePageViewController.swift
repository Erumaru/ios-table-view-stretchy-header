//
//  ImagePageViewController.swift
//  stretchy-header
//
//  Created by Abzal Toremuratuly on 8/11/20.
//  Copyright © 2020 Abzal Toremuratuly. All rights reserved.
//

import UIKit

protocol ImagePageViewControllerDataSource: class {
    func imagePageViewController(imageURLsFor imagePageViewController: ImagePageViewController) -> [URL]?
}

protocol ImagePageViewControllerDelegate: class {
    func imagePageViewController(didScrollTo index: Int)
}

class ImagePageViewController: UIViewController {
    public weak var delegate: ImagePageViewControllerDelegate?
    public weak var dataSource: ImagePageViewControllerDataSource?
    private var currentPage: Int = 0
    
    private var viewControllers: [UIViewController] = []
    
    private lazy var pageController: UIPageViewController = {
        let vc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        addChild(vc)
        view.addSubview(vc.view)
        vc.didMove(toParent: self)
        
        return vc
    }()
    
    private lazy var pageControl: PageControl = {
        let view = PageControl()
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageController.delegate = self
        pageController.dataSource = self
        markup()
        reloadData()
    }
    
    public func reloadData() {
        let imageURLs = dataSource?.imagePageViewController(imageURLsFor: self) ?? []
        
        viewControllers = imageURLs.map { ImageViewController(imageURL: $0) }
        pageControl.numberOfPages = imageURLs.count
        
        if let vc = viewControllers.first {
            pageController.setViewControllers([vc], direction: .forward, animated: false, completion: nil)
        }
    }
    
    private func markup() {
        view.addSubview(pageControl)
        
        pageController.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        pageControl.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-16)
            $0.centerX.equalToSuperview()
        }
    }
}

extension ImagePageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard
            let currentIndex = self.viewControllers.firstIndex(of: viewController),
            currentIndex - 1 >= 0
        else { return nil }
        
        return viewControllers[currentIndex - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard
            let currentIndex = self.viewControllers.firstIndex(of: viewController),
            currentIndex + 1 < self.viewControllers.count
        else { return nil }
        
        return viewControllers[currentIndex + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard
            completed,
            let vc = pageViewController.viewControllers?.first,
            let index = viewControllers.firstIndex(of: vc)
        else { return }
        
        delegate?.imagePageViewController(didScrollTo: index)
        pageControl.currentPage = index
    }
}
