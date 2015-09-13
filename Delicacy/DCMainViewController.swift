//
//  ViewController.swift
//  Delicacy
//
//  Created by Youwei Teng on 9/5/15.
//  Copyright (c) 2015 Dcard. All rights reserved.
//

import UIKit
import SnapKit

let kArticleCellHeight: CGFloat = UIScreen.mainScreen().bounds.size.width

class DCMainViewController: UIViewController {
	var articleDatasource: DCArticleDatesource?
	let transitionAimator = DCTransitionAnimator()
	var didSetUpContraints: Bool = false
	var selectedCell: DCArticleCell?
	
// MARK: - View Controller Life Cycle

	override func viewDidLoad() {
		super.viewDidLoad()
		initialize();
		self.view.setNeedsUpdateConstraints()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	override func updateViewConstraints() {
		if !self.didSetUpContraints {
			self.tableView.snp_makeConstraints { (make) -> Void in
				make.edges.equalTo(self.view)
			}
			self.didSetUpContraints = true
		}
		super.updateViewConstraints()
	}
	
	override func prefersStatusBarHidden() -> Bool {
		return navigationController?.navigationBarHidden == true
	}
	
	override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
		return UIStatusBarAnimation.Fade
	}

// MARK: - Initialize Methods
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
// MARK: - Private methods

	func initialize() {
		navigationController?.setNavigationBarHidden(navigationController?.navigationBarHidden == false, animated: true)
		self.view.backgroundColor = UIColor.blackColor()
		self.view.addSubview(self.tableView);
	}
	
// MARK: - Lazy instantiate
	
	lazy var tableView: UITableView = {
		let lazyTableView = UITableView()
		lazyTableView.registerClass(DCArticleCell.self, forCellReuseIdentifier: NSStringFromClass(DCArticleCell.self) as String)
		lazyTableView.delegate = self
		lazyTableView.backgroundColor = UIColor .blackColor()
		lazyTableView.showsVerticalScrollIndicator = false
		lazyTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
		//hide the separator when empty
		lazyTableView.estimatedRowHeight = kArticleCellHeight
		lazyTableView.tableFooterView = UIView()
		self.articleDatasource = DCArticleDatesource(tableView: lazyTableView, cellIdentifier: NSStringFromClass(DCArticleCell.self)){
			(cell, article) in
			//Save the 🐴!!
			if let articleCell = cell as? DCArticleCell {
				articleCell.article = article
			}
		}
		lazyTableView.dataSource = self.articleDatasource
		return lazyTableView
	}();
	
}

extension DCMainViewController: UITableViewDelegate {
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return kArticleCellHeight
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		self.selectedCell = tableView .cellForRowAtIndexPath(indexPath) as? DCArticleCell
		let detailViewController: DCDetailViewController = DCDetailViewController(articleCell: self.selectedCell!)
		detailViewController.transitioningDelegate = self
		presentViewController(detailViewController, animated: true, completion: nil)
		tableView.deselectRowAtIndexPath(indexPath, animated: false)
	}
}

extension DCMainViewController: UIViewControllerTransitioningDelegate {
	
	func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		transitionAimator.originFrame = self.selectedCell!.superview!.convertRect(self.selectedCell!.frame, toView: nil)
		print(self.selectedCell?.frame)
		transitionAimator.presenting = true
		return transitionAimator
	}
// TODO: buggy dismiss
//	func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//		transitionAimator.presenting = false
//		return transitionAimator
//	}
}

extension DCMainViewController: UIScrollViewDelegate {
	
	func scrollViewDidScroll(scrollView: UIScrollView) {
		for cell: DCArticleCell in self.tableView.visibleCells as! Array {
			cell.applyParallax(scrollView.contentOffset.y)
		}
	}
}



