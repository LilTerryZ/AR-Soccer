import UIKit

open class SlidingFixedMenuAnimator: SlidingAnimatorProtocol {

    open var duration: TimeInterval = 0.25

    open func animate(leftMenuView: UIView, contentView: UIView, progress: CGFloat, animated: Bool, completion: (() -> Void)?) {
        var frame = leftMenuView.frame
        let prg = max(0, min(progress, 1))
        frame.origin.x = 0

		leftMenuView.superview?.sendSubviewToBack(leftMenuView)
        if prg > 0 {
            leftMenuView.isHidden = false
        }

		leftMenuView.frame = frame
		completion?()
		if prg == 0 {
			DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
				frame.origin.x = -frame.width
				leftMenuView.frame = frame
				leftMenuView.isHidden = true
			}
		}
    }

	open func animate(rightMenuView: UIView, contentView: UIView, progress: CGFloat = 1, animated: Bool = true, completion: (() -> Void)? = nil) {
		let contentFrame = contentView.frame
        var frame = rightMenuView.frame
        let prg = max(0, min(progress, 1))
		frame.origin.x = contentFrame.width - frame.size.width

		rightMenuView.superview?.sendSubviewToBack(rightMenuView)
        if prg > 0 {
            rightMenuView.isHidden = false
        }
		rightMenuView.frame = frame
		completion?()
		if prg == 0 {
			DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
				frame.origin.x = contentFrame.width
				rightMenuView.frame = frame
				rightMenuView.isHidden = true
			}
		}
	}
}
