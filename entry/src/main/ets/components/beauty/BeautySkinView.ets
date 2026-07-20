import { FUNMNumberUtil } from '@faceunity/renderkit_nama';
import { promptAction } from '@kit.ArkUI';
import { FUBeautySkin, SELECTCOLOR } from '../../constants/Constants';
import { BeautySkinModel } from '../../models/beauty/BeautySkinModel';
import { BeautyDataService } from '../../service/BeautyDataService';
import { CustomDialogCancelOrConfirm } from '../common/CustomDialog';

/** 鸿蒙端性能暂不推荐的美肤项：置灰，点击仅提示 */
function isSkinFeatureDisabled(type: FUBeautySkin): boolean {
  return type === FUBeautySkin.AntiAcneSpot || type === FUBeautySkin.FacialPlump;
}

@Component
export struct BeautySkinView {
  private dialogController: CustomDialogController = new CustomDialogController({
    alignment: DialogAlignment.Center,
    width: '80%',
    height: '140vp',
    builder: CustomDialogCancelOrConfirm({
      title: '是否将所有参数恢复到\n默认值？',
      confirm: () => {
        this.onAccept()
      },
    }),
  })
  private viewModel = BeautyDataService.sharedInstance().skinViewModel;
  private dataArray: BeautySkinModel[] = this.viewModel.dataArray;
  @State gridCurrentIndex: number = 0;
  @State sliderValue: number =
    this.dataArray[this.gridCurrentIndex].currentValue / this.dataArray[this.gridCurrentIndex].ratio * 100.0;
  @State sliderString: string = this.sliderValue.toString();
  @State needToReset: boolean = true;
  @State showSkinSegmentation: boolean = this.dataArray[this.gridCurrentIndex].type === FUBeautySkin.ColorLevel;
  @State skinSegmentationIndex: number = this.viewModel.skinSegmentationEnabled ? 1 : 0;

  build() {
    Column() {
      Row() {
        if (this.showSkinSegmentation) {
          Row() {
            Text('全局')
              .fontSize(10)
              .fontColor(this.skinSegmentationIndex === 0 ? '#2C2E30' : '#73FFFFFF')
              .textAlign(TextAlign.Center)
              .width('50%')
              .height('100%')
              .backgroundColor(this.skinSegmentationIndex === 0 ? Color.White : Color.Transparent)
              .borderRadius(12)
              .onClick(() => {
                this.skinSegmentationIndex = 0;
                this.viewModel.setSkinSegmentationEnabled(false);
              })
            Text('仅皮肤')
              .fontSize(10)
              .fontColor(this.skinSegmentationIndex === 1 ? '#2C2E30' : '#73FFFFFF')
              .textAlign(TextAlign.Center)
              .width('50%')
              .height('100%')
              .backgroundColor(this.skinSegmentationIndex === 1 ? Color.White : Color.Transparent)
              .borderRadius(12)
              .onClick(() => {
                this.skinSegmentationIndex = 1;
                this.viewModel.setSkinSegmentationEnabled(true);
              })
          }
          .width(80)
          .height(24)
          .border({ width: 1, color: Color.White })
          .borderRadius(12)
          .clip(true)
          .margin({ left: 16, right: 8 })
        }

        Slider({
          value: this.sliderValue,
          min: 0,
          max: 100,
          step: 1,
          style: SliderStyle.OutSet,
          direction: Axis.Horizontal,
          reverse: false
        })
          .width(this.showSkinSegmentation ? 200 : 260)
          .height(40)
          .trackThickness(1)
          .blockSize({ width: 13, height: 13 })
          .blockStyle({ type: SliderBlockType.SHAPE, shape: new Rect({ width: 13, height: 13 }) })
          .blockColor(SELECTCOLOR)// 设置滑块颜色
          .trackColor(Color.White)// 设置滑轨颜色
          .selectedColor(SELECTCOLOR)// 设置滑轨的已滑动颜色
          .showTips(true, this.sliderString)
          .onChange((value: number, mode: SliderChangeMode) => {
            if (!this.needToReset) {
              this.needToReset = true;
            }
            this.sliderValue = value;
            this.sliderString = FUNMNumberUtil.formatNumber(value, 0, true);
            const model = this.dataArray[this.gridCurrentIndex];
            this.viewModel.setSkinValue(model, value / 100.0);
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)

      Row() {
        Image($r('app.media.recover_item'))
          .width(50)
          .height(50)
          .margin({ left: 16 })
          .onClick(() => {
            this.dialogController.open();
          })

        Divider()
          .vertical(true)
          .color(Color.Gray)
          .strokeWidth(1)
          .height(40)
          .margin({ left: 15 })

        Grid() {
          ForEach(this.dataArray, (model: BeautySkinModel, index: number) => {
            GridItemBuilder({
              gridCurrentIndex: this.gridCurrentIndex,
              sliderValue: this.sliderValue,
              sliderString: this.sliderString,
              showSkinSegmentation: this.showSkinSegmentation,
              index: index,
              model: model,
              needToReset: this.needToReset
            })
          }, (model: BeautySkinModel): string => model.name)
        }
        .scrollBar(BarState.Off)
        .rowsTemplate('1fr')
        .margin({ left: 10 })
        .width('75%')
        .height(80)
      }
      .margin({ top: 20 })
      .width('100%')
      .height(40)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#1F1D35')
  }

  private onAccept() {
    this.viewModel.recoverAllSkinValuesToDefault();
    this.skinSegmentationIndex = 0;
    const model = this.dataArray[this.gridCurrentIndex];
    this.sliderValue = model.defaultValue / model.ratio * 100.0;
    if (this.needToReset) {
      this.needToReset = false;
    }
  }
}

@Component
struct GridItemBuilder {
  @Link gridCurrentIndex: number
  @Link sliderValue: number
  @Link sliderString: string
  @Link showSkinSegmentation: boolean
  @Link needToReset: boolean;
  index: number = 0;
  model: BeautySkinModel | undefined = undefined;

  build() {
    GridItem() {
      Column() {
        Image(this.getImageName())
          .width(50)
          .height(50)
          .opacity(this.isDisabled() ? 0.7 : 1)
        Text(this.model?.name)
          .fontColor(this.getTextColor())
          .opacity(this.isDisabled() ? 0.7 : 1)
          .textAlign(TextAlign.Center)
          .fontSize(14)
          .margin({ top: 3 })
      }
    }
    .width(67)
    .height(80)
    .selected(!this.isDisabled() && this.gridCurrentIndex === this.index)
    .onClick(() => {
      if (this.isDisabled()) {
        promptAction.showToast({
          message: `${this.model?.name ?? ''}功能当前设备性能暂不支持`,
          duration: 1500
        });
        return;
      }
      this.gridCurrentIndex = this.index;
      if (this.model) {
        this.sliderValue = this.model.currentValue / this.model.ratio * 100.0;
        this.sliderString = FUNMNumberUtil.formatNumber(this.sliderValue, 0, true);
        this.showSkinSegmentation = this.model.type === FUBeautySkin.ColorLevel;
      }
      if (!this.needToReset) {
        this.needToReset = true;
      }
    })
  }

  private isDisabled(): boolean {
    return this.model !== undefined && isSkinFeatureDisabled(this.model.type);
  }

  private getImageName(): Resource {
    // 置灰项固定未启用态图标
    if (this.isDisabled()) {
      return $r(`app.media.${this.model?.imeName}_0`);
    }

    let imaName = '';
    if (this.gridCurrentIndex === this.index) {
      imaName =
        this.sliderValue * (this.model?.ratio ?? 0) !== 0 ? `${this.model?.imeName}_3` : `${this.model?.imeName}_2`;
    } else {
      imaName =
        this.model?.currentValue !== 0 ? `${this.model?.imeName}_1` : `${this.model?.imeName}_0`;
    }

    return $r(`app.media.${imaName}`);
  }

  private getTextColor(): ResourceColor {
    if (this.isDisabled()) {
      return Color.White;
    }
    return this.gridCurrentIndex === this.index ? SELECTCOLOR : Color.White;
  }
}
