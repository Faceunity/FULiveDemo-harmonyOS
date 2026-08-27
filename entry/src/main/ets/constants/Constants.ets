
/////////////////////////////////////////////////////
///                  美颜                         ///
/////////////////////////////////////////////////////

// TODO: 待修改
/// 设备性能等级
export enum FUDevicePerformanceLevel {
  Low_1 = -1, // iPhone6、iPhone6Plus及以下机型
  Low = 1, // iPhone6Plus以上和iPhone8以下机型
  High = 2, // iPhone8及以上和iPhoneXR以下机型
  VeryHigh = 3, // iPhoneXR
  Excellent = 4 // iPhoneXR以上机型
}

export enum FUBeautyCategory {
  None = -1,
  Skin = 0, //美肤
  Shape = 1, //美型
  Filter = 2 //滤镜
}

export enum FUBeautySkin {
  BlurLevel = 0,
  ColorLevel,
  RedLevel,
  Sharpen,
  FaceThreed,
  EyeBright,
  ToothWhiten,
  RemovePouchStrength,
  RemoveNasolabialFoldsStrength,
  AntiAcneSpot,
  Clarity,
  BodyBlurLevel, // 全身磨皮，SDK key: body_blur_level，范围 0.0-6.0
  FacialPlump // 面部丰盈，SDK key: facial_plump，范围 0.0-1.0
}

export enum FUBeautyShape {
  CheekThinning = 0,
  CheekV,
  CheekNarrow,
  CheekShort,
  CheekSmall,
  Cheekbones,
  LowerJaw,
  EyeEnlarging,
  EyeCircle,
  Chin,
  Forehead,
  Nose,
  Mouth,
  LipThick,
  EyeHeight,
  Canthus,
  EyeLid,
  EyeSpace,
  EyeRotate,
  LongNose,
  Philtrum,
  Smile,
  BrowHeight,
  BrowSpace,
  BrowThick,
  EyePupil, // 瞳孔大小，SDK key: intensity_eye_pupil，范围 0.0-1.0，双向滑杆
  CustomWarpFaceLift, // 面部提拉，custom_warp_face_lift
  CustomWarpSmallHead, // 小头，custom_warp_small_head
  CustomWarpEyeOutter, // 外眼角，custom_warp_eye_outter
  CustomWarpMouthWidth, // 嘴巴宽度，custom_warp_mouth_width
  CustomWarpNoseAlar // 鼻翼，custom_warp_nose_alar
}

export type modelValueType = string | number | boolean;

export const SELECTCOLOR = '#5EC7FE'

export const BeautyPageName = 'BeautyPage'


/////////////////////////////////////////////////////
///                  图片渲染                         ///
/////////////////////////////////////////////////////

export enum ImageRenderType {
  Beauty,
  Sticker,
  Makeup
}

/////////////////////////////////////////////////////
///                  贴纸                         ///
/////////////////////////////////////////////////////

export const StickerPageName = 'StickerPage'
export const MakeupPageName = 'MakeupPage'