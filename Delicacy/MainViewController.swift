//
//  MainViewController.swift
//  Delicacy
//
//  Created by Youwei Teng on 9/5/15.
//  Copyright (c) 2015 Dcard. All rights reserved.
//

import UIKit
import SnapKit

let kArticleCellHeight: CGFloat = UIScreen.mainScreen().bounds.size.width

class MainViewController: UIViewController {
	var articleDatasource: ArticleDatesource?
	let transitionAimator = TransitionAnimator()
	var didSetUpContraints: Bool = false
	var selectedCell: ArticleCell?
	
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
		lazyTableView.registerClass(ArticleCell.self, forCellReuseIdentifier: NSStringFromClass(ArticleCell.self) as String)
		lazyTableView.delegate = self
		lazyTableView.backgroundColor = UIColor .blackColor()
		lazyTableView.showsVerticalScrollIndicator = false
		lazyTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
		//hide the separator when empty
		lazyTableView.estimatedRowHeight = kArticleCellHeight
		lazyTableView.tableFooterView = UIView()
		self.articleDatasource = ArticleDatesource(tableView: lazyTableView, cellIdentifier: NSStringFromClass(ArticleCell.self)){
			(cell, article) in
			//Save the 🐴!!
			if let articleCell = cell as? ArticleCell {
				articleCell.article = article
			}
		}
		lazyTableView.dataSource = self.articleDatasource
		return lazyTableView
	}();
	
}

extension MainViewController: UITableViewDelegate {
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return kArticleCellHeight
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		self.selectedCell = tableView .cellForRowAtIndexPath(indexPath) as? ArticleCell
		let detailViewController: DetailViewController = DetailViewController(articleCell: self.selectedCell!)
		detailViewController.transitioningDelegate = self
		presentViewController(detailViewController, animated: true, completion: nil)
		tableView.deselectRowAtIndexPath(indexPath, animated: false)
	}
}

extension MainViewController: UIViewControllerTransitioningDelegate {
	
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

extension MainViewController: UIScrollViewDelegate {
	
	func scrollViewDidScroll(scrollView: UIScrollView) {
		for cell: ArticleCell in self.tableView.visibleCells as! Array {
			cell.applyParallax(scrollView.contentOffset.y)
		}
	}
}



