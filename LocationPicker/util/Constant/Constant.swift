import UIKit
struct Constant {
    static let httpIP : String = APIKey.IP
    static let GoogleMapAPIKey : String = APIKey.googleMapAPIKey
    static let standardCornerRadius : CGFloat = 46
    static var bottomBarViewHeight : CGFloat = 83
    
    static let user_id : Int = 1
    
    static let GridPostCellRadius : CGFloat = 16
    
    static var standardNavBarFrame : CGRect?
    
    static let standardMinimumTableCellCollectionViewHeight : CGFloat! = UIScreen.main.bounds.height * 0.4
    static let standardMediumTableCellCollectionViewHeight : CGFloat! = UIScreen.main.bounds.height * 0.6
    static let standardLargeTableCellCollectionViewHeight : CGFloat! = UIScreen.main.bounds.height * 0.7
    
    static let getServerData : Bool = true
    
    static let imageURL : URL = URL(string: "https://scontent.ftpe3-2.fna.fbcdn.net/v/t1.6435-9/159649592_2785742238330866_5017627114767742199_n.jpg?_nc_cat=108&ccb=1-7&_nc_sid=be3454&_nc_ohc=RcUQSzAwvBQAX8ABuNh&_nc_ht=scontent.ftpe3-2.fna&oh=00_AfCSgY4uQ3LXl5CjZmgPDWxDaVjxMJTlt24FL4_I3zzU6A&oe=65B4E199")!
    static let wholePageCAMediaTimingFunction : CAMediaTimingFunction =  CAMediaTimingFunction(controlPoints: 0.2, 0.95, 0.96, 1)
    static let presentPostTableViewCAMediaTimingFunction : CAMediaTimingFunction =  CAMediaTimingFunction(controlPoints: 0.05, 0.98, 0.97, 1)
    static var safeAreaInsets : UIEdgeInsets = UIEdgeInsets()
    static var navBarHeight : CGFloat = 0
    
    static let standardTableViewInset : UIEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
    
    static let symbolConfig = UIImage.SymbolConfiguration(font: UIFont.weightSystemSizeFont(systemFontStyle: .title3, weight: .bold))
    
    static let titleSliderViewHeight : CGFloat! = 30
    
    static let userImage : UIImage! = UIImage(named: "user")!
    
}
