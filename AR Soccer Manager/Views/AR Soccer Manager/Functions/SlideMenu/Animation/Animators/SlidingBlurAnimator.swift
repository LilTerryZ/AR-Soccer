import UIKit

open class SlidingBlurAnimator: SlidingAnimatorProtocol {
    open var duration: TimeInterval = 0.25
    open var maxBlurRadius: CGFloat = 0.2
    
    let effectsView: BlurryOverlayView = {
        let view = BlurryOverlayView(effect: UIBlurEffect(style: .light))
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.isUserInteractionEnabled = false
        return view
    }()
    
    open func animate(leftMenuView: UIView, contentView: UIView, progress: CGFloat, animated: Bool, completion: (() -> Void)?) {
        if effectsView.superview == nil {
            effectsView.frame = contentView.bounds
            contentView.addSubview(effectsView)
        }

        self.effectsView.blur(amount: progress * maxBlurRadius, duration: animated ? duration : 0)
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            completion?()
        }
    }

	open func animate(rightMenuView: UIView, contentView: UIView, progress: CGFloat = 1, animated: Bool = true, completion: (() -> Void)? = nil) {
        if effectsView.superview == nil {
            effectsView.frame = contentView.bounds
            contentView.addSubview(effectsView)
        }
        self.effectsView.blur(amount: progress * maxBlurRadius, duration: animated ? duration : 0)
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            completion?()
        }
	}
}
