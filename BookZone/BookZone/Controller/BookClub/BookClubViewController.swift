//
//  BookClubViewController.swift
//  BookZone
//
//  Created by Paianu Vlad-Valentin on 22.04.2021.
//  Copyright © 2021 Paianu Vlad-Valentin. All rights reserved.
//

import UIKit
import Parchment

class BookClubViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var navbarView: NavbarView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var separatorView: UIView!

    var pagingViewController: PagingViewController?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setPageNavigation()
        view.bringSubviewToFront(separatorView)
    }

    // MARK: - UI

    private func configureUI() {
        configureNavbar()
    }

    private func configureNavbar() {
        navbarView.titleLabelNavbar.text = NSLocalizedString(K.NavbarTitles.bookClubs, comment: "")
    }

    // MARK: - Tab Navigation

    private func setPageNavigation() {
        let activeEventsVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "activeBookClubs") as! ActiveBookClubsViewController
        let expiredEventsVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "expiredBookClubs") as! ExpiredBookClubsViewController

        activeEventsVC.title = "Active events"
        expiredEventsVC.title = "Past events"

        self.pagingViewController = PagingViewController(viewControllers: [
            activeEventsVC,
            expiredEventsVC
        ])

        addChild(pagingViewController!)
        view.addSubview((pagingViewController?.view)!)
        pagingViewController?.didMove(toParent: self)
        pagingViewController?.view.translatesAutoresizingMaskIntoConstraints = false
        customizePagerNavigation(pagingViewController!)
    }

    private func customizePagerNavigation(_ pagingViewController: PagingViewController) {
        pagingViewController.menuItemSize = .sizeToFit(minWidth: 150, height: 60)
        pagingViewController.menuHorizontalAlignment = .center
        pagingViewController.font = UIFont(name: "HelveticaNeue-Medium", size: 16)!
        pagingViewController.selectedFont = UIFont(name: "HelveticaNeue-Bold", size: 16)!
        pagingViewController.selectedTextColor = .white
        pagingViewController.textColor = .white
        pagingViewController.backgroundColor = .clear
        pagingViewController.menuBackgroundColor = UIColor(named: "pink") ?? .systemGreen
        pagingViewController.borderOptions = .hidden
        pagingViewController.indicatorClass = CustomPagingIndicator.self
        pagingViewController.indicatorOptions = .visible(height: 7, zIndex: Int.max, spacing: UIEdgeInsets(top: 0, left: 65, bottom: 0, right: 65), insets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        pagingViewController.indicatorColor = .white


        NSLayoutConstraint.activate([
            pagingViewController.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            pagingViewController.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            pagingViewController.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            pagingViewController.view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -24)
        ])
    }
}
