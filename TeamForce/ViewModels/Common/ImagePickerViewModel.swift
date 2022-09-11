//
//  ImagePickerViewModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 31.08.2022.
//

import ReactiveWorks
import UIKit

struct ImagePickerEvents: InitProtocol {
   var presentOn: Event<UIViewController?>?
   var didCancel: Event<Void>?
   var didImagePicked: Event<UIImage>?
   var didImagePickingError: Event<Void>?
}

final class ImagePickerViewModel: BaseModel, Communicable {
   var events = ImagePickerEvents()

   private lazy var picker = UIImagePickerController()

   override func start() {
      picker.delegate = self

      onEvent(\.presentOn) { [weak self] in
         guard let picker = self?.picker else { return }

         $0?.present(picker, animated: true)
      }
   }
}

extension ImagePickerViewModel: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
      picker.dismiss(animated: true)
      sendEvent(\.didCancel)
   }

   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
      picker.dismiss(animated: true)

      guard let image = info[.originalImage] as? UIImage else {
         sendEvent(\.didImagePickingError)
         return
      }

      sendEvent(\.didImagePicked, image)
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
final class ImagePickerVCModel: UIImagePickerController, VCModelProtocol, Communicable {
   var events = VCEvent()

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
