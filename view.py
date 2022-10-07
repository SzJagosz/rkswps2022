import matplotlib.pyplot as plt
import csv
Component = []
cost = []
plt.style.use('ggplot')



plt.axis('equal')  # Equal aspect ratio ensures that pie is drawn as a circle.
plt.legend(loc='upper left')

# donut
circle = plt.Circle(xy=(0,0), radius=.75, facecolor='white')
plt.gca().add_artist(circle)
plt.rcParams.update({'font.size':7})


with open('billing.csv', 'r') as csvfile:
    lines = csv.reader(csvfile, delimiter = ',')
    for row in lines:
        Component.append(row[0])
        cost.append(float(row[3]))
plt.pie(cost,labels = Component,autopct = '%.2f%%', startangle=90)
plt.title('Billing', fontsize = 30)
plt.show()
plt.savefig('billing.png', transparent=True)

