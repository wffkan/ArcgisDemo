//
//  ELExploreImageGraphicView.swift
//  LiveEarthArcGis_Example
//
//  Created by benny wang on 2020/12/22.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import LiveEarthArcGis

class ELExploreImageGraphicView: ELGraphicView {
    
    static let itemSize: CGSize = CGSize(width: 44 + 8, height: 60)
    
    lazy var imageContainerView: UIView = setupImageContainerView()
    
    lazy var imgPicture: UIImageView = setupImageView()

    lazy var bgFrameView: UIView = setupBgFrameView()
    
    lazy var triangleView: UIView = setupTriangleView(color: UIColor.white)

    lazy var tagIcon: UIImageView = UIImageView()
        
    lazy var bottomCircleView: UIImageView = UIImageView(image: UIImage(named: "travel_bottom_circle"))
        
    private var BORDER_W: CGFloat = 3
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let shadowBgView = setupShadowBgView()
        addSubview(bgFrameView)
        addSubview(shadowBgView)
        shadowBgView.addSubview(imageContainerView)
        imageContainerView.addSubview(imgPicture)
        imageContainerView.addSubview(tagIcon)
        addSubview(triangleView)
        addSubview(bottomCircleView)

        bgFrameView.snp.makeConstraints { (make) in
            make.top.right.equalToSuperview()
            make.width.height.equalTo(44)
        }
        shadowBgView.snp.makeConstraints { (make) in
            make.left.top.equalTo(4)
            make.width.height.equalTo(44)
            make.bottom.equalTo(-12)
        }
        imageContainerView.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview()
            make.width.height.equalTo(44)
        }
        imgPicture.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        tagIcon.snp.makeConstraints { (make) in
            make.left.top.equalTo(imgPicture).offset(BORDER_W + 1)
            make.width.height.equalTo(11)
        }
        bottomCircleView.frame = CGRect(x: (ELExploreImageGraphicView.itemSize.width - 10) * 0.5, y: 55, width: 10, height: 5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func render(_ result: ELGraphicsManager.RenderResult, isActive: Bool, completion: (() -> Void)? = nil) {
        
        let color = isActive ? .white : UIColor.white
        imageContainerView.layer.borderColor = color.cgColor
        imageContainerView.backgroundColor = color
        
        if let tmpModel = result.graphicModel.data as? ELExploreModel {
            completion?()
            let imageUrl = "\(tmpModel.cover_url ?? "")?x-oss-process=image/resize,w_200/auto-orient,1/quality,q_90/format,jpg"
            DispatchQueue.global().async {
                if let URL = URL(string: imageUrl),let data = try? Data.init(contentsOf: URL) {
                    DispatchQueue.main.async {
                        self.imgPicture.image = UIImage(data: data)
                        completion?()
                    }
                }
            }
        }
    }
    
}

extension ELExploreImageGraphicView {
    
    func setupImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 2
        imageView.backgroundColor = UIColor(red: 239 / 255, green: 239 / 255, blue: 239 / 255, alpha: 1)
        return imageView
    }
    
    func setupShadowBgView() -> UIView {
        let shadowBgView = UIView()
        shadowBgView.layer.shadowColor = UIColor.black.cgColor
        shadowBgView.layer.shadowOffset = CGSize(width: 0, height: 2)
        shadowBgView.layer.shadowRadius = 4
        shadowBgView.layer.shadowOpacity = 1
        return shadowBgView
    }
    
    func setupBgFrameView() -> UIView {
        let view = UIView()
        view.clipsToBounds = true
        view.isHidden = true
        view.backgroundColor = UIColor.red
        view.layer.borderWidth = BORDER_W
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.cornerRadius = 4
        return view
    }
    
    func setupImageContainerView() -> UIView {
        let imageContainerView = UIView()
        imageContainerView.clipsToBounds = true
        imageContainerView.backgroundColor = .white
        imageContainerView.layer.borderWidth = BORDER_W
        imageContainerView.layer.borderColor = UIColor.white.cgColor
        imageContainerView.layer.cornerRadius = 4
        return imageContainerView
    }
    
    func setupTriangleView(color: UIColor)-> UIView {
        let triangleView = UIView()
        triangleView.frame = CGRect(x: (ELExploreImageGraphicView.itemSize.width - 10) * 0.5, y: 48, width: 10, height: 10)
        
        let heightWidth = 10
        let path = CGMutablePath()
        
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x:heightWidth/2, y: heightWidth/2))
        path.addLine(to: CGPoint(x:heightWidth, y:0))
        path.addLine(to: CGPoint(x:0, y:0))
        
        let shape = CAShapeLayer()
        shape.path = path
        shape.fillColor = color.cgColor
        
        triangleView.layer.insertSublayer(shape, at: 0)
        return triangleView
    }
}
