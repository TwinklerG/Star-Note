import NoteData from "../viewmodel/NoteData"
import NotePreferenceModel from "../model/NotePreferenceModel"

@Component
export default struct NoteItemEdit {
  @Consume("Notes") notes: Array<NoteData>
  @Consume("NotesPageStack") notesPageStack: NavPathStack;
  @Prop note: NoteData;
  @State m_title: string = "";
  @State m_content: string = "";

  aboutToAppear(): void {
    this.m_title = this.note.title;
    this.m_content = this.note.content;
  }

  async aboutToDisappear(): Promise<void> {
    if (this.m_title != this.note.title || this.m_content != this.note.content) {
      NotePreferenceModel.delete(this.note.title);
      if (this.note.title == "" && this.note.content == "") {
        this.note.createdAt = (new Date()).toString();
      }
      await NotePreferenceModel.put({title: this.m_title, content: this.m_content, createdAt: this.note.createdAt, updatedAt: (new Date()).toString()})
      this.notes = await NotePreferenceModel.getAll();
      this.notes.sort((a, b) => (new Date(b.updatedAt)).getTime() - (new Date(a.updatedAt)).getTime())
      this.notes.forEach((item) => {
        console.log(item.title, item.content, item.createdAt, item.updatedAt)
      })
    }
  }

  build() {
    NavDestination() {
      Column() {
        Row() {
          Text($r("app.string.create_at"))
          Text((new Date(this.note.createdAt)).toLocaleString())
        }
        .height("3%")
        .margin("1%")
        Row() {
          Text($r("app.string.updated_at"))
          Text((new Date(this.note.updatedAt)).toLocaleString())
        }
        .height("3%")
        .margin("1%")
        TextInput({placeholder: $r("app.string.title_input_tip"), text: this.m_title})
          .onChange((v: string) => {
            this.m_title = v;
          })
          .margin("2%")
          .height("6%")
        TextArea({placeholder: $r("app.string.content_input_tip"), text: this.m_content})
          .onChange((v: string) => {
            this.m_content = v;
          })
          .height("80%")
      }
      .width("100%")
      .height("100%")
    }
    .hideTitleBar(true)
  }
}