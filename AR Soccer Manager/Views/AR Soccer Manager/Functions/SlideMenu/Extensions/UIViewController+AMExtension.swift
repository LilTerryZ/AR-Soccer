import UIKit

fileprivate struct AssociationKeys {
    static var slideMenuMainVCKey = "slideMenuMainVCKey"
}

public extension UIViewController {
    
    weak var slideMenuMainVC: SlideMenuMainViewController? {
        get {
            let vc = objc_getAssociatedObject(self, &AssociationKeys.slideMenuMainVCKey) as? SlideMenuMainViewController
            if vc == nil && parent != nil {
                return parent?.slideMenuMainVC
            }
            return vc
        }
        set {
            objc_setAssociatedObject(self, &AssociationKeys.slideMenuMainVCKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }

    @objc func showLeftMenu(animated: Bool = true, completion handler: (()->Void)? = nil) {
        guard !(self is SlideMenuMainViewController) else { return }
        slideMenuMainVC?.showLeftMenu(animated: animated, completion: handler)
    }

    @objc func hideLeftMenu(animated: Bool = true, completion handler: (()->Void)? = nil) {
        guard !(self is SlideMenuMainViewController) else { return }
        slideMenuMainVC?.hideLeftMenu(animated: animated, completion: handler)
    }

    @objc func showRightMenu(animated: Bool = true, completion handler: (()->Void)? = nil) {
        guard !(self is SlideMenuMainViewController) else { return }
        slideMenuMainVC?.showRightMenu(animated: animated, completion: handler)
    }

    @objc func hideRightMenu(animated: Bool = true, completion handler: (()->Void)? = nil) {
        guard !(self is SlideMenuMainViewController) else { return }
        slideMenuMainVC?.hideRightMenu(animated: animated, completion: handler)
    }
}
