//
//  ArticleDatesource.swift
//  Delicacy
//
//  Created by Youwei Teng on 9/5/15.
//  Copyright © 2015 Dcard. All rights reserved.
//

import UIKit

class ArticleDatesource: NSObject, UITableViewDataSource {
	var articles: [Article]
	let configureBlock:(cell: UITableViewCell, article: Article) -> Void
	let cellIdentifier: String
	let tableView: UITableView
	var page: Int = 0
	var lastLoadedCount: Int = 0
	
// MARK: - Initializer
	
	init(tableView: UITableView, cellIdentifier: String, configureBlock:(cell: UITableViewCell, article: Article) -> Void){
		self.articles = [Article]()
		self.cellIdentifier = cellIdentifier
		self.configureBlock = configureBlock
		self.tableView = tableView;
		super.init()
		
		loadArticles()
	}
	
// MARK: - Table View Datasource
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier, forIndexPath: indexPath) as UITableViewCell
		self.configureBlock(cell: cell, article: self.articleAtIndex(indexPath))
		if self.lastLoadedCount > 0 && indexPath.row == (self.articles.count - 1) {
			self.loadArticles()
		}
		return cell;
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.articles.count
	}
	
	func articleAtIndex(indexPath: NSIndexPath) -> Article {
		return self.articles[indexPath.row]
	}
	
// MARK: - Private Methods
	
	private func loadArticles() {
		page++
		DataEngine.articlesAt(page) { (result: [Article]) in
			self.lastLoadedCount = result.count
			self.articles += result
			self.tableView.reloadData()
		}
	}
}