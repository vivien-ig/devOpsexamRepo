from flask import Flask, render_template, request, redirect, url_for

app = Flask(__name__)
todo_list = []

@app.route('/')
def index():
    return render_template('index.html', todos=todo_list)

@app.route('/add', methods=['POST'])
def add_todo():
    todo_item = request.form.get('todo')
    if todo_item:
        todo_list.append(todo_item)
    return redirect(url_for('index'))

@app.route('/delete/<int:index>')
def delete_todo(index):
    if 0 <= index < len(todo_list):
        todo_list.pop(index)
    return redirect(url_for('index'))

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
