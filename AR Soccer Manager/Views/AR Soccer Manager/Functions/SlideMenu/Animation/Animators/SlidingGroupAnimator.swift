import UIKit

open class SlidingGroupAnimator: SlidingAnimatorProtocol {
    open var duration: TimeInterval = 0.25
    
    open var animators: [SlidingAnimatorProtocol] = []
    
    open func addAnimator(_ animator: SlidingAnimatorProtocol) {
        self.animators.append(animator)
    }
    
    open func addAnimators(_ animators: [SlidingAnimatorProtocol]) {
        animators.forEach({self.animators.append($0)})
    }
    
    open func animate(leftMenuView: UIView, contentView: UIView, progress: CGFloat, animated: Bool, completion: (() -> Void)?) {
        let group = DispatchGroup()
        
        for animator in animators {
            group.enter()
            animator.animate(leftMenuView: leftMenuView, contentView: contentView, progress: progress, animated: animated) {
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion?()
        }
    }

	open func animate(rightMenuView: UIView, contentView: UIView, progress: CGFloat = 1, animated: Bool = true, completion: (() -> Void)? = nil) {
		let group = DispatchGroup()

        for animator in animators {
            group.enter()
            animator.animate(rightMenuView: rightMenuView, contentView: contentView, progress: progress, animated: animated) {
                group.leave()
            }
        }

        group.notify(queue: .main) {
            completion?()
        }
	}
}
