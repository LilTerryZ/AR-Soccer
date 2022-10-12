import UIKit

open class SlidingDimmedBackgroundAnimator: SlidingAnimatorProtocol {
    open var duration: TimeInterval = 0.25
    
    public let overlayView: UIView = {
        let view = UIView()
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.isUserInteractionEnabled = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.45)
		view.alpha = 0
        return view
    }()
    
    open func animate(leftMenuView: UIView, contentView: UIView, progress: CGFloat, animated: Bool, completion: (() -> Void)?) {
        if overlayView.superview == nil {
            overlayView.frame = contentView.bounds
            contentView.addSubview(overlayView)
        }

        UIView.animate(withDuration: animated ? duration : 0, animations: {
            self.overlayView.alpha = progress
        }) { (_) in
            completion?()
        }
    }

	open func animate(rightMenuView: UIView, contentView: UIView, progress: CGFloat = 1, animated: Bool = true, completion: (() -> Void)? = nil) {
        if overlayView.superview == nil {
            overlayView.frame = contentView.bounds
            contentView.addSubview(overlayView)
        }

        UIView.animate(withDuration: animated ? duration : 0, animations: {
            self.overlayView.alpha = progress
        }) { (_) in
            completion?()
        }
	}

	public init() {}
}
