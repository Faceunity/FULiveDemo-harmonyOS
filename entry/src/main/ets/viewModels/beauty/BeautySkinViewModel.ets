import { FULogger, FUNMFileUtil, FUNMRenderKit } from '@faceunity/renderkit_nama'
import { FUBeautySkin, modelValueType } from '../../constants/Constants';
import { BeautySkinModel } from '../../models/beauty/BeautySkinModel'

const skinJsonName = 'beauty/beauty_skin.json';
const sandboxJsonName = 'beauty/v9.0.0/beauty_skin.json';
const sandboxSegmentationName = 'beauty/v9.0.0/beauty_skin_segmentation.txt';

export class BeautySkinViewModel {
  dataArray: BeautySkinModel[] = [];
  skinSegmentationEnabled: boolean = false;

  constructor() {
    let str: string | null = null;
    const sbPath = `${FUNMFileUtil.fileDir}/${sandboxJsonName}`;
    if (FUNMFileUtil.isExist(sbPath)) {
      str = FUNMFileUtil.readTextFormSandBox(sbPath);
    } else {
      str = FUNMFileUtil.readTextFromRawfile(skinJsonName);
    }
    if (str) {
      let maps: Record<string, modelValueType>[] = JSON.parse(str);
      for (const map of maps) {
        const model = new BeautySkinModel(map);
        // 鸿蒙端性能暂不推荐：祛斑痘 / 面部丰盈 强制关闭
        if (model.type === FUBeautySkin.AntiAcneSpot || model.type === FUBeautySkin.FacialPlump) {
          model.currentValue = 0;
        }
        this.dataArray.push(model);
      }
    }

    const segPath = `${FUNMFileUtil.fileDir}/${sandboxSegmentationName}`;
    if (FUNMFileUtil.isExist(segPath)) {
      const segStr = FUNMFileUtil.readTextFormSandBox(segPath);
      this.skinSegmentationEnabled = segStr === '1';
    } else {
      this.skinSegmentationEnabled = false;
    }
  }

  saveSkinDataPersistently() {
    const str = JSON.stringify(this.dataArray);
    FUNMFileUtil.writeFileToSandBox(`${FUNMFileUtil.fileDir}/${sandboxJsonName}`, str);
    FUNMFileUtil.writeFileToSandBox(
      `${FUNMFileUtil.fileDir}/${sandboxSegmentationName}`,
      this.skinSegmentationEnabled ? '1' : '0'
    );
  }

  static deleteSkinDataPersistently() {
    FUNMFileUtil.clearSandBoxFile(`${FUNMFileUtil.fileDir}/${sandboxJsonName}`);
    FUNMFileUtil.clearSandBoxFile(`${FUNMFileUtil.fileDir}/${sandboxSegmentationName}`);
  }

  /// 设置单项美肤值
  /// @param value 当前选中单项的值
  setSkinValue(model: BeautySkinModel, value: number) {
    model.currentValue = value * model.ratio;
    this.setValue(model.currentValue, model.type);
  }

  /// 设置当前所有美肤值
  setAllSkinValues() {
    for (const model of this.dataArray) {
      this.setValue(model.currentValue, model.type);
    }
    this.applySkinSegmentation();
  }

  /// 恢复所有美肤值为默认
  recoverAllSkinValuesToDefault() {
    for (const model of this.dataArray) {
      model.currentValue = model.defaultValue;
      this.setValue(model.currentValue, model.type);
    }
    this.setSkinSegmentationEnabled(false);
  }

  setSkinSegmentationEnabled(enabled: boolean) {
    this.skinSegmentationEnabled = enabled;
    this.applySkinSegmentation();
  }

  private applySkinSegmentation() {
    const beauty = FUNMRenderKit.sharedInstance().beauty;
    if (beauty === undefined) {
      FULogger.error('The beauty of FUNMRenderKit is undefined');
      return;
    }
    beauty.enableSkinSegmentation = this.skinSegmentationEnabled;
  }

  private setValue(value: number, type: FUBeautySkin): void {
    const beauty = FUNMRenderKit.sharedInstance().beauty;
    if (beauty === undefined) {
      FULogger.error('The beauty of FUNMRenderKit is undefined');
      return;
    }

    switch (type) {
      case FUBeautySkin.BlurLevel:
        beauty.blurLevel = value;
        break;
      case FUBeautySkin.ColorLevel:
        beauty.colorLevel = value;
        break;
      case FUBeautySkin.RedLevel:
        beauty.redLevel = value;
        break;
      case FUBeautySkin.Sharpen:
        beauty.sharpen = value;
        break;
      case FUBeautySkin.FaceThreed:
        beauty.faceThreed = value;
        break;
      case FUBeautySkin.EyeBright:
        beauty.eyeBright = value;
        break;
      case FUBeautySkin.ToothWhiten:
        beauty.toothWhiten = value;
        break;
      case FUBeautySkin.RemovePouchStrength:
        beauty.removePouchStrength = value;
        break;
      case FUBeautySkin.RemoveNasolabialFoldsStrength:
        beauty.removeNasolabialFoldsStrength = value;
        break;
      case FUBeautySkin.AntiAcneSpot:
        // 鸿蒙端暂不推荐，强制关闭
        beauty.antiAcneSpot = 0;
        break;
      case FUBeautySkin.Clarity:
        beauty.clarity = value;
        break;
      case FUBeautySkin.BodyBlurLevel:
        // body_blur_level: 0.0-6.0
        beauty.setParamForName('body_blur_level', value);
        break;
      case FUBeautySkin.FacialPlump:
        // 鸿蒙端暂不推荐，强制关闭
        beauty.setParamForName('facial_plump', 0);
        break;
    }
  }
}
