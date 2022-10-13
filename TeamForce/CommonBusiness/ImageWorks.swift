//
//  ImageWorks.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 13.10.2022.
//

import ReactiveWorks
import UIKit

protocol ImageStorage: InitClassProtocol {
   var images: [UIImage] { get set }
}

protocol ImageWorks: TempStorage where Self.Temp: ImageStorage {
   var addImage: Work<UIImage, UIImage> { get }
   var removeImage: Work<UIImage, Void> { get }
}

extension ImageWorks {
   var addImage: Work<UIImage, UIImage> { .init { work in
      Self.store.images.append(work.unsafeInput)
      work.success(result: work.unsafeInput)
   } }

   var removeImage: Work<UIImage, Void> { .init { work in
      Self.store.images = Self.store.images.filter { $0 !== work.unsafeInput }
      work.success()
   } }
}
