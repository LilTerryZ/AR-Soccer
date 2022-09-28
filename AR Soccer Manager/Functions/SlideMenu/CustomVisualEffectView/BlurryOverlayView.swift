import UIKit

class BlurryOverlayView: UIVisualEffectView {
    private var animator: UIViewPropertyAnimator!
    private var delta: CGFloat = 0 // The amount to change fractionComplete for each tick
    private var target: CGFloat = 0 // The fractionComplete we're animating to
    private var displayLink: CADisplayLink!
    private var isBluringUp = false
    
    override init(effect: UIVisualEffect?) {
        super.init(effect: effect)
        prepare()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepare()
    }
    
    // Common init
    
    private func prepare() {
        effect = nil // Starts out with no blur
        isHidden = true // Enables user interaction through the view
        
        // The animation to add an effect
        animator = UIViewPropertyAnimator(duration: 1, curve: .easeInOut) {
            self.effect = UIBlurEffect(style: .light)
        }
        if #available(iOS 11.0, *) {
            animator.pausesOnCompletion = true // Fixes background bug
        }
        
        // Using a display link to animate animator.fractionComplete
        displayLink = CADisplayLink(target: self, selector: #selector(tick))
        displayLink.isPaused = true        
        displayLink.add(to: .main, forMode: RunLoop.Mode.common)
    }
    
    func blur(amount: CGFloat = 0.2, duration: TimeInterval = 0.3) {
        isHidden = false // Disable user interaction
        
        if target == amount { //already blured
            return
        }
        
        isBluringUp = amount > target
        
        if duration == 0 {
            delta = (amount - target)
        } else {
            delta = (amount - target) / (60 * CGFloat(duration)) // Assuming 60hz refresh rate
        }
        target = amount
        
        // Start animating fractionComplete
        displayLink.isPaused = false
    }
    
    @objc private func tick() {
        animator.fractionComplete += delta
        
        if animator.fractionComplete <= 0 {
            // Done blurring out
            isHidden = true
            displayLink.isPaused = true
        } else if animator.fractionComplete >= 1 {
            // Done blurring in
            displayLink.isPaused = true
        } else {
            if isBluringUp {
                if animator.fractionComplete >= target {
                    // Done blurring in
                    displayLink.isPaused = true
                }
            } else {
                if animator.fractionComplete <= target {
                    // Done blurring out
                    displayLink.isPaused = true
                }
            }
        }
    }
}
