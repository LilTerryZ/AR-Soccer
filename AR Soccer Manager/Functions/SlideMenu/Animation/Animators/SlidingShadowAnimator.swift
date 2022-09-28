import UIKit

open class SlidingShadowAnimator: SlidingAnimatorProtocol {
    open var duration: TimeInterval = 0.25
    
    open func animate(leftMenuView: UIView, contentView: UIView, progress: CGFloat, animated: Bool, completion: (() -> Void)?) {
        leftMenuView.layer.shadowColor = UIColor(red: 8/255.0, green: 46/255.0, blue: 88/255.0, alpha: 0.28).cgColor
        leftMenuView.layer.shadowOffset = CGSize(width: 1, height: 0)
        leftMenuView.layer.shadowRadius = 5
        
        UIView.animate(withDuration: animated ? duration : 0, animations: {
            leftMenuView.layer.shadowOpacity = Float(progress)
        }) { (_) in
            completion?()
        }
    }

	open func animate(rightMenuView: UIView, contentView: UIView, progress: CGFloat = 1, animated: Bool = true, completion: (() -> Void)? = nil) {
		rightMenuView.layer.shadowColor = UIColor(red: 8/255.0, green: 46/255.0, blue: 88/255.0, alpha: 0.28).cgColor
        rightMenuView.layer.shadowOffset = CGSize(width: -1, height: 0)
        rightMenuView.layer.shadowRadius = 5

        UIView.animate(withDuration: animated ? duration : 0, animations: {
            rightMenuView.layer.shadowOpacity = Float(progress)
        }) { (_) in
            completion?()
        }
	}
}
