import UIKit

open class ContentSegue: UIStoryboardSegue {
    override open func perform() {
        var mainVC:SlideMenuMainViewController?
        if let sourceVC = self.source as? SlideMenuMainViewController {
            mainVC = sourceVC
        } else if let sourceVC = self.source.slideMenuMainVC {
            mainVC = sourceVC
			mainVC?.prepare(for: self, sender: self)
        }
        guard let slideMenuMainVC = mainVC else { return }
        
        slideMenuMainVC.children.forEach({$0.removeFromParent()})
		slideMenuMainVC.contentView.subviews.filter({$0 != slideMenuMainVC.overlayView}).forEach({$0.removeFromSuperview()})
        slideMenuMainVC.children.forEach({$0.didMove(toParent: nil)})
        
        destination.slideMenuMainVC = slideMenuMainVC
        slideMenuMainVC.setContentVC(destination)
        
        slideMenuMainVC.addChild(destination)
        slideMenuMainVC.contentView.addSubview(destination.view)
        destination.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        destination.view.frame = slideMenuMainVC.contentView.bounds
        destination.didMove(toParent: slideMenuMainVC)

		slideMenuMainVC.contentView.bringSubviewToFront(slideMenuMainVC.overlayView)
		if slideMenuMainVC.menuState == .leftOpened {
			slideMenuMainVC.hideLeftMenu(animated: UIView.areAnimationsEnabled)
		} else if slideMenuMainVC.menuState == .rightOpened {
			slideMenuMainVC.hideRightMenu(animated: UIView.areAnimationsEnabled)
		}
    }
}
