import { router } from "@kit.ArkUI";
import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  // 其build()函数之前执行
  // 允许在aboutToAppear函数中改变状态变量，更改将在后续执行build()函数中生效
  aboutToAppear(): void {
    console.log('aboutToAppear');
  }

  build() {
    RelativeContainer() {
      Row() {
        Column({space: 20}) {
          Text(this.message)
            .id('HelloWorld')
            .fontSize(50)
            .fontWeight(FontWeight.Bold)
            .alignRules({
              center: { anchor: '__container__', align: VerticalAlign.Center },
              middle: { anchor: '__container__', align: HorizontalAlign.Center }
            })
          Button() {
            Text('goto about')
              .fontSize(30)
              .fontWeight(FontWeight.Normal)
              .fontColor('white')
          }
          .type(ButtonType.Capsule)
          .backgroundColor("#0D9FFB")
          .width('auto')
          .height('auto')
          .padding('10 5')
          .onClick(() => {
            console.log("btn click");
            router.pushUrl({
              url: "pages/About"
            })
              .then(() => {
                console.info('跳转成功');
              })
              .catch((e:BusinessError) => {
                console.error(e.message);
              })
          })

          Button() {
            Text('goto todolist')
              .fontSize(30)
              .fontWeight(FontWeight.Normal)
              .fontColor('white')
          }
          .type(ButtonType.Capsule)
          .backgroundColor("#0D9FFB")
          .width('auto')
          .height('auto')
          .padding('10 5')
          .onClick(() => {
            try {
              router.pushUrl({
                url: "pages/Todolist"
              });
            }catch(e) {
              const errMsg = (e as BusinessError).message;
              console.error(errMsg);
            }
          })
        }
        .width('100%')
        .height('100%')
      }

    }
    .height('100%')
    .width('100%')
  }

  // 自定义组件的build()函数之后执行。
  // 不建议在onDidBuild函数中更改状态变量、使用animateTo等功能，这可能会导致不稳定的UI表现
  onDidBuild(): void {
    console.info('onDidBuild');
  }

  aboutToDisappear(): void {
    console.info('aboutToDisappear');
  }

  onPageShow(): void {
    console.info('onPageShow');
  }

  onPageHide(): void {
    console.info('onPageHide');
  }

  onBackPress() {
    console.info('onBackPress');
  }
}