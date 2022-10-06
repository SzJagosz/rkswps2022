from flask import Flask, request, flash, url_for, redirect, render_template
from tabulate import tabulate
import pandas as pd
import subprocess

app = Flask(__name__)


@app.route('/')
def index():
    return render_template('home.html')

@app.route('/insert')
def insert():
    return render_template('insert.html')

@app.route('/billing')
def billing():
    return render_template('billing.html')

@app.route('/billing', methods=['POST'])
def billing_data():

    start_date = request.form['start_date']
    end_date = request.form['end_date']    
    filename = 'billing_db.csv'
    
    
    df = pd.DataFrame({'start_date': [start_date],
                       'end_date': [end_date]})
    df.columns = ['start_date','end_date']
    print (start_date)
    print (end_date)
    df.to_csv(filename, mode='a', index=False, header=False,encoding='utf-16')
    print("---BILLING DATA---")
    print(tabulate(df, headers='keys', tablefmt='psql'))
    print("Running BILLING .PS1 script...")
    subprocess.call("powershell .\\billing.ps1")
    with open("billing.csv") as file:
        return render_template('index.html', csv=file)
    

if __name__ == '__main__':

    app.run()