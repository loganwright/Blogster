//
//  PostsListController.swift
//  Blogster
//
//  Created by Logan Wright on 5/7/15.
//  Copyright (c) 2015 lowriDevs. All rights reserved.
//

import UIKit

private let PostsListControllerCellIdentifier = "PostsListControllerCellIdentifier"

class PostsListController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var postsListModel = PostsListModel()
    
    // MARK: Initialization
    
    init() {
        super.init(nibName: "PostsListController", bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Setup
    
    func setup() {
        setupTableView()
    }
    
    func setupTableView() {
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: PostsListControllerCellIdentifier)
        tableView.delegate = postsListModel
        tableView.dataSource = postsListModel
    }
}

class PostsListModel: NSObject, UITableViewDataSource, UITableViewDelegate {
    var posts: [TPPost] = []
    
    // MARK: UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(PostsListControllerCellIdentifier, forIndexPath: indexPath) as? UITableViewCell
        cell?.textLabel?.text = "Hey"
        cell?.detailTextLabel?.text = "Sup"
        return cell!;
    }
}
