import { webview } from "@kit.ArkWeb";

@Component
export default struct Webview {
  controller: webview.WebviewController = new webview.WebviewController();
  @Consume("WebPageStack") aboutPageStack: NavPathStack;
  @State webSrc: string = "https://baidu.com";

  build() {
    NavDestination() {
      Column() {
        Row() {
          TextInput({ placeholder: "请输入网址", text: this.webSrc })
            .layoutWeight(1)
            .backgroundColor(Color.White)
            .onChange((value: string) => {
              this.webSrc = value;
            })
            .backgroundColor("#ffececec")
            .width("70%")
          Image($rawfile("go_ahead.svg"))
            .width("8%")
            .backgroundColor(Color.White)
            .onClick(() => {
              this.controller.loadUrl(this.webSrc);
            })
            .borderRadius("50%")
          Image($rawfile("back.svg"))
            .width("8%")
            .backgroundColor(Color.White)
            .onClick(() => {
              this.controller.backward();
            })
            .borderRadius("50%")
          Image($rawfile("forward.svg"))
            .width("8%")
            .backgroundColor(Color.White)
            .onClick(() => {
              this.controller.forward();
            })
            .borderRadius("50%")
        }
        .height("10%")
        Web({ src: this.webSrc, controller: this.controller })
          .height("90%")
          .width("100%")
          .zoomAccess(true)
          .onClick(() => {
            const intervalId = setInterval(() => {
              if (this.controller.getUrl() !== this.webSrc) {
                this.webSrc = this.controller.getUrl();
              }
            }, 100)
            setTimeout(() => {
              clearInterval(intervalId);
            }, 5000)
          })
      }
      .width('100%')
    }
    .hideTitleBar(true)
  }
}