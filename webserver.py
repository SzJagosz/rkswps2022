from flask import Flask, request, flash, url_for, redirect, render_template
from tabulate import tabulate
from datetime import datetime
import pandas as pd
import subprocess
import csv

now = datetime.now()
current_time = now.strftime("%H:%M:%S")

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
        return render_template('billing.html', csv=file)

@app.route('/insert', methods=['POST'])
def data():

    pwd = request.form['pwd']
    res_gr = request.form['res_gr']
    aks_name = request.form['aks_name']
    nodes_min = request.form['nodes_min']
    nodes_max = request.form['nodes_max']
    os = request.form ['os']
    instance_name = request.form ['instance_name']
    
    
    filename = 'db.csv'
    
    
    df = pd.DataFrame({'pwd': [pwd],
                       'res_gr': [res_gr],
                       'aks_name': [aks_name],
                       'nodes_min': [nodes_min],
                       'nodes_max': [nodes_max],
                       'os': [os],
                       'instance_name' : [instance_name],
                       'time': [current_time]})
    df.columns = ['pwd','res_gr','aks_name','nodes_min','nodes_max','os','instance_name','time']
    df.to_csv(filename, mode='a', index=False, header=False)
    print("---INSERT DATA---")
    print(tabulate(df, headers='keys', tablefmt='psql'))
    
    print("Running AZ .PS1 script...")
    status = 'pending...'
    subprocess.call("powershell .\\main.ps1")
    status = 'created'
    return render_template('insert.html',res_gr=res_gr,aks_name=aks_name,instance_name=instance_name,os=os,current_time=current_time,status=status)
    

if __name__ == '__main__':

    app.run()