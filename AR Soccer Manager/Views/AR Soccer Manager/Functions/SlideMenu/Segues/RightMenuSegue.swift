import UIKit

class RightMenuSegue: UIStoryboardSegue {
    override open func perform() {
        guard let sourceVC = self.source as? SlideMenuMainViewController else { return }

        destination.slideMenuMainVC = sourceVC
		destination.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
		sourceVC.setRightMenu(destination)
		sourceVC.updateRightMenuFrame()
		sourceVC.view.addSubview(destination.view)		
		destination.view.isHidden = true
    }
}
