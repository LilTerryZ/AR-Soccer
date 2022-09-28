import UIKit

open class SlidingContentShadowAnimator: SlidingAnimatorProtocol {
    open var duration: TimeInterval = 0.25

    open func animate(leftMenuView: UIView, contentView: UIView, progress: CGFloat, animated: Bool, completion: (() -> Void)?) {
        contentView.layer.shadowColor = UIColor(red: 8/255.0, green: 46/255.0, blue: 88/255.0, alpha: 0.28).cgColor
        contentView.layer.shadowOffset = CGSize(width: 1, height: 0)
        contentView.layer.shadowRadius = 5
		contentView.layer.masksToBounds = false

        UIView.animate(withDuration: animated ? duration : 0, animations: {
            contentView.layer.shadowOpacity = Float(progress)
        }) { (_) in
            completion?()
        }
    }

	open func animate(rightMenuView: UIView, contentView: UIView, progress: CGFloat = 1, animated: Bool = true, completion: (() -> Void)? = nil) {
		contentView.layer.shadowColor = UIColor(red: 8/255.0, green: 46/255.0, blue: 88/255.0, alpha: 0.28).cgColor
        contentView.layer.shadowOffset = CGSize(width: 1, height: 0)
        contentView.layer.shadowRadius = 5
		contentView.layer.masksToBounds = false
		
        UIView.animate(withDuration: animated ? duration : 0, animations: {
            contentView.layer.shadowOpacity = Float(progress)
        }) { (_) in
            completion?()
        }
	}
}
