import pandas
import subprocess
#df = pandas.read_csv('billing_tst.csv',header=None)
#df.replace('"', '', inplace=True, regex=True)
#df.to_csv("billing_tst.csv",header=False, index=False)

subprocess.call("powershell .\\cleaner.py")