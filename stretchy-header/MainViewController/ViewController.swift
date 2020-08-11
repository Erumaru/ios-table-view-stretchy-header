//
//  ViewController.swift
//  stretchy-header
//
//  Created by Abzal Toremuratuly on 8/11/20.
//  Copyright © 2020 Abzal Toremuratuly. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    open var headerInitialHeight: CGFloat = 300
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.tableFooterView = UIView()
        view.rowHeight = UITableView.automaticDimension
        view.showsVerticalScrollIndicator = false
        view.estimatedRowHeight = 300
        if #available(iOS 11.0, *) {
            view.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        view.delegate = self
        view.dataSource = self
        view.contentInset = .init(top: self.headerInitialHeight, left: 0, bottom: 0, right: 0)
        
        return view
    }()
    
    lazy var pageController: ImagePageViewController = {
        let vc = ImagePageViewController()
        vc.delegate = self
        vc.dataSource = self
        
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        markup()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func markup() {
        view.backgroundColor = .clear
        view.addSubview(tableView)
        addChild(pageController)
        tableView.addSubview(pageController.view)
        pageController.didMove(toParent: self)
        
        pageController.view.snp.makeConstraints {
            $0.top.equalTo(view.snp.topMargin)
            $0.left.equalTo(view.snp.left)
            $0.right.equalTo(view.snp.right)
            $0.height.equalTo(self.headerInitialHeight)
        }
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return .init()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.isEqual(tableView) else { return }
        let offset = -scrollView.contentOffset.y
        let newHeight = max(offset, headerInitialHeight)
        
        self.pageController.view.snp.updateConstraints {
            $0.height.equalTo(newHeight)
        }
    }
}

extension ViewController: ImagePageViewControllerDelegate {
    func imagePageViewController(didScrollTo index: Int) {
        
    }
}

extension ViewController: ImagePageViewControllerDataSource {
    func imagePageViewController(imageURLsFor imagePageViewController: ImagePageViewController) -> [URL]? {
        // Sample images
        let imageURLs: [URL] = [
            URL(string: "https://static.toiimg.com/thumb/72975551.cms?width=680&height=512&imgsize=881753")!,
            URL(string: "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__340.jpg")!,
            URL(string: "https://cdn.pixabay.com/photo/2015/02/24/15/41/dog-647528__340.jpg")!
        ]
        return imageURLs
    }
}


