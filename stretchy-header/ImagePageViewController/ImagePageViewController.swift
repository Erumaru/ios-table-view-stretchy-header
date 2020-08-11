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
    
    private var viewControllers: [UIViewController] = []
    
    private lazy var pageController: UIPageViewController = {
        let vc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        addChild(vc)
        view.addSubview(vc.view)
        vc.didMove(toParent: self)
        
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageController.delegate = self
        pageController.dataSource = self
        reloadData()
    }
    
    public func reloadData() {
        let imageURLs = dataSource?.imagePageViewController(imageURLsFor: self) ?? []
        
        viewControllers = imageURLs.map { ImageViewController(imageURL: $0) }
        
        if let vc = viewControllers.first {
            pageController.setViewControllers([vc], direction: .forward, animated: false, completion: nil)
        }
    }
}

extension ImagePageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard
            let currentIndex = self.viewControllers.firstIndex(of: viewController)
        else { return nil }
        
        let index = currentIndex - 1 >= 0 ? currentIndex - 1 : viewControllers.count - 1
        
        delegate?.imagePageViewController(didScrollTo: index)
        return viewControllers[index]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard
            let currentIndex = self.viewControllers.firstIndex(of: viewController)
        else { return nil }
        
        let index = currentIndex + 1 < viewControllers.count ? currentIndex + 1 : 0
        
        delegate?.imagePageViewController(didScrollTo: index)
        return viewControllers[index]
    }
}
