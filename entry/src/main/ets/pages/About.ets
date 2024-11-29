import { router } from "@kit.ArkUI";
import { BusinessError } from '@kit.BasicServicesKit';

function handleClick() {
  router.back();
}

@Entry
@Component
struct About {
  @State message: string = 'About Page';

  build() {
    RelativeContainer() {
      Row() {
        Column() {
          Text(this.message)
            .id('AboutHelloWorld')
            .fontSize(50)
            .fontWeight(FontWeight.Bold)
            .alignRules({
              center: { anchor: '__container__', align: VerticalAlign.Center },
              middle: { anchor: '__container__', align: HorizontalAlign.Center }
            })
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