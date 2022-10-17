//
//  HistoryVMs.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 18.08.2022.
//

import ReactiveWorks

final class HistoryCellModel<Design: DSP>:
   Main<ImageViewModel>.Right<TitleSubtitleY<Design>>.Right2<TitleIconY>.Combo,
   Designable
{
   var events: EventsStore = .init()

   required init() {
      super.init(isAutoreleaseView: true)

      setAll { icon, nameStatus, summa in
         icon
            .image(Design.icon.avatarPlaceholder)
            .contentMode(.scaleAspectFill)
            .cornerRadius(48 / 2)
            .size(.square(48))
         nameStatus
            .padLeft(18)
            .alignment(.leading)
            .setAll { username, status in
               username
                  .padBottom(10)
                  .set(Design.state.label.body1)
                  .alignment(.left)
               status
                  .set(Design.state.label.caption)
                  .textColor(Design.color.textInvert)
                  .alignment(.left)
                  .height(Design.params.cornerRadiusSmall * 2)
                  .cornerRadius(Design.params.cornerRadiusSmall)
            }
         summa
            .alignment(.trailing)
            .setAll { sumText, cancelButton in
               sumText
                  .set(Design.state.label.body3)
                  .alignment(.right)
               cancelButton
                  .set(.tapGesturing)
                  .size(.square(25))
                  .hidden(false)
                  .padding(.init(top: 7, left: 6, bottom: -7, right: -6))
               cancelButton.view.on(\.didTap) { [self] in
                  send(\.cancelButtonPressed)
               }
            }
      }
      alignment(.center)
      padding(.init(top: 23, left: 16, bottom: 23, right: 16))
   }
}

extension HistoryCellModel: Eventable {
   struct Events: InitProtocol {
      var cancelButtonPressed: Void?
   }
}
