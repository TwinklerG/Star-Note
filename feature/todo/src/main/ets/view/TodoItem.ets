import TodoData from "../viewmodel/TodoData"
import TodoPreferenceModel from "../model/TodoPreferenceModel"

@Component
export default struct TodoItem {
  @Prop content: string;
  @Prop isComplete: boolean;
  @Prop index: number;
  @Consume("Todos") todos: Array<TodoData>;
  @Consume("CompletedTasksNumber") completedTasksNumber: number;
  @Builder labelIcon(icon: Resource) {
    Image(icon)
      .objectFit(ImageFit.Contain)
      .width("28vp")
      .height("28vp")
      .margin("20vp")
  }
  build() {
    Row() {
      if (this.isComplete) {
        this.labelIcon($r("app.media.ic_ok"))
      } else {
        this.labelIcon($r("app.media.ic_default"))
      }
      Text(this.content)
        .fontSize("20fp")
        .fontWeight(500)
        .opacity(this.isComplete ? 0.4 : 1)
        .decoration({ type: this.isComplete ? TextDecorationType.LineThrough : TextDecorationType.None })
    }
    .borderRadius("5%")
    .backgroundColor("#FFFFFF")
    .width("93.3%")
    .height("64vp")
    .padding({left: 12, right: 12})
    .margin(5)
    .onClick(() => {
      this.isComplete = !this.isComplete;
      this.todos[this.index].isComplete = !this.todos[this.index].isComplete;
      TodoPreferenceModel.put(this.todos);
      if (this.isComplete) {
        this.completedTasksNumber++;
      } else {
        this.completedTasksNumber--;
      }
    })
  }
}