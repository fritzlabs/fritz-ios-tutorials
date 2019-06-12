import UIKit
import AVFoundation
import Fritz

class ViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    
  @IBOutlet var imageView: UIImageView!
  var maskView: UIImageView!
  var backgroundView: UIImageView!

  let context = CIContext()

  /// Scores output from model greater than this value will be set as 1.
  /// Lowering this value will make the mask more intense for lower confidence values.
  var clippingScoresAbove: Double { return 0.6 }
  
  /// Values lower than this value will not appear in the mask.
  var zeroingScoresBelow: Double { return 0.4 }

  private lazy var visionModel = FritzVisionPetSegmentationModel()

  override func viewDidLoad() {
    super.viewDidLoad()
    openPhotoLibrary()
    backgroundView = UIImageView(frame: view.bounds)
    backgroundView.backgroundColor = .red
    view.addSubview(backgroundView)

    imageView = UIImageView(frame: view.bounds)
    imageView.contentMode = .scaleAspectFit
    view.addSubview(imageView)
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  func openPhotoLibrary() {
    if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
      let imagePicker = UIImagePickerController()
      imagePicker.delegate = self
      imagePicker.sourceType = .photoLibrary
      imagePicker.allowsEditing = true
      self.present(imagePicker, animated: true, completion: nil)
    }
  }
  
  @objc func imagePickerController(_ picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
    self.dismiss(animated: true, completion: { () -> Void in
    })
    createSticker(image)
  }


  /// Remove background of input image based on an alpha mask.
  ///
  /// - Parameters:
  ///   - image: Image to mask
  ///   - mask: Input mask.  Reduces pixel opacity by mask alpha value. For instance
  ///       an alpha value of 255 will be completely opaque, 0 will be completely transparent
  ///       and a value of 125 will be partially transparent.
  /// - Returns: Image mask with background removed.
  func removeBackground(of image: UIImage, withMask mask: UIImage) -> UIImage? {
    guard let imageCG = image.cgImage, let maskCG = mask.cgImage else { return nil }
    let imageCI = CIImage(cgImage: imageCG)
    let maskCI = CIImage(cgImage: maskCG)

    let empty = CIImage.empty()

    guard let filter = CIFilter(name: "CIBlendWithAlphaMask") else { return nil }
    filter.setValue(imageCI, forKey: "inputImage")
    filter.setValue(maskCI, forKey: "inputMaskImage")
    filter.setValue(empty, forKey: "inputBackgroundImage")

    guard let maskedImage = context.createCGImage(filter.outputImage!, from: maskCI.extent) else {
      return nil
    }

    return UIImage(cgImage: maskedImage)
  }

  func createSticker(_ image: UIImage) {
    let fritzImage = FritzVisionImage(image: image)
    guard let result = try? visionModel.predict(fritzImage),
      let mask = result.buildSingleClassMask(
        forClass: FritzVisionPetClass.pet,
        clippingScoresAbove: clippingScoresAbove,
        zeroingScoresBelow: zeroingScoresBelow
      )
      else { return }

    guard let petSticker = removeBackground(of: image, withMask: mask) else { return }

    DispatchQueue.main.async {
      self.imageView.image = petSticker
    }
  }
}
