

import Foundation
import UIKit

public protocol PhotoEditorDelegate {
    func doneEditing(image: UIImage)
    func canceledEditing()
    func closePage()
}

protocol StickersViewControllerDelegate {
    func didSelectView(view: UIView)
    func didSelectImage(image: UIImage)
    func stickersViewDidDisappear()
}

protocol ColorDelegate {
    func didSelectColor(color: UIColor, font: String)
}

protocol FontDelegate {
    func didSelectFont(font: String)
    func removeLastTextView(font: String)
}

protocol EditorDelegate: class {
    func savedToLibrary(message: String)
}
