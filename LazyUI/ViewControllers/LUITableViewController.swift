//
//  LUITableViewController.swift
//  LazyUI
//
//  Created by Steven Hurtado on 7/14/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import UIKit

class LUITableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

}

extension LUITableViewController : LUINavigation {
    // MARK: - Navigation
    public var navigation: LUINavigationViewController?
    
    public func push(to vc: UIViewController) {
        if let navigation = self.navigation {
            navigation.push(to: vc)
        } else {
            self.present(LUINavigationViewController(rootVC: vc))
        }
    }
    
    public func pop() {
        if let navigation = self.navigation {
            navigation.popViewController(animated: true)
        }
    }
    
    public func popToRoot() {
        if let navigation = self.navigation {
            navigation.popToRootViewController(animated: true)
        }
    }
    
    public func present(_ vc: UIViewController) {
        self.present(vc, animated: true, completion: nil)
    }
    
    public func popOver(_ vc: UIViewController) {
        let popOver = LUIPopOverViewController(contentVC: vc)
        self.addChild(popOver)
        self.addView(popOver.view)
        self.fill(popOver.view)
    }
    
    public func dismissableModalViewController() -> LUINavigationViewController {
        return LUINavigationViewController(rootVC: self, largeTitle: false).forDismissal()
    }
}
