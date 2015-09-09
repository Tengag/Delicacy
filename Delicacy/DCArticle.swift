//
//  DCArticle.swift
//  Delicacy
//
//  Created by Youwei Teng on 9/5/15.
//  Copyright (c) 2015 Dcard. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

enum DCGender {
	case Male
	case Female
	case None
}

class DCArticle {

	var identifier: NSNumber?
	var title: String?
	var coverPhotoUrl: NSURL?
	var originalUrl: String?
	var content: String?
	
	var likeCount: NSNumber?
	var commentCount: NSNumber?
	var createdAt: NSDate?
	var updatedAt: NSDate?
	
	var contentLoaded: Bool
	var school: String?
	var department: String?
	var gender: DCGender = .None
	
	init(){
		self.contentLoaded = false;
		self.coverPhotoUrl = NSURL()
	}
	
	func initWithJSON(articleJSON: JSON) -> DCArticle {
		
		//Article Info
		if let identifier = articleJSON["id"].number {
			self.identifier = identifier
		}
		self.title = articleJSON["version",0,"title"].string
		self.content = articleJSON["version",0,"content"].string
		self.likeCount = articleJSON["likeCount"].number;
		self.commentCount = articleJSON["comment"].number;
		
		//Member Info
		self.school = articleJSON["member","school"].string
		self.department = articleJSON["member","department"].string
		self.gender = articleJSON["member","gender"].string == "M" ? .Male:.Female
		
		return self;
	}
	
}

extension DCArticle {
	
	func loadContent(completion:() -> Void) {
		if !contentLoaded {
			//print("loadContent request url = https://www.dcard.tw/api/post/all/\(self.identifier!)")
			Alamofire
				.request(.GET,"https://www.dcard.tw/api/post/all/\(self.identifier!)")
				.responseJSON { _, _, responseResult in
					self.initWithJSON(JSON(responseResult.value!))
					self.extractPhotos()
					self.contentLoaded = true
					completion()
			}
		} else {
			completion()
		}
	}
	
	func extractPhotos() -> [String] {
		let photos = Utils.matchesForRegexInText("(https?:\\/\\/(?:i\\.)?imgur\\.com\\/(?:\\w*)(?:.\\w*))", text: self.content);
		if photos.count > 0 {
			print(photos.first!)
			if photos.first!.containsString("http://imgur.com") || photos.first!.containsString("https://imgur.com") {
				let imgurLink: String = photos.first!.stringByReplacingOccurrencesOfString("imgur", withString: "i.imgur")
				let thumbnailUrl: String = "\(imgurLink)l.jpg"
				self.coverPhotoUrl = NSURL(string: thumbnailUrl)
			} else {
				self.coverPhotoUrl = NSURL(string: photos.first!)
			}
		}
		return photos;
	}
	
}