export interface ICurEditObj {
  val: string;
  index: number;
}

@Component
@CustomDialog
struct CustomDialogExample {
  @State curEditVal: string = "";
  cancel?: () => void
  confirm?: (val?: string) => void
  controller: CustomDialogController

  build() {
    Column() {
      Text("请修改").fontSize(20).fontWeight(FontWeight.Bold)
      TextInput({text: this.curEditVal, placeholder: "请输入"})
        .fontSize(14)
        .fontColor('#333333')
        .onChange((val: string) => {
          this.curEditVal = val;
        });

      Row() {
        Button('取消')
          .onClick(() => {
            this.controller.close();
            this.curEditVal = "";

            if (this.cancel) {
              this.cancel()
            }
          })
          .backgroundColor("#cccccc")
          .fontColor(Color.Black)
          .type(ButtonType.Capsule)

        Button('确定')
          .onClick(() => {
            this.controller.close()
            if (this.confirm) {
              // 点击确定修改，将当前的值传回去
              this.confirm(this.curEditVal)
            }
          })
          .backgroundColor('#06BA8C')
          .fontColor(Color.White)
          .type(ButtonType.Capsule)
      }.width('100%').alignItems(VerticalAlign.Center).justifyContent(FlexAlign.SpaceAround);
    }
      .padding('20 12')
      .height('30%')
      .justifyContent(FlexAlign.SpaceBetween)
  }
}


@Entry
@Component
struct Todolist {
  @State inputVal: string = '';
  @State curEditObj: ICurEditObj = { val: "", index: 0 };
  @State private list: string[] = ["1"];
  scroller:Scroller = new Scroller();
  dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomDialogExample({
      confirm: (val?:string)=> {
        console.info("获取到模态框输入值：", val)
        if(val) {
          this.list[this.curEditObj.index] = val;
        }
      }
    }),
    alignment: DialogAlignment.Center,
    cornerRadius: 10,
  })

  build() {
    Flex({direction: FlexDirection.Column}) {
      // 顶部输入
      Row({space: 10}) {
        TextInput({text: this.inputVal, placeholder: '请输入...'})
          .placeholderFont({ size: 14, weight: 400 })
          .placeholderColor(Color.Gray)
          .width('76%')
          .height('100%')
          .fontSize(14)
          .fontColor('#333333')
          .type(InputType.Normal)
          .onChange((val: string) => {
            this.inputVal = val;
          })

        Button() {
          Text('提交')
            .fontSize(18)
            .fontWeight(FontWeight.Normal)
            .fontColor('white')
        }
          .type(ButtonType.Capsule)
          .width('24%')
          .height('100%')
          .flexShrink(1)
          .backgroundColor('#06BA8C')
          .onClick(():void => {
            console.log('click:', this.inputVal);
            if(this.inputVal === "" || this.inputVal.trim() === "") {
              AlertDialog.show({
                title: "",
                message: "内容不可为空",
                isModal: true,
                autoCancel: true,
                alignment: DialogAlignment.Center,
                // backgroundColor: "rgba(0, 0, 0, 0.3)",
                // backgroundBlurStyle: BlurStyle.Thick,
                borderWidth: 0,
                cornerRadius: 10,
                // height: 40,
                width: '50%',
                gridCount: 1
              });
              return;
            }

            this.list.unshift(this.inputVal);
            this.inputVal = "";
          });
      }.width('100%').height(40);

      // 中间滚动区域
      Scroll(this.scroller) {
        Column({space:10}) {
          if(this.list.length > 0) {
            ForEach(this.list, (item?:string, index?:number) => {
              if(item && typeof index === 'number') {
                Row({space: 10}) {
                  Text(`${index+1}. ${item}`)
                    .fontSize(14)
                    .fontColor('#333333')
                    .width('58%')
                    // .wordBreak(WordBreak.BREAK_ALL)
                    // .maxLines(2)
                    .textOverflow({ overflow: TextOverflow.MARQUEE })

                  Row({space: 5}) {
                    Button() {
                      Text('编辑').fontSize(14).fontColor(Color.White)
                    }
                    .width('50%')
                    .height('100%')
                    .flexShrink(0)
                    .flexGrow(0)
                    .flexBasis('50%')
                    .backgroundColor(Color.Blue)
                    .onClick(() => {
                      // 打开自定义模态框
                      console.log("当前数据：", item);
                      this.curEditObj = {
                        val: item,
                        index: index
                      }
                      // this.dialogController
                      this.dialogController.open();
                    })

                    Button() {
                      Text('删除').fontSize(14).fontColor(Color.White)
                    }
                    .type(ButtonType.Capsule)
                    .width('50%')
                    .height('100%')
                    .flexShrink(0)
                    .flexGrow(0)
                    .flexBasis('50%')
                    .backgroundColor(Color.Orange)
                    .onClick(() => {
                      this.list.splice(index, 1);
                    })
                  }.width('40%').height('100%').flexShrink(0);
                }
                .justifyContent(FlexAlign.SpaceBetween)
                .alignItems(VerticalAlign.Center)
                .width('100%')
                .flexGrow(0)
                .height('50')
                .backgroundColor('#f0f0f0')
                .padding('10')
                .borderRadius(4);
              }
            })
          } else {
            Text('暂无数据').fontColor(Color.Gray).margin({top: '30%', bottom: '30%'});
          }
        }
        .width('100%')
        .height('auto')
        .justifyContent(FlexAlign.Start)
        .alignItems(HorizontalAlign.Center)
      }
      .backgroundColor('white')
      .scrollable(ScrollDirection.Vertical) // 滚动方向为垂直方向
      // .scrollBar(BarState.On) // 滚动条常驻显示
      .scrollBarColor(Color.Gray) // 滚动条颜色
      .scrollBarWidth(5) // 滚动条宽度
      .edgeEffect(EdgeEffect.Spring) // 滚动到边沿后回弹
      .height('auto')
      .margin({top: 20})
      .padding(10)
      .borderRadius(4)
      // .flexGrow(1)
    }
    .height('100%')
    .width('100%')
    .backgroundColor('#f6f6f6')
    .padding(10)
  }
}