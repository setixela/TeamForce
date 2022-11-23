//
//  ImagePickerViewModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 31.08.2022.
//

import ReactiveWorks
import UIKit

struct ImagePickerEvents: InitProtocol {
   var presentOn: UIViewController??
   var didCancel: Void?
   var didImagePicked: UIImage?
   var didImagePickingError: Void?
   var didImageCropped: UIImage?
}

final class ImagePickerViewModel: BaseModel, Eventable {
   typealias Events = ImagePickerEvents
   var events = EventsStore()

   private lazy var picker = UIImagePickerController()

   override func start() {
      picker.delegate = self

      on(\.presentOn) { [weak self] vc in
         guard let picker = self?.picker else { return }
         
         let photoLibraryAction = UIAlertAction(title: "Выбрать  фото", style: .default) {
            (action) in
            picker.sourceType = .photoLibrary
            vc?.present(picker, animated: true)
         }
         
         let cameraAction = UIAlertAction(title: "Сделать снимок", style: .default) {
            (action) in
            picker.sourceType = .camera
            vc?.present(picker, animated: true)
         }
         
         let cancelAction = UIAlertAction(title: "Отменить", style: .cancel, handler: nil)
         
         let dialogMessage = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
         
         dialogMessage.addAction(photoLibraryAction)
         dialogMessage.addAction(cameraAction)
         dialogMessage.addAction(cancelAction)
         
         if let rootVC = UIApplication.shared.keyWindow?.rootViewController?.presentedViewController {
            rootVC.present(dialogMessage, animated: true, completion: nil)
         } else {
            UIApplication.shared.keyWindow?.rootViewController?.present(dialogMessage, animated: true, completion: nil)
         }
         
         vc?.view.endEditing(true)
      }
   }
   
   func allowsEditing(_ value: Bool) {
      picker.allowsEditing = value
   }
}


extension ImagePickerViewModel: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
      picker.dismiss(animated: true)
      send(\.didCancel)
   }

   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
      picker.dismiss(animated: true)

      guard let image = info[.originalImage] as? UIImage else {
         send(\.didImagePickingError)
         return
      }

      send(\.didImagePicked, image)
      
      if picker.allowsEditing == true {
         guard let croppedImage = info[.editedImage] as? UIImage else {
            send(\.didImagePickingError)
            return
         }
         send(\.didImageCropped, croppedImage)
      }
   }
}

final class ImagePickerScene<Asset: AssetProtocol>: BaseSceneModel<
   DefaultVCModel,
   ViewModel,
   Asset,
   Void
>, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   let picker = UIImagePickerController()

   override func start() {
      if UIImagePickerController.isSourceTypeAvailable(.camera) {
         picker.sourceType = .camera
      } else {
         picker.sourceType = .photoLibrary
      }
      picker.delegate = self
      picker.modalPresentationStyle = .fullScreen
      vcModel?.present(picker, animated: false, completion: nil)
   }

   func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
      picker.dismiss(animated: false)
      vcModel?.dismiss(animated: false)
   }

   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
      picker.dismiss(animated: false)
      vcModel?.dismiss(animated: false)
   }
}

//
final class ImagePickerVCModel: UIImagePickerController, VCModelProtocol, Eventable {
   var currentBarStyle: UIBarStyle?
   var currentBarTintColor: UIColor?
   var currentTitleColor: UIColor?
   var currentBarTranslucent: Bool?
   var currentBarBackColor: UIColor?
   var currentTitleAlpha: CGFloat?
   var currentStatusBarStyle: UIStatusBarStyle?

   var events = EventsStore()

   public let sceneModel: SceneModelProtocol

   public lazy var baseView: UIView = sceneModel.makeMainView()

   public required init(sceneModel: SceneModelProtocol) {
      self.sceneModel = sceneModel

      super.init(nibName: nil, bundle: nil)

      if UIImagePickerController.isSourceTypeAvailable(.camera) {
         sourceType = .camera
      } else {
         sourceType = .photoLibrary
      }

      allowsEditing = false
   }

   override public func loadView() {
      view = baseView
   }

   @available(*, unavailable)
   public required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
}
