@Component
export struct FUBackButton {
  @Consume('pathInfos') pathInfos: NavPathStack
  onBackAction: (() => void) | undefined = undefined

  build() {
    Stack() {
      Image($rawfile('common/style_customizing_back@2x.png'))
        .size({ width: 20, height: 20 })
        .objectFit(ImageFit.Contain)
    }
    .size({ width: 44, height: 44 })
    .margin({ left: 10 })
    .onClick(() => {
      this.onBackAction ? this.onBackAction() : this.pathInfos.pop()
    })
  }
}

@Component
export struct FUBackButtonRow {
  onBackAction: (() => void) | undefined = undefined

  build() {
    Row() {
      FUBackButton({
        onBackAction: this.onBackAction
      })
    }
    .justifyContent(FlexAlign.Start)
    .alignItems(VerticalAlign.Center)
    .width('100%')
    .height(44)
  }
}