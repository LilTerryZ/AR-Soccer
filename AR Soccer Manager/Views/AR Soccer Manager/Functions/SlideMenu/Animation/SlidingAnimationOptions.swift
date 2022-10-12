import UIKit

public struct SlidingAnimationOptions: OptionSet {

    public let rawValue: Int
    public var animator: SlidingAnimatorProtocol?
	public var tag: Int?

    public static let slidingMenu = SlidingAnimationOptions(rawValue: 1 << 1)
	public static let fixedMenu = SlidingAnimationOptions(rawValue: 1 << 2)
	public static let content = SlidingAnimationOptions(rawValue: 1 << 3)
    public static let blurBackground = SlidingAnimationOptions(rawValue: 1 << 4)
    public static let menuShadow = SlidingAnimationOptions(rawValue: 1 << 5)
	public static let contentShadow = SlidingAnimationOptions(rawValue: 1 << 6)
    public static let dimmedBackground = SlidingAnimationOptions(rawValue: 1 << 7)

	internal static var customOptions = [SlidingAnimationOptions]()

	public static func custom(_ animator: SlidingAnimatorProtocol, tag: Int) -> SlidingAnimationOptions {
		if let index = customOptions.firstIndex(where: {$0.tag == tag}) {
			customOptions.remove(at: index)
		}
		var custom = SlidingAnimationOptions(rawValue: 1 << (7 + customOptions.count))
        custom.animator = animator
		custom.tag = tag
		customOptions.append(custom)
        return custom
    }
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}
