//
//import Foundation
//import Lottie
//
//final class LottieHelper {
//    
//    static var animationView: AnimationView?
//
//    static func createAnimationView(animationName: String, loop: Bool) -> AnimationView {
//        let animationView = AnimationView(name: animationName)
//        animationView.contentMode = .scaleAspectFit
//        if !loop {
//            animationView.loopMode = .playOnce
//        } else {
//            animationView.loopMode = .loop
//        }
//        return animationView
//    }
//    
//    static func setAnimation(view: UIView, name: String, loop: Bool) {
//        if let animateTag = view.viewWithTag(100) {
//            animateTag.removeFromSuperview()
//        }
//        animationView = self.createAnimationView(animationName: name, loop: loop)
//        animationView?.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
//        animationView?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
//        animationView?.tag = 100
//        view.insertSubview(animationView!, at: 0)
//        animationView?.play()
//        animationView?.backgroundBehavior = .pauseAndRestore
//    }
//}
