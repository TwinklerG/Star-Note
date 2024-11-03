import NoteData from "../viewmodel/NoteData"
import NoteItemEdit from "../view/NoteItemEdit"
import NotePreferenceModel from "../model/NotePreferenceModel"

@Component
export struct Notes {
  @Provide("Notes") notes: Array<NoteData> = [
    {title: "1", content: "this is for test 1", createdAt: (new Date()).toString() ,updatedAt: (new Date()).toString()},
    {title: "2", content: "this is for test 2", createdAt: (new Date()).toString() ,updatedAt: (new Date()).toString()}
  ]
  @Provide("Note") note: NoteData = new NoteData();
  @Provide("NotesPageStack") notesPageStack: NavPathStack = new NavPathStack();
  @State deleteMode: boolean = false;
  @State toDeleteNotesTitles: Set<string> = new Set();

  async aboutToAppear(): Promise<void> {
    this.notes = await NotePreferenceModel.getAll();
    this.notes.sort((a, b) => new Date(b.updatedAt).getTime() - new Date(a.updatedAt).getTime())
  }

  build() {
    Navigation(this.notesPageStack) {
      Column() {
        Row() {
          this.TitleBar($r("app.string.note_page_title"))
          Text(this.deleteMode ? $r("app.string.cancel"): $r("app.string.manage"))
            .position({x: "80%", y: "40%"})
            .fontSize("20fp")
            .fontColor(Color.Blue)
            .onClick(() => {
              this.toDeleteNotesTitles.clear();
              this.deleteMode = !this.deleteMode;
            })
        }
        .width("80%")
        .height("10%")

        Row() {
          Grid() {
            ForEach(this.notes, (item: NoteData) => {
              GridItem() {
                this.NoteItem(item)
              }.margin("2%")
            })
          }
          .columnsTemplate("1fr 1fr")
        }
        .height("80%")
        .width("90%")
        Row() {
          Button(!this.deleteMode ? $r("app.string.add") : $r("app.string.delete"))
            .width("40%")
            .height("60%")
            .backgroundColor(Color.White)
            .fontColor(this.deleteMode ? Color.Red : "#007DFF")
            .backgroundColor("#0D182431")
            .onClick(async () => {
              if (!this.deleteMode) {
                this.note = {title: "", content: "", createdAt: (new Date()).toString(), updatedAt: (new Date()).toString()};
                this.notesPageStack.replacePath({name: "NotesPageStack"});
              } else {
                for (let title of this.toDeleteNotesTitles) {
                  console.log(title);
                  NotePreferenceModel.delete(title);
                  this.notes = await NotePreferenceModel.getAll();
                  this.notes.sort((a, b) => (new Date(b.updatedAt)).getTime() - (new Date(a.updatedAt)).getTime())
                }
                this.deleteMode = !this.deleteMode;
              }
            })
        }
        .justifyContent(FlexAlign.Center)
        .height("10%")
        .width("100%")
      }
      .height("100%")
    }
    .backgroundColor("#F1F3F5")
    .hideTitleBar(true)
    .navDestination(this.PageMap)
    .mode(NavigationMode.Stack)
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
  NoteItem(noteData: NoteData) {
    Column() {
      Row() {
        Text(noteData.title)
          .fontSize("20fp")
          .fontWeight(FontWeight.Bold)
          .textAlign(TextAlign.Start)
        if (this.deleteMode) {
          Checkbox()
            .position({x: "80%", y: "10%"})
            .onChange((v: boolean) => {
              if (v) {
                this.toDeleteNotesTitles.add(noteData.title);
              } else {
                this.toDeleteNotesTitles.delete(noteData.title);
              }
            })
        }
      }
      .width("100%")
      .height("40%")
      Row() {
        Text(noteData.content.length > 20 ? noteData.content.substring(0, 20) + "..." : noteData.content)
          .fontSize("15fp")
          .fontWeight(FontWeight.Normal)
          .textAlign(TextAlign.Start)
          .fontColor(Color.White)
      }.width("100%")
      .height("60%")
    }
    .backgroundColor(Color.White)
    .height(80)
    .borderRadius("5%")
    .padding("5%")
    .onClick(() => {
      this.note = noteData;
      this.notesPageStack.pushPath({name: "NoteItemEdit"});
    })
  }
  @Builder
  PageMap() {
    NoteItemEdit({note: this.note})
  }
}