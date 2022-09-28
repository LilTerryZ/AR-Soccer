import Foundation

public class SlidingAnimatorFactory {
    
    public static func animator(options: SlidingAnimationOptions, duration: TimeInterval) -> SlidingAnimatorProtocol {
        var animators = [SlidingAnimatorProtocol]()

        if options.contains(.slidingMenu) {
            animators.append(SlidingStandardAnimator())
        }

        if options.contains(.blurBackground) {
            animators.append(SlidingBlurAnimator())
        }

        if options.contains(.menuShadow) {
            animators.append(SlidingShadowAnimator())
        }
        
        if options.contains(.dimmedBackground) {
            animators.append(SlidingDimmedBackgroundAnimator())
        }

		if options.contains(.content) {
            animators.append(SlidingContentAnimator())
        }

		if options.contains(.fixedMenu) {
            animators.append(SlidingFixedMenuAnimator())
        }

		if options.contains(.contentShadow) {
            animators.append(SlidingContentShadowAnimator())
        }
        
        animators.forEach({$0.duration = duration})        

		for option in SlidingAnimationOptions.customOptions {
			animators.append(option.animator!)
		}

        let animator = SlidingGroupAnimator()
        animator.addAnimators(animators)
        return animator
    }
}
