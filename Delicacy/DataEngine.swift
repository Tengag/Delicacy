//
//  DataEngine.swift
//  Delicacy
//
//  Created by Youwei Teng on 9/5/15.
//  Copyright (c) 2015 Dcard. All rights reserved.
//

import Foundation
import SwiftyJSON

import Alamofire

let kForumAlias: String = "food"

class DataEngine {
	
	static func articlesAt(page: Int, completion:(result: [Article]) -> Void){
		Alamofire
			.request(.GET,"https://www.dcard.tw/api/forum/\(kForumAlias)/\(page)/")
			.responseJSON { _, _, responseResult in
				if let value = responseResult.value {
					var result = [Article]()
					let json = JSON(value)
					for (_, articleJSON):(String, JSON) in json {
						let anArticle = Article().initWithJSON(articleJSON)
						result += [anArticle]
					}
					completion(result: result)
				} else {
					print("value is nil")
				}
			}
	}

}