import UIKit
import ReactiveWorks

enum BadgeState {
    case `default`
    case error
}

class BadgeModel<Asset: AssetProtocol>: BaseViewModel<StackViewExtended>, Assetable {

    internal var textFieldModel = TextFieldModel()
       .set(.padding(.init(top: 16, left: 16, bottom: 16, right: 16)))
       .set(.placeholder("Placeholder"))
       .set(.backColor(UIColor.clear))
       .set(.borderColor(.lightGray.withAlphaComponent(0.4)))
       .set(.borderWidth(1.0))

    internal let titleLabel = LabelModel()
        .set(.text("Title label"))
        .set(Design.state.label.caption)
        .set(.hidden(true))

    internal let errorLabel = LabelModel()
        .set(.text("Error label"))
        .set(Design.state.label.caption)
        .set(.hidden(true))

    override func start() {
        set(.distribution(.fill))
        set(.alignment(.fill))
        set(.axis(.vertical))
        set(.arrangedModels([
           titleLabel,
           textFieldModel,
           errorLabel
        ]))

        textFieldModel
          .on(\.didTap) {_ in 
               self.titleLabel.set(.hidden(false))
           }
    }

    func setLabels(title: String, placeholder: String, error: String) {
        textFieldModel.set(.placeholder(placeholder))
        titleLabel.set(.text(title))
        errorLabel.set(.text(error))
    }

    func changeState(to badgeState: BadgeState) {
        switch badgeState {
        case .default:
            errorLabel
                .set(.hidden(true))
            titleLabel
                .set(.textColor(.black))
            textFieldModel
                .set(.borderColor(.lightGray.withAlphaComponent(0.4)))
        case .error:
            errorLabel
                .set(.hidden(false))
                .set(.textColor(Design.color.boundaryError))
            titleLabel
                .set(.textColor(Design.color.boundaryError))
            textFieldModel
                .set(.borderColor(Design.color.boundaryError))
        }
    }

}

extension BadgeModel: Stateable {
   typealias State = StackState
}
