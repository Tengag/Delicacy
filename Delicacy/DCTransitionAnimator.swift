//
//  DCAnimator.swift
//  Delicacy
//
//  Created by Youwei Teng on 9/8/15.
//  Copyright © 2015 Dcard. All rights reserved.
//

import UIKit


class DCTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
	
	let duration    = 0.4623 //小數點比較多比較厲害
	var presenting  = true
	var originFrame = CGRect.zero
	
	func transitionDuration(transitionContext: UIViewControllerContextTransitioning?)-> NSTimeInterval {
		return duration
	}
	
	func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
		
		let containerView = transitionContext.containerView()
		let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
		let fromView = self.presenting ? toView : transitionContext.viewForKey(UITransitionContextFromViewKey)!
		let initialFrame = self.presenting ? originFrame : fromView.frame
		let finalFrame = self.presenting ? fromView.frame : originFrame
		let xScaleFactor = self.presenting ?
			initialFrame.width / finalFrame.width :
			finalFrame.width / initialFrame.width
		let yScaleFactor = self.presenting ?
			initialFrame.height / finalFrame.height :
			finalFrame.height / initialFrame.height
		let scaleTransform = CGAffineTransformMakeScale(xScaleFactor, yScaleFactor)
		if self.presenting {
			fromView.transform = scaleTransform
			fromView.center = CGPoint(
				x: CGRectGetMidX(initialFrame),
				y: CGRectGetMidY(initialFrame))
			fromView.clipsToBounds = true
		}
		containerView!.addSubview(toView)
		containerView!.bringSubviewToFront(fromView)

		UIView.animateWithDuration(duration, delay:0.0,
			usingSpringWithDamping: 0.689,
			initialSpringVelocity: 0.0,
			options: [],
			animations: {
				fromView.transform = self.presenting ?
					CGAffineTransformIdentity : scaleTransform
				fromView.center = CGPoint(x: CGRectGetMidX(finalFrame),
					y: CGRectGetMidY(finalFrame))
			}, completion: { finished in
				transitionContext.completeTransition(finished)
			})
	}
}