from flask import Flask

#Quick Start: https://flask.palletsprojects.com/en/stable/quickstart/
#You can make a mini web service form as a data entry interface

app = Flask(__name__)

@app.route("/")
def main():
    return "<h1>Hello World</h1>"

@app.route("/home")
def home():
    html = ("<h1>This is a second page</h1>"
            "<h2> With a second header</h2>")
    return html

