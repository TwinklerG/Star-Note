import { webview } from "@kit.ArkWeb"
import RandomPicture from "../view/RandomPicture";
import Webview from "../view/Webview";

@Component
export struct About {
  scroller: Scroller = new Scroller();
  controller: webview.WebviewController = new webview.WebviewController();
  @Provide("WebPageStack") webPageStack: NavPathStack = new NavPathStack();
  @State choice: number = 0;

  build() {
    Navigation(this.webPageStack) {
      Scroll(this.scroller) {
        Column({space: 16}) {
          Text($r("app.string.about_page_title"))
            .fontSize("28fp")
            .fontWeight(FontWeight.Bold)
            .lineHeight("33vp")
            .textAlign(TextAlign.Start)
          .width("80%")
          .margin({top: "24vp", bottom: "12vp"})
          Text($r("app.string.about_project"))
            .textAlign(TextAlign.Start)
            .width("90%")
          Text($r("app.string.contact"))
            .textAlign(TextAlign.Start)
            .width("90%")
          Text($r("app.string.other_functions"))
            .textAlign(TextAlign.Start)
            .width("90%")
            .fontWeight(FontWeight.Bold)
          Button($r("app.string.micro_browser"))
            .onClick(() => {
              this.choice = 0;
              this.webPageStack.replacePath({name: "AboutPageStack"})
            })
            .alignSelf(ItemAlign.Start)
            .width("90%")
            .backgroundColor("#ffdddddd")
            .fontColor("#000000")
            .margin({left: "5%", right: "5%"})
          Button($r("app.string.random_2D"))
            .onClick(() => {
              this.choice = 1;
              this.webPageStack.replacePath({name: "RandomImagePageStack"})
            })
            .alignSelf(ItemAlign.Start)
            .width("90%")
            .margin({left: "5%", right: "5%"})
            .backgroundColor("#ffdddddd")
            .fontColor("#000000")
        }
        .width("100%")
        .height("100%")
      }
    }
    .backgroundColor("#F1F3F5")
    .hideTitleBar(true)
    .navDestination(this.WebPage)
    .mode(NavigationMode.Stack)
  }

  @Builder
  WebPage() {
    if (this.choice == 0) {
      Webview()
    } else if (this.choice == 1) {
      RandomPicture()
    }
  }
}
