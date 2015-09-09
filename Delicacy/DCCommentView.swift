//
//  DCCommentView.swift
//  Delicacy
//
//  Created by Youwei Teng on 9/7/15.
//  Copyright © 2015 Dcard. All rights reserved.
//

import UIKit

class DCCommentView: UIView {
	let comment: DCComment?
	
	init(comment: DCComment) {
		self.comment = comment
		super.init(frame: CGRect.zero)
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}

}
