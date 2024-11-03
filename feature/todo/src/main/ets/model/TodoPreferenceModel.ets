import TodoData from "../viewmodel/TodoData"
import { preferences } from '@kit.ArkData'

const TODO_PREFERENCE_NAME = "todos"
const TODO_KEY: string = "todos"

let context: Context = getContext(this)
let preference: preferences.Preferences;

class TodoPreferenceModel {
  async put(todosData: Array<TodoData>) {
    preference = await preferences.getPreferences(context, TODO_PREFERENCE_NAME)
    if (todosData.length !== 0) {
      await preference.put(TODO_KEY, JSON.stringify(todosData));
    }
    await preference.flush();
  }
  async getAll(): Promise<TodoData[]> {
    preference = await preferences.getPreferences(context, TODO_PREFERENCE_NAME);
    return JSON.parse((await preference.get(TODO_KEY, {})).toString());
  }
  async delete(content: string): Promise<void> {
    preference = await preferences.getPreferences(context, TODO_PREFERENCE_NAME);
    let todos: Array<TodoData> = JSON.parse((await preference.get(TODO_KEY, {})).toString());
    console.log(JSON.stringify(new Set(todos.filter((todo: TodoData) => todo.content != content))))
    await preference.put(TODO_KEY, JSON.stringify(new Set(todos.filter((todo: TodoData) => todo.content != content))))
    await preference.flush()
  }
  async deleteAll() {
    await preferences.deletePreferences(context, TODO_PREFERENCE_NAME);
    await preference.flush();
  }
}

export default new TodoPreferenceModel()