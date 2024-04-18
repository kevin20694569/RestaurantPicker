import UIKit
let MainViewTopBottomAnchor : CGFloat = 8
let MainViewHorAnchorConstant : CGFloat = 12

class MessageTableViewCell: UITableViewCell, MessageTableCellProtocol {
    var mainViewCornerRadius : CGFloat! = 16

    
    var MainViewTopBottomAnchor : CGFloat {
        return 8
    }
    
    var MainViewHorAnchorConstant : CGFloat {
        return 12
    }
    

    
    var messageInstance : Message!
    
    var mainView : UIView! = UIView()
    
    weak var messageTableCellDelegate :  MessageTableCellDelegate?
    
    func configure(message : Message) {
        self.messageInstance = message
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutMainView()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutMainView() {
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.backgroundColor = .secondaryBackgroundColor
        self.contentView.addSubview(mainView)
        mainView.clipsToBounds = true
        mainView.layer.cornerRadius = mainViewCornerRadius
    }

}

class RhsMessageTableViewCell : MessageTableViewCell {
    
    override func layoutMainView() {
        super.layoutMainView()
        
        NSLayoutConstraint.activate([
            mainView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            mainView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 80),
            mainView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            mainView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -MainViewTopBottomAnchor * 2),
        ])
    }
    
    func setGesture() {
        
    }
}

class LhsMessageTableViewCell : MessageTableViewCell {
    
    var userImageView : UIImageView! = UIImageView()

    override func configure(message: Message) {
        super.configure(message: message)
        if let image = message.userImage {
            self.userImageView.image = image
        } else {
            if let url = message.senderUser?.imageURL {
                Task {
                    if let image = try? await url.getImageFromURL() {
                        message.userImage = image
                        self.userImageView.image = image
                    }
                }
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setGesture()

    }

    func setGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(showUserProfile))
        userImageView.isUserInteractionEnabled = true
        userImageView.addGestureRecognizer(gesture)
    }
    
    override func layoutMainView() {
        super.layoutMainView()
        layoutImageView()
        NSLayoutConstraint.activate([
            mainView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            mainView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -80),
            mainView.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: MainViewHorAnchorConstant),
            mainView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            mainView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -MainViewTopBottomAnchor * 2),
        ])
    }
    
    func layoutImageView() {
        userImageView.clipsToBounds = true
        userImageView.backgroundColor = .secondaryBackgroundColor
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(userImageView)
        NSLayoutConstraint.activate([
            userImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            userImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: MainViewHorAnchorConstant),
            userImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.09),
            userImageView.heightAnchor.constraint(equalTo: userImageView.widthAnchor, multiplier: 1),
            
        ])
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        userImageView.layer.cornerRadius = self.userImageView.bounds.height / 2
    }
    
    func hiddenSenderUserImageView(_ bool : Bool) {
        self.userImageView.isHidden = bool
    }
    
    @objc func showUserProfile() {
        messageTableCellDelegate?.showUserProfile(user_id: self.messageInstance.sender_id, user: self.messageInstance.senderUser)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}





class RhsTextViewMessageTableViewCell : RhsMessageTableViewCell, MessageTextViewCell {
    
    
    
    var messageTextView : UITextView! = UITextView()

    override func configure(message : Message) {
        super.configure(message: message)
        self.messageTextView.text = message.message
    }
    
    func layoutMessageTextView() {
        messageTextView.isEditable = false
        messageTextView.adjustsFontForContentSizeCategory = true
        messageTextView.backgroundColor = .clear
        messageTextView.isScrollEnabled = false
        messageTextView.font = UIFont.weightSystemSizeFont(systemFontStyle: .body, weight: .regular)
        messageTextView.textColor = .label
        messageTextView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(messageTextView)
        
        let offset : CGFloat = 6
        NSLayoutConstraint.activate([
            messageTextView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: offset),
            messageTextView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -offset),
            messageTextView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: offset / 2),
            messageTextView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -offset / 2),
        ])
    }
    
    override func layoutMainView() {
        super.layoutMainView()
        layoutMessageTextView()
        
    }
    
    
}



class LhsTextViewMessageTableViewCell: LhsMessageTableViewCell , MessageTextViewCell {
    
    var messageTextView : UITextView! = UITextView()
    
    
    
    override func configure(message: Message) {
        super.configure(message: message)
        self.messageTextView.text = message.message
    }
    
    func layoutMessageTextView() {
        messageTextView.isEditable = false
        messageTextView.adjustsFontForContentSizeCategory = true
        messageTextView.backgroundColor = .clear
        messageTextView.isScrollEnabled = false
        messageTextView.font = UIFont.weightSystemSizeFont(systemFontStyle: .body, weight: .regular)
        messageTextView.textColor = .label
        messageTextView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(messageTextView)
        
        let offset : CGFloat = 6
        NSLayoutConstraint.activate([
            messageTextView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: offset),
            messageTextView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -offset),
            messageTextView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: offset / 2),
            messageTextView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -offset / 2),
        ])
    }
    
    override func layoutMainView() {
        super.layoutMainView()
        layoutMessageTextView()
        

    }
    

}
