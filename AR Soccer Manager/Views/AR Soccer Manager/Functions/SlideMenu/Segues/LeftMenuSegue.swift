import UIKit

open class LeftMenuSegue: UIStoryboardSegue {
    override open func perform() {
        guard let sourceVC = self.source as? SlideMenuMainViewController else { return }

        destination.slideMenuMainVC = sourceVC
		destination.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
		sourceVC.setLeftMenu(destination)
		sourceVC.updateLeftMenuFrame()
		sourceVC.view.addSubview(destination.view)		
        destination.view.isHidden = true
    }
}
