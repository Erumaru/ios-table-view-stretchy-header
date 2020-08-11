//
//  ImageViewController.swift
//  stretchy-header
//
//  Created by Abzal Toremuratuly on 8/11/20.
//  Copyright © 2020 Abzal Toremuratuly. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class ImageViewController: UIViewController {
    private let imageURL: URL
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.kf.setImage(with: self.imageURL)
        view.clipsToBounds = true
        
        return view
    }()

    init(imageURL: URL) {
        self.imageURL = imageURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        markup()
    }
    
    private func markup() {
        view.addSubview(imageView)
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
