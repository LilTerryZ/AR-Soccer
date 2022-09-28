import UIKit

open class SlidingContentAnimator: SlidingAnimatorProtocol {

    open var duration: TimeInterval = 0.25

    open func animate(leftMenuView: UIView, contentView: UIView, progress: CGFloat, animated: Bool, completion: (() -> Void)?) {
		let leftMenuWidth = leftMenuView.frame.width
		var frame = contentView.frame
        let prg = max(0, min(progress, 1))
        frame.origin.x = leftMenuWidth * prg

        CATransaction.begin()
        CATransaction.setCompletionBlock {
            completion?()
        }
        CATransaction.setAnimationDuration(CFTimeInterval(duration))
		CATransaction.setAnimationTimingFunction(CAMediaTimingFunction.AM.easeOutCubic)
        UIView.animate(withDuration: duration) {
            contentView.frame = frame
        }

        CATransaction.commit()
    }

	open func animate(rightMenuView: UIView, contentView: UIView, progress: CGFloat = 1, animated: Bool = true, completion: (() -> Void)? = nil) {
		let rightMenuWidth = rightMenuView.frame.width
		var frame = contentView.frame
        let prg = max(0, min(progress, 1))
        frame.origin.x = -rightMenuWidth * prg

        CATransaction.begin()
        CATransaction.setCompletionBlock {
            completion?()
        }
        CATransaction.setAnimationDuration(CFTimeInterval(duration))
		CATransaction.setAnimationTimingFunction(CAMediaTimingFunction.AM.easeOutCubic)
        UIView.animate(withDuration: duration) {
            contentView.frame = frame
        }

        CATransaction.commit()
	}
}
