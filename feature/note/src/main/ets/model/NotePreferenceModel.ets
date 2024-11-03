import { preferences } from '@kit.ArkData'

import NoteData from "../viewmodel/NoteData"

const NOTE_PREFERENCE_NAME = "notes"

let context: Context = getContext(this)
let preference: preferences.Preferences

class NotePreferenceModel {
  async put(noteData: NoteData) {
    preference = await preferences.getPreferences(context, NOTE_PREFERENCE_NAME);
    // TODO : handle when the title is empty
    if (noteData.title != "") {
      await preference.put(noteData.title, JSON.stringify(noteData))
    }
    await preference.flush()
  }
  async getAll() {
    preference = await preferences.getPreferences(context, NOTE_PREFERENCE_NAME);
    let tmp_obj = await preference.getAll();
    let ret: Array<NoteData> = [];
    Object.values(tmp_obj).forEach((v: string) => {
      try {
        let t: NoteData = JSON.parse(v);
        ret.push(t);
      } catch (e) {
        console.log("getAllPreference error:", e);
      }
    })
    return ret;
  }
  async delete(title: string) {
    preference = await preferences.getPreferences(context, NOTE_PREFERENCE_NAME);
    await preference.delete(title);
    await preference.flush();
  }
  async deleteAll() {
    await preferences.deletePreferences(context, NOTE_PREFERENCE_NAME)
    await preference.flush();
  }
}

export default new NotePreferenceModel();