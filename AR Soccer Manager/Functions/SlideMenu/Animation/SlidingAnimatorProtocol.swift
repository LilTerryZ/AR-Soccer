import UIKit

public protocol SlidingAnimatorProtocol: AnyObject {
    var duration: TimeInterval {get set}
    
    func animate(leftMenuView: UIView, contentView: UIView, progress: CGFloat, animated: Bool, completion: (()->Void)?)
	func animate(rightMenuView: UIView, contentView: UIView, progress: CGFloat, animated: Bool, completion: (()->Void)?)
}

extension SlidingAnimatorProtocol {
    
    public func animate(leftMenuView: UIView, contentView: UIView, progress: CGFloat = 1, animated: Bool = true, completion: (()->Void)? = nil) {
        animate(leftMenuView: leftMenuView, contentView: contentView, progress: progress, animated: animated, completion: completion)
    }

    public func animate(rightMenuView: UIView, contentView: UIView, progress: CGFloat = 1, animated: Bool = true, completion: (()->Void)? = nil) {
        animate(rightMenuView: rightMenuView, contentView: contentView, progress: progress, animated: animated, completion: completion)
    }
}
