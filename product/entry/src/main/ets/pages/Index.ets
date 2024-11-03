import { Notes} from "@tkg/note"
import { Todo } from "@tkg/todo"
import { About} from "@tkg/about"

@Entry
@Component
struct Index {
  @State currentIndex : number = 0;
  private tabsController: TabsController = new TabsController();

  build() {
    Tabs({barPosition: BarPosition.End, controller: this.tabsController}) {
      TabContent() {
        Notes()
      }.tabBar(this.tabBarBuilder("笔记", 0, $r("app.media.notes_icon_on"), $r("app.media.notes_icon_off")))
      TabContent() {
        Todo()
      }.tabBar(this.tabBarBuilder("代办", 1, $r("app.media.todo_icon_on"), $r("app.media.todo_icon_off")))
      TabContent() {
        About()
      }.tabBar(this.tabBarBuilder("我的", 2, $r("app.media.about_icon_on"), $r("app.media.about_icon_off")))
    }
    .vertical(false)
    .scrollable(false)
    .backgroundColor(Color.White)
  }

  @Builder
  tabBarBuilder(title: string, targetIndex: number, selectedIcon: Resource, unselectedIcon: Resource) {
    Column() {
      Image(this.currentIndex == targetIndex ? selectedIcon : unselectedIcon)
        .height(24)
        .width(24)
      Text(title)
        .fontSize(10)
        .fontColor(this.currentIndex == targetIndex ? Color.Blue : Color.Gray)
        .fontWeight(500)
    }
    .width("100%")
    .height("100%")
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .onClick(() => {
      this.currentIndex = targetIndex;
      this.tabsController.changeIndex(targetIndex);
    })
  }
}