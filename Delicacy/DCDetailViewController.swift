//
//  DCDetailViewController.swift
//  Delicacy
//
//  Created by Youwei Teng on 9/7/15.
//  Copyright © 2015 Dcard. All rights reserved.
//


// TODO: with navigation transistion

import UIKit

class DCDetailViewController: UIViewController, UIViewControllerTransitioningDelegate {
	var articleCell: DCArticleCell
	var backgroundImageView: UIImageView
	
	init (articleCell: DCArticleCell) {
		self.articleCell = articleCell
		self.backgroundImageView = UIImageView(image: self.articleCell.coverImageView.image)
		self.backgroundImageView.contentMode = .ScaleAspectFill
		self.backgroundImageView.backgroundColor = UIColor.blackColor()
		self.backgroundImageView.tintColor = UIColor.whiteColor()
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
	    fatalError("YOU SHOULD NOT USE STORYBOARD!")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.view.backgroundColor = UIColor.whiteColor()
		self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("actionClose:")))
		self.view.addSubview(self.backgroundImageView);
		self.backgroundImageView.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(self.view)
		}
	}
	
	func actionClose(tap: UITapGestureRecognizer) {
		presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
	}
}
