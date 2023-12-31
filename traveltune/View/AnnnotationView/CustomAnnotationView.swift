//
//  CustomAnnotaionView.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/08.
//

import Foundation
import MapKit
import Kingfisher

class CustomAnnotationView: MKAnnotationView {
    
    static let identifier = "CustomAnnotationView"
    
    private let defaultSize = 40
    private let selectedSize = 100
    
    private var imageURL: String?
    
    private var thumbnail: UIImage?
    
    private lazy var annotationImageView = UIImageView(frame: .init(x: 0, y: 0, width: defaultSize, height: defaultSize)).setup { view in
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
    }
    
    private let accessoryView = UIButton(frame: CGRect(
        origin: CGPoint.zero,
        size: CGSize(width: 20, height: 20))
    )
    
    override var annotation: MKAnnotation? {
        willSet {
            clusteringIdentifier = CustomAnnotationView.identifier
        }
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        displayPriority = .defaultLow
        clusteringIdentifier = CustomAnnotationView.identifier
        setUI()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        annotationImageView.image = nil
        annotationImageView.image = thumbnail == nil ? .defaultImg : thumbnail
//        if let thumbnail {
//            print("이미지 있음")
//        }
    }
    
    private func setUI() {
        isExclusiveTouch = true
        
        frame = CGRect(x: 0, y: 0, width: defaultSize, height: defaultSize)
        centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)
        addSubview(annotationImageView)
        backgroundColor = .clear
        
        accessoryView.setImage(.locationArrow, for: .normal)
        rightCalloutAccessoryView = accessoryView
        rightCalloutAccessoryView?.tintColor = .txtSecondary
    }
    
    private func downloadImage(with urlString : String , imageCompletionHandler: @escaping (UIImage?) -> Void) {
            guard let url = URL.init(string: urlString) else {
                return  imageCompletionHandler(nil)
            }
        
            KingfisherManager.shared.retrieveImage(with: url, options: nil, progressBlock: nil) { result in
                switch result {
                case .success(let value):
                    
                    DispatchQueue.global(qos: .background).async {
                        let resultImage: UIImage!
                        let size = CGSize(width: 100, height: 100)
                        UIGraphicsBeginImageContext(size)
                        resultImage = value.image
                        resultImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
                        UIGraphicsEndImageContext()
                        return imageCompletionHandler(resizedImage)
                    }

                case .failure:
                    return imageCompletionHandler(nil)
                }
            }
        }
    
    func createImage(imagePath: String) {
        if imagePath.isEmpty {
            thumbnail = .defaultImg
        } else {
            downloadImage(with: imagePath) { image in
                guard let image else {
                    self.thumbnail = .defaultImg
                    return
                }
                self.thumbnail = image
            }
        }
        annotationImageView.image = thumbnail
    }
    
//    func addImage(imagePath: String) {
//        self.imageURL = imagePath
//        if !imagePath.isEmpty {
//            if let url = URL(string: imagePath) {
//                annotationImageView.kf.setImage(
//                    with: url,
//                    placeholder: UIImage(named: "default_img"),
//                    options: [
//                        .processor(DownsamplingImageProcessor(size: CGSize(width: 50, height: 50))),
//                        .scaleFactor(UIScreen.main.scale),
//                        .cacheOriginalImage
//                    ])
//            }
//        } else {
//            annotationImageView.image = .defaultImg
//        }
//    }
    
}

