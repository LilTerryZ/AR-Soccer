import UIKit

open class SlidingStandardAnimator: SlidingAnimatorProtocol {
    
    open var duration: TimeInterval = 0.25
    
    open func animate(leftMenuView: UIView, contentView: UIView, progress: CGFloat, animated: Bool, completion: (() -> Void)?) {
		
        var frame = leftMenuView.frame
        let prg = max(0, min(progress, 1))
        frame.origin.x = frame.size.width * (prg - 1)
        
        if prg > 0 {
            leftMenuView.isHidden = false
        }
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            completion?()
            if prg == 0 {
                leftMenuView.isHidden = true
            }
        }
        CATransaction.setAnimationDuration(CFTimeInterval(duration))
		CATransaction.setAnimationTimingFunction(CAMediaTimingFunction.AM.easeOutCubic)
        UIView.animate(withDuration: duration) {
            leftMenuView.frame = frame
        }
        
        CATransaction.commit()
    }

	open func animate(rightMenuView: UIView, contentView: UIView, progress: CGFloat = 1, animated: Bool = true, completion: (() -> Void)? = nil) {
		let contentFrame = contentView.frame
        var frame = rightMenuView.frame
        let prg = max(0, min(progress, 1))
		frame.origin.x = contentFrame.width - frame.size.width * prg

        if prg > 0 {
            rightMenuView.isHidden = false
        }

        CATransaction.begin()
        CATransaction.setCompletionBlock {
            completion?()
            if prg == 0 {
                rightMenuView.isHidden = true
            }
        }
        CATransaction.setAnimationDuration(CFTimeInterval(duration))
		CATransaction.setAnimationTimingFunction(CAMediaTimingFunction.AM.easeOutCubic)
        UIView.animate(withDuration: duration) {
            rightMenuView.frame = frame
        }

        CATransaction.commit()
	}
}
