import { Permissions } from '@kit.AbilityKit';
import { display } from '@kit.ArkUI';
import { FUNMCamera, FUNMDisplayView, FULogger, grantPermission } from '@faceunity/renderkit_nama';

const TAG: string = '[CameraPage]';
const xcomponentId: string = 'CameraPageXcomponentId';
const cameraResolution: Size = { width: 1280, height: 720 };

const permissions: Array<Permissions> = [
  'ohos.permission.CAMERA'
];

@Component
export struct CameraPage {
  private camera: FUNMCamera | undefined = undefined;
  private surfaceId: string | undefined = undefined;
  private xController: XComponentController | undefined = undefined;
  private viewPxSize: Size | undefined = undefined;
  private isFrontCamera: boolean = true;
  private isCameraReady: boolean = false;
  private isSwitching: boolean = false;

  async aboutToDisappear() {
    await this.destroyCamera();
  }

  build() {
    Stack({ alignContent: Alignment.TopEnd }) {
      FUNMDisplayView({
        viewId: xcomponentId,
        resolution: this.calculateCoverSurfaceSize(),
        onLoadCallBack: (controller: XComponentController) => {
          this.onDisplayLoaded(controller);
        }
      })
        .width('100%')
        .height('100%')

      Button('切换镜头')
        .fontSize(14)
        .fontColor(Color.White)
        .backgroundColor('#66000000')
        .borderRadius(20)
        .padding({
          left: 16,
          right: 16,
          top: 8,
          bottom: 8
        })
        .margin({ top: 48, right: 16 })
        .onClick(() => {
          this.switchCamera();
        })
    }
    .width('100%')
    .height('100%')
    .layoutWeight(1)
    .backgroundColor(Color.Black)
    .onAreaChange((_: Area, newArea: Area) => {
      this.viewPxSize = {
        width: vp2px(newArea.width as number),
        height: vp2px(newArea.height as number)
      };
      this.updateSurfaceRect();
    })
  }

  private async onDisplayLoaded(controller: XComponentController) {
    this.xController = controller;
    this.updateSurfaceRect();

    const granted = await grantPermission(permissions);
    if (!granted) {
      FULogger.error(TAG, '相机权限申请失败');
      return;
    }

    this.surfaceId = controller.getXComponentSurfaceId();
    if (!this.surfaceId) {
      FULogger.error(TAG, '获取 surfaceId 失败');
      return;
    }

    await this.startCamera();
  }

  private updateSurfaceRect() {
    if (this.xController === undefined) {
      return;
    }
    const size = this.calculateCoverSurfaceSize();
    this.xController.setXComponentSurfaceRect({
      surfaceWidth: size.width,
      surfaceHeight: size.height
    });
  }

  /**
   * 按相机预览比例计算可铺满当前视图的 Surface 尺寸（cover）
   */
  private calculateCoverSurfaceSize(): Size {
    let viewSize = this.viewPxSize;
    if (!viewSize || !viewSize.width || !viewSize.height) {
      const screen = display.getDefaultDisplaySync();
      viewSize = { width: screen.width, height: screen.height };
    }

    // 相机分辨率是横向的（1280*720），竖屏预览对应 720*1280
    const imageSize: Size = {
      width: cameraResolution.height,
      height: cameraResolution.width
    };
    const imageRatio = imageSize.width / imageSize.height;
    const areaRatio = viewSize.width / viewSize.height;

    let finalWidth = 0;
    let finalHeight = 0;
    if (imageRatio > areaRatio) {
      finalHeight = viewSize.height;
      finalWidth = viewSize.height * imageRatio;
    } else {
      finalWidth = viewSize.width;
      finalHeight = viewSize.width / imageRatio;
    }

    return {
      width: Math.round(finalWidth),
      height: Math.round(finalHeight)
    };
  }

  private async startCamera() {
    if (this.isCameraReady || this.surfaceId === undefined) {
      return;
    }

    const context = getContext(this);
    this.camera = new FUNMCamera(context);
    this.camera.surfaceIds = [this.surfaceId];
    this.camera.isFrontCamera = this.isFrontCamera;
    this.camera.resolution = cameraResolution;
    this.camera.fps = 30;

    try {
      await this.camera.setup();
      await this.camera.startCamera();
      this.isCameraReady = true;
      FULogger.info(TAG, `相机启动成功, isFrontCamera=${this.isFrontCamera}`);
    } catch (error) {
      FULogger.error(TAG, `相机启动失败: ${JSON.stringify(error)}`);
      this.isCameraReady = false;
    }
  }

  private async switchCamera() {
    if (!this.isCameraReady || this.isSwitching || this.surfaceId === undefined) {
      return;
    }

    this.isSwitching = true;
    this.isFrontCamera = !this.isFrontCamera;
    try {
      await this.destroyCamera();
      await this.startCamera();
      FULogger.info(TAG, `镜头切换成功, isFrontCamera=${this.isFrontCamera}`);
    } catch (error) {
      FULogger.error(TAG, `镜头切换失败: ${JSON.stringify(error)}`);
    } finally {
      this.isSwitching = false;
    }
  }

  private async destroyCamera() {
    if (this.camera === undefined) {
      return;
    }

    try {
      await this.camera.destroy();
    } catch (error) {
      FULogger.error(TAG, `相机关闭失败: ${JSON.stringify(error)}`);
    }
    this.camera = undefined;
    this.isCameraReady = false;
  }
}
