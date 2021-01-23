//
//  ExplorePostCollectionViewCell.swift
//  TikTok
//
//  Created by Michael Kang on 1/14/21.
//

import UIKit

class ExplorePostCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "ExplorePostCollectionViewCell"
    
    private let thumbnail: UIImageView = {
        let thumbnail = UIImageView()
        thumbnail.contentMode = .scaleAspectFill
        thumbnail.clipsToBounds = true
        return thumbnail
    }()
    
    private let caption: UILabel = {
        let caption = UILabel()
        caption.numberOfLines = 0
        return caption
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.addSubview(thumbnail)
        contentView.addSubview(caption)
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let captionHeight = contentView.height / 5
        thumbnail.frame = CGRect(
            x: 0,
            y: 0,
            width: contentView.width,
            height: contentView.height-captionHeight
        )
        
        caption.frame = CGRect(
            x: 0,
            y: contentView.height-captionHeight,
            width: contentView.width,
            height: captionHeight
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        thumbnail.image = nil
        caption.text = nil
    }
    
    func configure(with viewModel: ExplorePostViewModel){
        thumbnail.image = viewModel.thumbnail
        caption.text = viewModel.caption
    }
}
