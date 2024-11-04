import TodoData from "../viewmodel/TodoData"
import TodoItem from "../view/TodoItem"
import TodoPreferenceModel from "../model/TodoPreferenceModel"
import { promptAction } from "@kit.ArkUI";

@Component
export struct Todo {

  @Provide("CompletedTasksNumber") completedTodoNum: number = 3;
  @State totalTodoNum: number = 5;
  @Provide("Todos") todos: Array<TodoData> = [];
  @State deleteMode: boolean = false;
  @State toDeleteTodos: Set<number> = new Set();
  addTodoDialogController: CustomDialogController = new CustomDialogController({
    builder: AddTodoDialog({
      onClickOk: async (value: string) => {
        this.todos.push({content: value, isComplete: false});
        await TodoPreferenceModel.put(Array.from(this.todos));
        this.totalTodoNum = this.todos.length;
      }
    }),
    alignment: DialogAlignment.Bottom,
    offset: {
      dx: 0,
      dy: "-16vp"
    },
    customStyle: true,
    autoCancel: false
  })

  async aboutToAppear(): Promise<void> {
    this.totalTodoNum = 0;
    this.completedTodoNum = 0;
    this.todos = await TodoPreferenceModel.getAll();
    this.totalTodoNum = this.todos.length;
    this.completedTodoNum = 0;
    this.todos.forEach((v: TodoData) => {
      if (v.isComplete) {
        this.completedTodoNum++;
      }
    })
  }

  build() {
    Column() {
      Row() {
        Column() {
          this.TitleBar($r("app.string.todo_page_title"))
        }.width("80%")

        Text(this.deleteMode ? $r("app.string.cancel") : $r("app.string.manage"))
          .onClick(() => {
            this.deleteMode = !this.deleteMode;
            this.toDeleteTodos = new Set();
          })
      }
      .width("80%")
      .height("10%")

      Row() {
        this.OverallProgress()
      }
      .width("90%")
      .height("10%")

      Column() {
        ForEach(this.todos, (item: TodoData, index: number) => {
          Row() {
            Row() {
              TodoItem({ content: item.content, isComplete: item.isComplete, index: index})
            }.width(this.deleteMode ? "90%" : "100%")
            Row() {
              if (this.deleteMode) {
                Checkbox()
                  .onChange((v: boolean) => {
                    if (v) {
                      this.toDeleteTodos.add(index)
                    } else {
                      this.toDeleteTodos.delete(index)
                    }
                  })
              }
            }.width(this.deleteMode ? "10%" : 0)
          }
        })
      }
      .width("100%")
      .height("70%")

      Row() {
        Button(this.deleteMode ? $r("app.string.delete") : $r("app.string.add"))
          .width("40%")
          .height("80%")
          .fontColor(this.deleteMode ? Color.Red : "#007DFF")
          .backgroundColor("#0D182431")
          .onClick(async () => {
            if (!this.deleteMode) {
              this.addTodoDialogController.open();
            } else {
              this.todos = this.todos.filter((_todo: TodoData, index: number) => !this.toDeleteTodos.has(index))
              await TodoPreferenceModel.put(this.todos)
              this.todos = await TodoPreferenceModel.getAll();
              this.deleteMode = false;
              this.totalTodoNum = this.todos.length;
              this.completedTodoNum = Array.from(this.todos.filter((v: TodoData) => v.isComplete)).length
            }
          })
      }
      .justifyContent(FlexAlign.Center)
      .height("10%")
      .width("100%")
    }
    .backgroundColor("#F1F3F5")
  }

  @Builder
  TitleBar(title: Resource) {
    Text(title)
      .fontSize("28fp")
      .fontWeight(FontWeight.Bold)
      .textAlign(TextAlign.Start)
      .width("100%")
      .height("100%")
  }
  @Builder
  OverallProgress() {
    Row() {
      Column() {
        Text($r("app.string.overall_progress"))
          .fontSize("24fp")
          .fontColor(Color.Blue)
          .fontWeight(FontWeight.Regular)
      }
      .alignItems(HorizontalAlign.Start)
      Blank()
      Stack() {
        Row() {
          Text(this.completedTodoNum.toString())
            .fontSize("14fp")
            .fontWeight(500)
            .fontColor(Color.Blue)
          Text(`/${this.totalTodoNum}`)
            .fontSize("14fp")
            .fontWeight(500)
        }
        Progress({
          value: this.completedTodoNum,
          total: this.totalTodoNum,
          type: ProgressType.Ring
        })
          .color(Color.Blue)
          .height("48vp")
          .width("48vp")
      }
      .height("100%")
    }
    .width("100%")
    .height("100%")
  }
}
@CustomDialog
struct AddTodoDialog {
  @State todoName: string = "";
  private controller?: CustomDialogController;
  onClickOk?: (value: string) => void;
  build() {
    Column() {
      Text($r("app.string.add_todo"))
        .width("100%")
        .fontSize("20fp")
        .fontWeight(500)
        .fontColor($r('sys.color.font_primary'))
        .textAlign(TextAlign.Start)
      TextInput({ placeholder: $r("app.string.todo_input_tip") })
        .placeholderColor(Color.Gray)
        .placeholderFont({ size: "16fp" })
        .caretColor(Color.Blue)
        .backgroundColor("#0D182431")
        .width("100%")
        .height("40%")
        .margin({ top: "6%" })
        .fontSize("16fp")
        .fontColor($r('sys.color.font_primary'))
        .onChange((value: string) => {
          this.todoName = value;
        })
      Blank()
      Row() {
        Button($r("app.string.cancel"))
          .fontSize("16fp")
          .height("32vp")
          .width("96vp")
          .backgroundColor(Color.White)
          .fontColor($r('sys.color.brand'))
          .onClick(() => {
            this.controller?.close()
          })
        Button($r("app.string.confirm"))
          .fontSize("16fp")
          .height("32vp")
          .width("96vp")
          .backgroundColor(Color.White)
          .fontColor($r('sys.color.brand'))
          .onClick(() => {
            if (this.onClickOk != undefined) {
              if (this.todoName.length == 0) {
                this.showToast("Content can not be empty")
                return;
              }
              if (this.todoName.length >= 10) {
                this.showToast("Content can not be longer than 10 characters")
                return;
              }
              this.onClickOk(this.todoName)
            }
            this.controller?.close()
          })
      }
      .width("70%")
      .height("10%")
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .padding($r('sys.float.corner_radius_level12'))
    .height("168vp")
    .width("90.3%")
    .borderRadius(32)
    .backgroundColor(Color.White)
  }
  showToast(message: string) {
    promptAction.showToast({
      message: message,
      duration: 2000
    })
  }
}