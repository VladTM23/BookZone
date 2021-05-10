//
//  ActiveBookClubsViewController.swift
//  BookZone
//
//  Created by Paianu Vlad-Valentin on 22.04.2021.
//  Copyright © 2021 Paianu Vlad-Valentin. All rights reserved.
//

import UIKit
import Firebase

class ActiveBookClubsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var bookClubsArray: [BookClub]?
    var selectedBookClubId: String = ""
    var selectedBookClubModel: BookClub?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUserBookClubEvents()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    private func registerTableView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(BookClubCollectionViewCell.self, forCellWithReuseIdentifier: "bookClubCell")
    }

    private func fetchUserBookClubEvents() {
        self.bookClubsArray = [BookClub]()
        guard let userId = Auth.auth().currentUser?.uid else { return }
        activityIndicator.startAnimating()
        BookClubsManager.shared.getActiveBookClubEvents(userId: userId) { bookClubsArray, error in
            if let error = error {
                print("Error fetching user book club events, \(error.localizedDescription)")
                self.activityIndicator.stopAnimating()
            }
            self.bookClubsArray = bookClubsArray
            self.activityIndicator.stopAnimating()
            self.collectionView.reloadData()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Identifiers.activeToInvite {
            let bookClubInviteVC = segue.destination as! BookClubInviteViewController
            bookClubInviteVC.bookTitle = selectedBookClubModel?.bookTitle ?? ""
            bookClubInviteVC.bookCoverUrl = selectedBookClubModel?.bookCoverURL ?? ""
            bookClubInviteVC.createMode = false
            bookClubInviteVC.bookClubModel = selectedBookClubModel
        }
    }
}

extension ActiveBookClubsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookClubsArray?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let safeBookClubsArray = bookClubsArray else { return UICollectionViewCell.init(frame: .zero)}
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bookClubCell", for: indexPath as IndexPath) as!
            BookClubCollectionViewCell
        cell.configureCell(with: safeBookClubsArray[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 25
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: collectionView.frame.width - 30, height: 120)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! BookClubCollectionViewCell
        self.selectedBookClubModel = cell.bookClub ?? nil
        if let _ = selectedBookClubModel {
            performSegue(withIdentifier: K.Identifiers.activeToInvite, sender: self)
        }
    }
}

