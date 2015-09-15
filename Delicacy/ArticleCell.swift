//
//  ArticleCell.swift
//  Delicacy
//
//  Created by Youwei Teng on 9/5/15.
//  Copyright © 2015 Dcard. All rights reserved.
//

import UIKit
import SDWebImage

let kCoverPhotoParallaxHeight: CGFloat = 40

class ArticleCell: UITableViewCell {
	
	let kArticleCellTitleHeight: Float = 70
	
	//UI
	let coverImageView: UIImageView = UIImageView(frame: CGRectMake(0, 0, kArticleCellHeight, kArticleCellHeight + kCoverPhotoParallaxHeight))
	let genderImageView: UIImageView = UIImageView()
	let titleLabel: UILabel = UILabel()
	let descriptionLabel: UILabel = UILabel()
	let schoolLabel: UILabel = UILabel()
	let visualEffectView: UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
	var vibrancyEffectView = UIVisualEffectView(effect: UIVibrancyEffect(forBlurEffect: UIBlurEffect(style: .Light)))
	let blurTitleBackground: UIView = UIView()
	let loadingImageArray: Array = [UIImage(named: "milk"),UIImage(named: "meal"),UIImage(named: "coffee"),UIImage(named: "hot_dog")]
	
	var didSetUpContraints: Bool = false
	
	var article: Article? {
		didSet {
			//no containts imgur url
			self.article?.loadContent { () -> Void in
				if((self.article?.coverPhotoUrl) != nil) {
					self.coverImageView.sd_setImageWithURL(self.article?.coverPhotoUrl!, placeholderImage: self.placeholderImage, options: .LowPriority, progress: { (receivedSize: Int, expectedSize: Int) -> Void in
						self.coverImageView.alpha = CGFloat(receivedSize) / CGFloat(expectedSize)
					}, completed: { _, _, _, _  in
						self.coverImageView.alpha = 1
						self.coverImageView.contentMode = .ScaleAspectFill
					})
				} else {
					self.coverImageView.alpha = 1
					self.coverImageView.image = self.placeholderImage
				}
			}
			self.titleLabel.text = self.article?.title
			self.descriptionLabel.text = self.article?.content
			self.genderImageView.image = self.genderImage
			
		}
	}
	
	override func prepareForReuse() {
		//TODO: cancel download queue
		self.coverImageView.alpha = 1
		self.coverImageView.contentMode = .Center
		self.coverImageView.image = self.placeholderImage
	}
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {

		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
//		self.coverImageView.translatesAutoresizingMaskIntoConstraints = false
		self.coverImageView.image = UIImage(named: "test")
		self.coverImageView.layer.masksToBounds = true
		self.coverImageView.contentMode = .Center
		self.coverImageView.tintColor = UIColor.whiteColor()
		self.coverImageView.clipsToBounds = true
		self.contentView.addSubview(self.coverImageView)
		
		self.blurTitleBackground.translatesAutoresizingMaskIntoConstraints = false
		self.blurTitleBackground.backgroundColor = UIColor.clearColor()
		self.contentView.addSubview(self.blurTitleBackground)
		
		self.visualEffectView.translatesAutoresizingMaskIntoConstraints = false
		self.blurTitleBackground.addSubview(self.visualEffectView)
		
		self.vibrancyEffectView.translatesAutoresizingMaskIntoConstraints = false
		self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
		
		self.titleLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
		self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
		self.descriptionLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
		
		self.vibrancyEffectView.contentView.addSubview(self.titleLabel)
		self.vibrancyEffectView.contentView.addSubview(self.descriptionLabel)
		
		self.visualEffectView.contentView.addSubview(self.vibrancyEffectView)
		
		self.genderImageView.translatesAutoresizingMaskIntoConstraints = false
		self.genderImageView.image = UIImage(named: "ic_head_anon")
		self.contentView.addSubview(self.genderImageView)
		
		self.selectionStyle = .None
		self.contentView.backgroundColor = UIColor.blackColor()
		self.layer.masksToBounds = true
		self.contentView.clipsToBounds = true
		
		//set the tableview separator to full width
		self.preservesSuperviewLayoutMargins = false
		self.layoutMargins = UIEdgeInsetsZero
		self.separatorInset = UIEdgeInsetsZero
		
		//update contraints
		self.contentView.setNeedsUpdateConstraints()
	}
	
	required init?(coder decoder: NSCoder) {
		super.init(coder: decoder)
	}
	
	override func updateConstraints() {
		if !didSetUpContraints {
//			self.coverImageView.snp_makeConstraints { (make) -> Void in
//				make.left.equalTo(self.contentView)
//				make.right.equalTo(self.contentView)
//				make.bottom.equalTo(self.contentView).offset(kCoverPhotoParallaxHeight/2)
//				make.top.equalTo(self.contentView).offset(-kCoverPhotoParallaxHeight/2)
//			}
			self.blurTitleBackground.snp_makeConstraints { (make) -> Void in
				make.left.equalTo(self.contentView)
				make.right.equalTo(self.contentView)
				make.bottom.equalTo(self.contentView)
				make.height.equalTo(kArticleCellTitleHeight)
			}
			self.descriptionLabel.snp_makeConstraints { (make) -> Void in
				make.left.equalTo(self.genderImageView.snp_right).offset(10)
				make.right.equalTo(self.contentView).offset(-25)
				make.height.equalTo(20)
				make.bottom.equalTo(self.blurTitleBackground.snp_bottom).offset(-10)
			}
			self.titleLabel.snp_makeConstraints { (make) -> Void in
				make.left.equalTo(self.genderImageView.snp_right).offset(10)
				make.right.equalTo(self.contentView).offset(-25)
				make.top.equalTo(self.blurTitleBackground).offset(8)
				make.height.equalTo(30)
			}
			self.visualEffectView.snp_makeConstraints { (make) -> Void in
				make.edges.equalTo(self.blurTitleBackground)
			}
			self.vibrancyEffectView.snp_makeConstraints { (make) -> Void in
				make.edges.equalTo(self.blurTitleBackground)
			}
			self.genderImageView.snp_makeConstraints { (make) -> Void in
				let imageSize: CGFloat = 35
				make.size.equalTo(CGSize(width: imageSize,height: imageSize))
				make.left.equalTo(self.contentView).offset(15)
				make.centerY.equalTo(blurTitleBackground)
			}
			self.didSetUpContraints = true
		}
		super.updateConstraints()
	}
	
// MARK - Private Methods
	
	var genderImage: UIImage {
		return (self.article?.gender == .Male ? UIImage(named: "ic_head_boy"):UIImage(named: "ic_head_girl"))!
	}
	
	var placeholderImage: UIImage {
		return self.loadingImageArray[Int.random(0...self.loadingImageArray.count - 1)]!
	}
	
// MARK - Public Methods
	
	func applyParallax(offsetY: CGFloat) {
		let x = self.coverImageView.frame.origin.x
		let w = self.coverImageView.bounds.width
		let h = self.coverImageView.bounds.height
		let y = ((offsetY - self.frame.origin.y) / h) * kCoverPhotoParallaxHeight
		self.coverImageView.frame = CGRectMake(x, y, w, h)
	}
	
}
