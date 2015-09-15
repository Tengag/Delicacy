//
//  Utils.swift
//  Delicacy
//
//  Created by Youwei Teng on 9/7/15.
//  Copyright © 2015 Dcard. All rights reserved.
//

import Foundation

class Utils {
	
	static func matchesForRegexInText(regex: String!, text: String!) -> [String] {
		do {
			let regex = try NSRegularExpression(pattern: regex, options: [])
			let nsString = text as NSString
			let results = regex.matchesInString(text,
				options: [], range: NSMakeRange(0, nsString.length))
			return results.map { nsString.substringWithRange($0.range)}
		} catch let error as NSError {
			print("invalid regex: \(error.localizedDescription)")
			return []
		}
	}
	
}

extension Int {
	static func random(range: Range<Int> ) -> Int {
		var offset = 0
		if range.startIndex < 0 {
			offset = abs(range.startIndex)
		}
		
		let mini = UInt32(range.startIndex + offset)
		let maxi = UInt32(range.endIndex   + offset)
		
		return Int(mini + arc4random_uniform(maxi - mini)) - offset
	}
}