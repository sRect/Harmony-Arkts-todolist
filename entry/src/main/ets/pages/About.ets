import { router } from "@kit.ArkUI";
import { BusinessError } from '@kit.BasicServicesKit';
import { camera, cameraPicker as picker } from '@kit.CameraKit'
import { fileIo, fileUri } from '@kit.CoreFileKit'

function handleClick() {
  router.back();
}

@Entry
@Component
struct About {
  @State message: string = 'About Page';
  @State imgSrc: string = '';
  @State videoSrc: string = '';

  build() {
    RelativeContainer() {
      Row() {
        Column() {
          Column({space: 10}) {
            Text(this.message)
              .id('AboutHelloWorld')
              .fontSize(50)
              .fontWeight(FontWeight.Bold)
              .alignRules({
                center: { anchor: '__container__', align: VerticalAlign.Center },
                middle: { anchor: '__container__', align: HorizontalAlign.Center }
              })

            Button() {
              Text('open camera')
                .fontSize(20)
                .fontColor('#ffffff')
            }
            .type(ButtonType.Normal)
            .onClick(async () => {
              try {
                console.log("open camera click");

                let pathDir = getContext().filesDir;
                let fileName = `${new Date().getTime()}`
                let filePath = pathDir + `/${fileName}.tmp`
                fileIo.createRandomAccessFileSync(filePath, fileIo.OpenMode.CREATE);

                let uri = fileUri.getUriFromPath(filePath);
                let pickerProfile: picker.PickerProfile = {
                  cameraPosition: camera.CameraPosition.CAMERA_POSITION_BACK,
                  saveUri: uri
                };
                let result: picker.PickerResult =
                  await picker.pick(getContext(), [picker.PickerMediaType.PHOTO, picker.PickerMediaType.VIDEO],
                    pickerProfile);
                console.info(`picker resultCode: ${result.resultCode},resultUri: ${result.resultUri},mediaType: ${result.mediaType}`);
                if (result.resultCode == 0) {
                  if (result.mediaType === picker.PickerMediaType.PHOTO) {
                    this.imgSrc = result.resultUri;
                  } else {
                    this.videoSrc = result.resultUri;
                  }
                }
              } catch (e) {
                console.error(e)
              }
            })

            if(this.imgSrc === "") {
              Text("暂无图片,请点击按钮拍照")
            } else {
              Image(this.imgSrc)
                .width('100%')
            }

          }
          Button() {
            Text('go back')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor('#ffffff')
          }
          .type(ButtonType.Normal)
          .width('40%')
          .height('5%')
          .margin({
            top: '40'
          })
          .backgroundColor('#333333')
          .onClick(() => {
            try {
              handleClick();
            }catch (e) {
              let errMsg = (e as BusinessError).message;
              console.error(`返回失败: ${errMsg}`)
            }
          })
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.SpaceBetween)
      }

    }
    .height('100%')
    .width('100%')
  }
}