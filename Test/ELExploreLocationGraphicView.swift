//
//  ELExploreLocationGraphicView.swift
//  EarthLive
//
//  Created by Zheng on 2020/7/23.
//  Copyright © 2020 benny wang. All rights reserved.
//

import UIKit

class ELExploreLocationGraphicView: UIView {
    
    lazy var imageView: UIImageView = setupImageView()
    
    lazy var avatar: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ELExploreLocationGraphicView {
    
    func setupSubviews() {
        avatar.layer.cornerRadius = 10
        avatar.layer.masksToBounds = true
        addSubview(imageView)
        imageView.addSubview(avatar)
        
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        avatar.snp.makeConstraints { (make) in
            make.width.height.equalTo(20)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(2)
        }
        
    }
    
    
    func setupImageView() -> UIImageView {
        let imageView = UIImageView(image: UIImage(named: "scene_location_self"))
        return imageView
    }
}
