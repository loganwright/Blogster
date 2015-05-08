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

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        postsListModel.fetchPosts()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Setup
    
    func setup() {
        setupNavigationBar()
        setupTableView()
    }
    
    func setupTableView() {
        postsListModel.tableView = tableView
        postsListModel.postSelectedCallback = postSelected
        postsListModel.fetchPosts()
    }
    
    func setupNavigationBar() {
        title = "Posts"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "refreshButtonPressed:")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addPostButtonPressed:")
    }
    
    func postSelected(post: TPPost) {
        navigationController?.pushViewController(CreateEditPostController(post: post), animated: true)
    }
    
    // MARK: Button Presses
    
    func refreshButtonPressed(sender: UIBarButtonItem) {
        postsListModel.fetchPosts()
    }
    
    func addPostButtonPressed(sender: UIBarButtonItem) {
        navigationController?.pushViewController(CreateEditPostController(), animated: true)
    }
    
}

class PostsListModel: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    var tableView: UITableView? {
        didSet {
            tableView?.registerClass(UITableViewCell.self, forCellReuseIdentifier: PostsListControllerCellIdentifier)
            tableView?.delegate = self
            tableView?.dataSource = self
        }
    }

    var posts: [TPPost] = [] {
        didSet {
            posts = posts.sorted({ (lhs: TPPost, rhs: TPPost) -> Bool in
                let leftInterval = lhs.updatedAt?.timeIntervalSince1970 ?? 0
                let rightInterval = rhs.updatedAt?.timeIntervalSince1970 ?? 0
                return leftInterval > rightInterval
            })
        }
    }
    
    var postSelectedCallback: ((post: TPPost) -> Void)? = nil
    
    // MARK: Networking
    
    func fetchPosts() {
        TPNetworking.getPosts { [weak self] (posts, error) -> () in
            self?.posts = posts ?? []
            self?.reloadTableView()
            if let err = error {
                println("Error fetching posts: \(error)")
            }
        }
    }
    
    // MARK: TableView
    
    func reloadTableView() {
        tableView?.reloadData()
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(PostsListControllerCellIdentifier, forIndexPath: indexPath) as? UITableViewCell
        cell?.textLabel?.text = posts[indexPath.row].title
        cell?.accessoryType = .DisclosureIndicator
        return cell!;
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        postSelectedCallback?(post: posts[indexPath.row])
    }
}
