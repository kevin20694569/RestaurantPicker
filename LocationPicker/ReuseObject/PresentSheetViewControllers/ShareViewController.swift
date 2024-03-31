import UIKit

class ShareViewController : PresentedSheetViewController, UICollectionViewDelegate, UICollectionViewDataSource ,LimitSelfFramePresentedView {
    
    
    var isLoadingFriends : Bool! = false
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let friend = friends[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShareUserCollectionViewCell", for: indexPath) as! ShareUserCollectionViewCell
        cell.configure(user: friend.user)
        return cell
    }
    
    var currentPost : Post!
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return friends.count
    }
    
    func loadFriends(user_id : Int, date : String) async  {
        do {
            isLoadingFriends = true
            let newFriends = try await FriendsManager.shared.getUserFriendsFromUserID(user_id: user_id, Date: date)
            let indexPaths = Array (self.friends.count..<newFriends.count + self.friends.count).map {
                IndexPath(row: $0, section: 0)
            }
            self.friends.insert(contentsOf: newFriends, at: self.friends.count)
            self.collectionView.insertItems(at: indexPaths)
            isLoadingFriends = false
        } catch {
            print("errorrr", error )
        }
    }
    
    var collectionView : UICollectionView! = UICollectionView(frame: .zero, collectionViewLayout: .init())
    
    var searchBar : UISearchBar! = UISearchBar()
    
    var friends : [Friend]! = [] //= User.examples
    
    var bottomView : UIView! = UIView()
    
    var shareButton : ZoomAnimatedButton! = ZoomAnimatedButton()
    
    
    func registerCells() {
        self.collectionView.register(ShareUserCollectionViewCell.self, forCellWithReuseIdentifier: "ShareUserCollectionViewCell")
    }
    
    override func layout() {
        super.layout()
        self.view.backgroundColor = .backgroundPrimary
        self.view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delaysContentTouches = false
        collectionView.allowsMultipleSelection = true
        collectionView.backgroundColor = .clear
        self.view.addSubview(bottomView)
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(shareButton)
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: titleSlideView.bottomAnchor),
            searchBar.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            
            bottomView.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            bottomView.heightAnchor.constraint(equalTo: searchBar.heightAnchor, multiplier: 1.2),
            bottomView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            shareButton.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor),
            shareButton.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor),
            shareButton.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 32  ),
            shareButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -32  ),
            
        ])
    }
    
    func layoutShareButton() {
        var config = UIButton.Configuration.filled()
        let attString = AttributedString("傳送", attributes: AttributeContainer([
            .font : UIFont.weightSystemSizeFont(systemFontStyle: .title3, weight: .regular)
        ]))
        config.baseBackgroundColor = UIColor.secondaryBackgroundColor
        config.baseForegroundColor = UIColor.secondaryLabelColor
        config.attributedTitle = attString
        shareButton.configuration = config
        shareButton.addTarget(self, action: #selector(sharePost( _ :)), for: .touchUpInside)
    }
    
    @objc func sharePost( _ button : UIButton) {
        let ids = selectedSharedUserDict.values.compactMap() {
            return $0.user.user_id
        }
        
        SocketIOManager.shared.sharePost(to_user_ids: ids, sender_id: Constant.user_id, post: currentPost)
        self.dismiss(animated: true)
    }
    
    func updateShareButton(enable : Bool) {
        
        self.shareButton.animatedEnable = enable
        if var config = shareButton.configuration {
            if enable {
                config.attributedTitle?.font =  UIFont.weightSystemSizeFont(systemFontStyle: .title3, weight: .bold)
                config.baseBackgroundColor = .tintOrange
                config.baseForegroundColor = .label
            } else {
                config.attributedTitle?.font =  UIFont.weightSystemSizeFont(systemFontStyle: .title3, weight: .regular)
                config.baseBackgroundColor = .secondaryLabelColor
                config.baseForegroundColor = .secondaryBackgroundColor
                
            }
            shareButton.configuration = config
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            await loadFriends(user_id: Constant.user_id, date: "")
        }
        registerCells()
        layout()
        layoutShareButton()
        setCollectionViewStyle()
    }
    
    func setCollectionViewStyle() {
        collectionView.delegate = self
        collectionView.dataSource = self
        let space : CGFloat = 1
        let flow = UICollectionViewFlowLayout()
        let width = maxWidth / 3 - 2 * space
        
        flow.itemSize = CGSize(width: width, height: width)
        flow.minimumLineSpacing = space
        flow.minimumInteritemSpacing = space
        self.collectionView.collectionViewLayout = flow
    }
    
    var canTouchOutsideToDismiss: Bool! = true
    
    
    var selectedSharedUserDict :  [IndexPath : Friend] = [:] { didSet {
        canTouchOutsideToDismiss = selectedSharedUserDict.count == 0
        updateShareButton(enable: selectedSharedUserDict.count != 0)
    }}
}




extension ShareViewController {
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? ShareUserCollectionViewCell
        cell?.beSelected(selected: true)
        let friend = self.friends[indexPath.row]
        selectedSharedUserDict[indexPath] = friend
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? ShareUserCollectionViewCell
        cell?.beSelected(selected: false)
        selectedSharedUserDict.removeValue(forKey: indexPath)
        return
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if selectedSharedUserDict[indexPath] != nil {
            let cell = cell as! ShareUserCollectionViewCell
            cell.beSelected(selected: true)
        }
        guard !isLoadingFriends else {
            return
        }
        if indexPath.row == self.friends.count - 6 {
            isLoadingFriends = true
            
            Task {
                
                
            }
        }
    }
}
