from flask import Flask, request, flash, url_for, redirect, render_template
app = Flask(__name__)

@app.route('/')
def index():
    return render_template('home.html')

@app.route('/billing')
def billing():
    return render_template('billing.html')

@app.route('/insert')
def insert():
    return render_template('insert.html')
    

if __name__ == '__main__':

    app.run()