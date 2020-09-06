//
//  EditorVC.swift
//  Eitor
//
//  Created by Mert Ozkaya on 22.08.2020.
//  Copyright © 2020 Eitor. All rights reserved.
//

import UIKit
import SVProgressHUD

class EditorVC: UIViewController, PhotoEditorMenuDelegate, EditorDelegate {
    func savedToLibrary(message: String) {
        print(message)
        
        if let controller = storyboard?.instantiateViewController(withIdentifier: "ShareWarningModal") as? ShareWarningModal {
            
            Helpers.delay(0.5) {
                controller.warningType = "success"
                controller.warningTitle = message
                
                let nav = BaseNavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .overFullScreen
                nav.modalTransitionStyle   = .crossDissolve
                self.present(nav, animated: true, completion: nil)
            }
        }
        
        
//        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
//        }))
//
//        self.present(alert, animated: true, completion: nil)
    }
    
    
    private lazy var leftButton: UIBarButtonItem = {
        let image = UIImage(named: "backArrow")
      let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(leftMenuItemSelected))
      button.tintColor = .white
      return button
    }()

    let TAG = "EditorVC"

    let sceneAnimationView = UIView(frame: CGRect(x: (ScreenSize.SCREEN_WIDTH / 2)  - (100 / 2),
    y: (ScreenSize.SCREEN_HEIGHT / 2) - (100 / 2),
    width: 100, height: 100))
    
    //To hold the image
    @IBOutlet var showImageView: UIImageView!
    public var originalImage: UIImage?
    public var tempImage: UIImage?

    @IBOutlet weak var frameView: UIView!
    @IBOutlet weak var canvasImageView: UIImageView!

     
     @IBOutlet weak var doneButton: UIButton!
     @IBOutlet weak var deleteView: UIView!
     @IBOutlet weak var colorsCollectionView: UICollectionView!
     @IBOutlet weak var colorPickerView: UIView!
     @IBOutlet weak var colorPickerViewBottomConstraint: NSLayoutConstraint!
     
    var control = Control.none
    public var stickers : [UIImage] = []
    public var colors : [UIColor] = PhotoEditorColors.colors
     
    public var cartoonURL: String?
    
    var photoEditorDelegate: PhotoEditorDelegate?
    var colorsCollectionViewDelegate: ColorsCollectionViewDelegate!
    var fontCollectionDelegate: FontsCollectionViewDelegate!
    
    //TODO
//    var myPackageInfoDelegate: MyPackageInfoDelegate!
//    var camGalleryDelegate: CamGalleryDelegate?
//    var editAndShareDelegate: EditAndShareDelegate?
    
     
    var stickersVCIsVisible = false
    var biseyinRengi: UIColor = UIColor.black
    var textColor: UIColor = UIColor.white
    var isDrawing: Bool = false
    var lastPoint: CGPoint!
    var isSwiped = false
    
    var clearLines = [DrawingModel]()
    var removedClearLines = [DrawingModel]()
    var indexClearDraw = 0
    var ratio: CGFloat?
    
    var lastPanPoint: CGPoint?
    var lastTextViewTransform: CGAffineTransform?
    var lastTextViewTransCenter: CGPoint?
    var lastTextViewFont:UIFont?
    var activeTextView: UITextView?
    var imageViewToPan: UIImageView?
    var isTyping: Bool = false
    
    // elle çizim - draw
    var drawLines = [DrawingModel]()
    var removedDrawLines = [DrawingModel]()
    var indexDraw = 0
    var drawSize: Float = 2.0
    var drawColor: UIColor = .red
    
    var stickersViewController: StickersViewController!
    
    /** ---------------------------------------------------------------------------- **/
    //Menu properties
    let clickImages = ["image-line", "brush-line","brush-line", "brush-line"]
    let mainText = [String.localize(word: "photograph"), String.localize(word: "eraser"), String.localize(word: "editText"), String.localize(word: "crop")]


    @IBOutlet weak var mainMenuCollectionview: UICollectionView!
    @IBOutlet weak var subMenuCollectionView: UICollectionView!
    @IBOutlet weak var fontsCollectionView: UICollectionView!
    var emojisCollectioView: UICollectionView!

    
    //ImageSegmentation
    // DeeplabV3 model from https://developer.apple.com/machine-learning/models/
    let context = CIContext(options: nil)
    var selectedIndexPathRow: Int = 0
    var eraserSize: Float = 2.0
    var textModels = [TextEditModel]()
    var textFont: String = "Muli"
    var fonts = [String]()
    var textViewTag = 0
    var isEraser = false
    var sticker_id: Int?
    var package_id: Int? = nil
    var mode = "Default" //default, fromDeleteAndUpdate
    //Menu selected actions
    var selectedIndex = [true, false, false, false]
    var activeTextEditIndex: Int = 0
    var activeEraserEditIndex: Int? = nil
    
    var style_id: String?
    //TODO-This
//    var cartoonEffects = [Cartoon]()
//    var textPatterns = [TextPattern]()
    
    var cartoonEffects = [Cartoon]()
    var textPatterns = [String]()
    
    var isRotationAndZoom = false
    var touchedView = UIView()
    
    // ------   22.08.2020
    //photografh submenu
    var photographTitles = [String.localize(word: "camera"), String.localize(word: "gallery"), String.localize(word: "selectSticker")]
    var photographImages = [UIImage(named: "editCamera"), UIImage(named: "gallery"),UIImage(named: "selectStickerIcon")]
    
    // eraser submenu
    let eraserSubMenu = [ String.localize(word: "quickEraser"), String.localize(word: "manualEraser"), String.localize(word: "reset")]
    var selectedSubmenuIndex: Int? = nil
    let textSubMenu = [ String.localize(word: "addText"), String.localize(word: "draw")]
    let cropSubMenu = [String.localize(word: "quadraticCrop"), String.localize(word: "looseCrop")]
    let cropIcons = [UIImage(named: "quadraticCrop") , UIImage(named: "manualCrop")]
    let cropItems = ["Kırp", "Temizle", "Sıfırla"]
    //Update this for path line color
    public var cropStrokeColor:UIColor = UIColor.blue

    //Update this for path line width
    public var cropLineWidth:CGFloat = 2.0

    var cropPath = UIBezierPath()
    var cropShapeLayer = CAShapeLayer()
    var cropPoints = [CGPoint]()
    //Get recently cropped image anytime
    var croppedImage: UIImage?
    var isLogEnabled = true
    let fontFamily = UIFont.familyNames
    //Register Custom font before we load XIB
    var lastEdits = [LastEditProcesses]()
    
    public override func loadView() {
        super.loadView()
        registerFont(font: "Muli")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        doneButton.setTitle(String.localize(word: "done"), for: .normal)
        guard let image = self.originalImage else {
            print(TAG,"BIG ERRORRRRRR")
            return
        }
        self.setImageView(image: image)

//        navigationBarStyle()
        setupRightNavigationItem()
        setupLeftNavigationItem()
        
        deleteView.layer.cornerRadius = deleteView.bounds.height / 2
        deleteView.layer.borderWidth = 2.0
        deleteView.layer.borderColor = UIColor.white.cgColor
        deleteView.clipsToBounds = true
        
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
        edgePan.edges = .bottom
        edgePan.delegate = self
        self.view.addGestureRecognizer(edgePan)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow),
                                               name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillChangeFrame(_:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        
        configureCollectionView()
        configureFontCollectionView()
        stickersViewController = StickersViewController(nibName: "StickersViewController", bundle: Bundle(for: StickersViewController.self))
        
//        hideControls()
        
        ////Sonradan Eklenenler
        mainMenuCollectionview.delegate = self
        mainMenuCollectionview.dataSource = self
        mainMenuCollectionview.backgroundColor = UIColor(hexString: "D2D2D2")
        subMenuCollectionView.delegate = self
        subMenuCollectionView.dataSource = self
        
        let editMenuNib = UINib(nibName: "EditMenuOptionCell", bundle: nil)
        mainMenuCollectionview.register(editMenuNib, forCellWithReuseIdentifier: "EditMenuOptionCell")
        
        let photographNib = UINib(nibName: "PhotographEditCell", bundle: nil)
        subMenuCollectionView.register(photographNib, forCellWithReuseIdentifier: "PhotographEditCell")
        
        let eraserSubMenuNib = UINib(nibName: "EditEraserSubMenuCell", bundle: nil)
        subMenuCollectionView.register(eraserSubMenuNib, forCellWithReuseIdentifier: "EditEraserSubMenuCell")
        
        let eraserSizeNib = UINib(nibName: "EraserSizeCell", bundle: nil)
        subMenuCollectionView.register(eraserSizeNib, forCellWithReuseIdentifier: "EraserSizeCell")
        
        let textEditSubMenuNib = UINib(nibName: "TextEditSubMenuCell", bundle: nil)
        subMenuCollectionView.register(textEditSubMenuNib, forCellWithReuseIdentifier: "TextEditSubMenuCell")
        
        let fontPatternNib = UINib(nibName: "FontTypeAndPatternCell", bundle: nil)
        subMenuCollectionView.register(fontPatternNib, forCellWithReuseIdentifier: "FontTypeAndPatternCell")
        
        let colorViewNib = UINib(nibName: "ColorCollectionViewCell", bundle: nil)
        subMenuCollectionView.register(colorViewNib, forCellWithReuseIdentifier: "ColorCollectionViewCell")
        
        let cropViewNib = UINib(nibName: "CropCell", bundle: nil)
        subMenuCollectionView.register(cropViewNib, forCellWithReuseIdentifier: "CropCell")
        
        for i in 0...10 {
            self.stickers.append(UIImage(named: i.description )!)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        print("Ram uyarısı")
//        let alert = UIAlertController(title: String.localize(word: "warning"), message: "Ram uyarısı", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
//
//        }))
//        self.present(alert, animated: true, completion: nil)
        URLCache.shared.removeAllCachedResponses()
        super.didReceiveMemoryWarning()

    }
    
    func navigationBarStyle() {
        self.navigationItem.title = String.localize(word: "edit")
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor(hexString:"000000")
        ]
        self.navigationController?.navigationBar.barTintColor = UIColor(hexString:"000000")
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.imageWithColor(color: .white), for: .default)

//        self.navigationController?.navigationBar.shadowImage = UIImage()
        
    }
    
    //MARK: Right Navigation Item
    func setupRightNavigationItem() {
        let rightBarButtonView = Bundle.main.loadNibNamed("RightBarButtonView", owner: nil, options: nil)?[0] as! RightBarButtonView
    
        rightBarButtonView.cornerRadius = 15
        rightBarButtonView.customButton.setTitle(String.localize(word: "completed"), for: .normal)
        
        rightBarButtonView.customButton.titleLabel?.adjustsFontSizeToFitWidth = true
        rightBarButtonView.customButton.addTarget(self, action: #selector(rightMenuItemSelected(_:)), for: .touchUpInside)
        rightBarButtonView.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
        let rightMenuItem = UIBarButtonItem(customView: rightBarButtonView)
        self.navigationItem.setRightBarButton(rightMenuItem, animated: false)
    }
    
    @objc func rightMenuItemSelected(_ bar: UIBarButtonItem) {
        print("right tap")
//        self.frameView.isHidden = false
        if let controller = storyboard?.instantiateViewController(withIdentifier: "ShareAndSavePopup") as? ShareAndSavePopup {
            controller.image = self.frameView.toImage()

                controller.editorDelegate = self
                let nav = BaseNavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .overFullScreen
                nav.modalTransitionStyle   = .crossDissolve
                self.present(nav, animated: true, completion: nil)
        }

        
    }
    
    //MARK: Left Navigation Item
    func setupLeftNavigationItem() {
        self.navigationItem.leftBarButtonItem = leftButton
    }
    
    @objc func leftMenuItemSelected() {
        self.dismiss(animated: true, completion: nil)
        self.photoEditorDelegate?.closePage()
        
        if mode == "fromDeleteAndUpdate" {
            self.navigationController?.popViewController(animated: true)
        }else {
//            self.dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)
        }
    }

    func configureCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 36, height: 36)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 12
        colorsCollectionView.collectionViewLayout = layout
        colorsCollectionViewDelegate = ColorsCollectionViewDelegate()
        colorsCollectionViewDelegate.colorDelegate = self
        if !colors.isEmpty {
//            print("Dolu")
            colorsCollectionViewDelegate.colors = colors
        }
        colorsCollectionView.delegate = colorsCollectionViewDelegate
        colorsCollectionView.dataSource = colorsCollectionViewDelegate
        
        colorsCollectionView.register(
            UINib(nibName: "ColorCollectionViewCell", bundle: Bundle(for: ColorCollectionViewCell.self)),
            forCellWithReuseIdentifier: "ColorCollectionViewCell")
    }
    
    func configureFontCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 50)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 12
        
        fontsCollectionView.collectionViewLayout = layout
        fontCollectionDelegate = FontsCollectionViewDelegate()
        fontCollectionDelegate.fontDelegate = self
        if !fonts.isEmpty {
            fontCollectionDelegate.fonts = fonts
        }
        fontsCollectionView.delegate = fontCollectionDelegate
        fontsCollectionView.dataSource = fontCollectionDelegate
        
        fontsCollectionView.register(
            UINib(nibName: "FontTypeAndPatternCell", bundle: Bundle(for: FontTypeAndPatternCell.self)),
            forCellWithReuseIdentifier: "FontTypeAndPatternCell")
    }
    
    func setImageView(image: UIImage) {
        
        showImageView.backgroundColor = .clear
        showImageView.contentMode = .scaleAspectFit
        
        let newImge = image
        var resizedImage = UIImage()
        
        DispatchQueue.main.async(){
                        
            if newImge.size.width > self.frameView.frame.size.width {
                resizedImage = newImge.myResized(to: CGSize(width: self.frameView.frame.size.width, height: self.frameView.frame.size.height))!
                self.showImageView.image = resizedImage
                self.tempImage = resizedImage

            }else if newImge.size.height > self.frameView.frame.size.height {
                resizedImage = newImge.myResized(to: CGSize(width: self.frameView.frame.size.height, height: self.frameView.frame.size.height))!
            
                self.showImageView.image = resizedImage
                self.tempImage = resizedImage

            }else {
                self.showImageView.frame.size.width = newImge.size.width
                self.showImageView.frame.size.height = newImge.size.height
                self.showImageView.image = newImge
                self.tempImage = newImge
            }
        }
        self.canvasImageView.isHidden = false
    }
    
    func addNewPathToImage(){
        cropShapeLayer.path = cropPath.cgPath
        cropShapeLayer.strokeColor = cropStrokeColor.cgColor
        cropShapeLayer.lineDashPattern = [4,4]
        cropShapeLayer.fillColor = UIColor.clear.cgColor
        cropShapeLayer.lineWidth = cropLineWidth
        self.showImageView.layer.addSublayer(cropShapeLayer)
    }
    
}


// MARK: CollectionView Configuration
extension EditorVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == mainMenuCollectionview {
            return mainText.count
        }else {
            if selectedIndexPathRow == 0 {
                return photographTitles.count
            }else if selectedIndexPathRow == 1 {
                if isEraser == false {
                    return eraserSubMenu.count
                }else {
                    return 1
                }
            }else if selectedIndexPathRow == 2{
                switch control {
                case .none:
                    return textSubMenu.count
                case .text:
                    return fontFamily.count
                case .draw:
                    return colors.count
                default:
                    return 1
                }
            }else if selectedIndexPathRow == 3 {
                if control == .manualCrop {
                    return cropItems.count
                }
                return cropSubMenu.count
            } else {
                return 1
            }
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == mainMenuCollectionview {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EditMenuOptionCell", for: indexPath) as? EditMenuOptionCell else {
                            fatalError("EditMenuOptionCell Not Found!")
                    }
//            cell.setupUI(text: mainText[indexPath.row], image: UIImage(named: clickImages[indexPath.row])!)
//
            cell.backgroundColor = UIColor(hexString: "171717")
            cell.titleLabel.text = mainText[indexPath.row]
            cell.iconImageView.image = UIImage(named: clickImages[indexPath.row])
            
            if selectedIndexPathRow == indexPath.row {
                cell.view.backgroundColor = .white
                cell.titleLabel.textColor = UIColor(hexString: "171717")
                cell.view.backgroundColor = .white
                cell.iconImageView.tintColor = UIColor(hexString: "171717")
            }else{
                cell.view.backgroundColor = UIColor(hexString: "171717")
                cell.titleLabel.textColor = .white
                cell.view.backgroundColor = UIColor(hexString: "171717")
                cell.iconImageView.tintColor = .white
            }
            
            return cell
            
        }
        else {
            if selectedIndexPathRow == 0 {
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotographEditCell", for: indexPath) as? PhotographEditCell else {
                    fatalError("PhotographEditCell Not Found!")
                }
                let templateImage = self.photographImages[indexPath.row]!.withRenderingMode(.alwaysTemplate)
                cell.imageView.image = templateImage
                cell.imageView.tintColor = .white
                
                cell.titleLabel.text = photographTitles[indexPath.row]
                cell.titleLabel.textColor = .white
                return cell
            }
            else if selectedIndexPathRow == 1 {
                
                if selectedSubmenuIndex == 1 && isEraser == true{
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EraserSizeCell", for: indexPath) as? EraserSizeCell else {
                        fatalError("EraserSizeCell Not Found!")
                    }
                    cell.mainDelegate = self
                    return cell
                }else {
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EditEraserSubMenuCell", for: indexPath) as? EditEraserSubMenuCell else {
                        fatalError("PhotographEditCell Not Found!")
                    }
                    
                    cell.subMenuTitle.text = eraserSubMenu[indexPath.row]
                    cell.borderWidth = 1
                    cell.borderColor = UIColor(hexString: "979797")
                    cell.cornerRadius = cell.frame.size.height / 2
                    
                    return cell
                }
                
            }
            else if selectedIndexPathRow == 2 {
                
                if control == .none {
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextEditSubMenuCell", for: indexPath) as? TextEditSubMenuCell else {
                       fatalError("TextEditSubMenuCell Not Found!")
                   }
                    cell.textEditLabel.text = textSubMenu[indexPath.row]
                    return cell
                }else if control == .text {
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FontTypeAndPatternCell", for: indexPath) as? FontTypeAndPatternCell else {
                        fatalError("FontTypeAndPatternCell Not Found!")
                    }
                    cell.fontAndPatternLabel.textColor = .white
                    cell.fontAndPatternLabel.cornerRadius = cell.frame.height / 2
                    cell.fontAndPatternLabel.text = "Abc"
                    cell.fontAndPatternLabel.font = UIFont(name: fontFamily[indexPath.row], size: 16)
                    
                    return cell
                }else if control == .draw{
                    let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCollectionViewCell", for: indexPath) as! ColorCollectionViewCell
                    cell.colorView.backgroundColor = colors[indexPath.item]
                    return cell
                }else {
                    return UICollectionViewCell()
                }
                
            }
            else {

                
                if control == .manualCrop {
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FontTypeAndPatternCell", for: indexPath) as? FontTypeAndPatternCell else {
                        fatalError("FontTypeAndPatternCell Not Found!")
                    }
                    cell.fontAndPatternLabel.textColor = .white
                    cell.fontAndPatternLabel.cornerRadius = cell.frame.height / 2
                    cell.fontAndPatternLabel.text = cropItems[indexPath.row]
                    return cell
                    
                }else {
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CropCell", for: indexPath) as? CropCell else {
                        fatalError("CropCell Not Found!")
                    }
                    
                    cell.iconImageView.image = cropIcons[indexPath.row]
                    cell.iconImageView.tintColor = .white
                    cell.textLabel.text = cropSubMenu[indexPath.row]
                    
                    return cell
                }
                
                
            }
            
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EditMenuCollectionCell", for: indexPath) as? EditMenuCollectionCell else {
//                            fatalError("EditMenuCollectionCell Not Found!")
//            }
//            cell.menuDelegate = self
//            cell.setup(indexPath.section)
//            cell.selectedIndex = self.selectedIndexPathRow
//            cell.activeTextEditIndex = self.activeTextEditIndex
//            cell.activeEraserIndex = self.activeEraserEditIndex
//            cell.eraserSize = self.eraserSize
//
//
//            if selectedIndexPathRow == 2 {
//                cell.textPatterns = self.textPatterns
//            }
//
//            if selectedIndexPathRow == 2 && indexPath.section == 0 {
//                cell.collectionView.backgroundColor = UIColor(hexString:"F7F7F7")
//                cell.collectionView.cornerRadius = 8
//                cell.clipsToBounds = true
//            }else {
//                cell.collectionView.backgroundColor = .white
//                cell.collectionView.cornerRadius = 0
//                cell.clipsToBounds = false
//            }
//
//            if selectedIndexPathRow == 3 {
//                cell.cartoonEffects = self.cartoonEffects
//            }

        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == mainMenuCollectionview  {
            self.selectedIndexPathRow = indexPath.row
            
            doneTapped()
            
            if selectedIndexPathRow == 2 {
                if textPatterns.count == 0 {
                    getTextPatterns()
                }
                mainMenuCollectionview.reloadData()
                subMenuCollectionView.reloadData()
            }
            
            if selectedIndexPathRow == 3 {
//                print(TAG,"didSelect:", cartoonEffects.count)
                mainMenuCollectionview.reloadData()
                subMenuCollectionView.reloadData()
//                getCartoonEffectList()
            }else {
                subMenuCollectionView.reloadData()
                mainMenuCollectionview.reloadData()
            }
        }else {
            if selectedIndexPathRow == 0 {
                selectedSubmenuIndex = indexPath.row
                
                if indexPath.row == 0 { //openCamera
                    openCamera()
                }else if indexPath.row == 1 { //openGallery
                    openGallery()
                }else { // openSticker Scene
                    addSticker()
                }
                
            }else if selectedIndexPathRow == 1 {
                
                if isEraser == false {
                    selectedSubmenuIndex = indexPath.row

                    if indexPath.row == 0 { //sihirli silgi
                        SVProgressHUD.show()
                        if #available(iOS 12.0, *) {
                            magicEraser()
                        }else {
                            SVProgressHUD.dismiss()
                            magicEraserAlert()
                            print("Bu özellik ios 12 sürüm ve sonrasında kullanılabilir")
                        }
                    }else if indexPath.row == 1 { //manual silgi
                       manualEraser()
                       subMenuCollectionView.reloadData()
                   }else { // sıfırla
                       resetImageView()
                   }
                }
            }else if selectedIndexPathRow == 2 {
                if control == .none {
                    if indexPath.row == 0{
                        control = .text
//                        clickedToTextEdit(text: "", font: fontFamily[indexPath.row])
                    }else if indexPath.row == 1{
                        draw()
                        control = .draw
                    }else {
                        control = .none
                    }
                }else if control == .text {
                    clickedToTextEdit(text: "", font: fontFamily[indexPath.row])
                }else if control == .draw {
                    drawColor = colors[indexPath.row]
                    print("color indexpath.row:", indexPath.row)
                }
                
            }else if selectedIndexPathRow == 3 {
                if control == .none {
                    if indexPath.row == 0  { // quadratic crop
                        self.canvasImageView.isHidden = true
                        quadraticCrop(image: self.showImageView.toImage())
                    }else if indexPath.row == 1 { //manual crop
                        control = .manualCrop
                        self.canvasImageView.isHidden = true
                        self.navigationItem.setRightBarButton(nil, animated: false)
                        self.doneButton.isHidden = false
                    }
                }else if control == .quadraticCrop {
                    if let img = self.originalImage {
                        quadraticCrop(image: img)
                    }
                }else if control == .manualCrop {
                    if indexPath.row == 0 {
                        if cropPoints.count > 0 {
                            print("crop Points:", cropPoints.count)
                            self.showImageView.layer.sublayers = nil
                            self.showImageView.layer.mask = nil
                            if let croppedImage =  manualCropImage(ofImageView: self.showImageView, withinPoints: cropPoints) {
                                self.croppedImage = croppedImage
//                                self.showImageView.image = croppedImage
                                self.setImageView(image: croppedImage)
                            }
                        }
                    }else if indexPath.row == 1 {
                        cropPoints.removeAll()
                        cropPath = UIBezierPath()
                        cropShapeLayer = CAShapeLayer()
                        self.showImageView.layer.sublayers = nil
                        self.showImageView.layer.mask = nil
                    
                    }else if indexPath.row == 2 {
                        cropPoints.removeAll()
                        cropPath = UIBezierPath()
                        cropShapeLayer = CAShapeLayer()
                        self.showImageView.layer.sublayers = nil
                        self.showImageView.layer.mask = nil
                        
                        if let img = self.originalImage {
                            if let cropped = self.croppedImage {
                                self.setImageView(image: cropped)
                            }else {
                                self.setImageView(image: img)
                            }
                        }
                    }

                }
            }
            self.view.layoutIfNeeded()
            self.subMenuCollectionView.reloadData()
            print("Submenu")
        }
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if collectionView == mainMenuCollectionview {
            var currentSize = mainText[indexPath.row].size(withAttributes: [
                               NSAttributedString.Key.font: UIFont(name: "Muli-Bold", size: 14)!
                           ])
            currentSize.width = currentSize.width + 48 + 40
            return CGSize(width: currentSize.width, height: self.mainMenuCollectionview.frame.height)
        }else {
            if selectedIndexPathRow == 0 {
                return CGSize(width: (subMenuCollectionView.frame.width - 40) / 3, height: subMenuCollectionView.frame.height - 20)
            }else if selectedIndexPathRow == 1{
                if isEraser == false {
                    return CGSize(width: 200, height: 50)
                }else {
                    return CGSize(width: self.subMenuCollectionView.frame.width - 20, height: 50)
                    
                }
                
            }else if selectedIndexPathRow == 2{ //selectedIndexPathRow == 2
                if control == .none {
                    return CGSize(width: 100, height: 50)
                }else if control == .text {
                     return CGSize(width: 100, height: 50)
                }else if control == .draw {
                    return CGSize(width: 50, height: 50)
                }else {
                    print("control tipi yanlış")
                    return CGSize(width: 0, height:  self.subMenuCollectionView.frame.height)
                }
                
            }else  {
                return CGSize(width: 100, height: 50)
            }
        }
        
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == mainMenuCollectionview {
            return 0
        }else {
            return 10
        }
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        if collectionView == subMenuCollectionView {
            if selectedIndexPathRow == 0 {
                return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            }else if selectedIndexPathRow == 1 {
                    return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            }
            else if selectedIndexPathRow == 2 {
                    return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            } else if selectedIndexPathRow == 3 {
                return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            } else {
                return UIEdgeInsets(top: 18, left: 0, bottom: 18, right:  0)
            }
        }else {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right:  0)
        }

    }
    
}


