#Binning
pyspark --packages com.databricks:spark-csv_2.10:1.2.0
import numpy as np
import pandas as pd
import csv
import matplotlib
import pyspark.sql
from pyspark.sql import *
import pyspark.sql.types
from pyspark.sql.types import *
import datetime
from datetime  import date
from datetime import datetime
from pyspark.sql.types import (StringType, DoubleType, TimestampType, NullType, IntegerType, StructType, StructField)
from pyspark.sql import functions as F
import pyspark.sql.dataframe
from pyspark.sql.functions import *

sqlContext = SQLContext(sc)

credit = sqlContext.read.load('file:///Users/dospina/Documents/Nestor/credit.csv', format="com.databricks.spark.csv", header="true", inferSchema = "true")
creditpd = credit.toPandas()


credit.select(max(credit.AGE)).show()
minrow = credit.select(min(credit.AGE)).collect()[0]
mini = minrow["min(AGE)"]

maxrow = credit.select(max(credit.AGE)).collect()[0]
maxi = maxrow["max(AGE)"]
k = 6
interval = (maxi - mini)/float(k)
number = mini
bins = list()
while True:
    print (number)
    bins.append(number)
    number = number + interval
    if number >= maxi: break
bins.append(number)
print(number)
print(bins)
print(len(bins))

group_names = ['21-30', '30-40', '40-50', '50-60', '60-70', '70-80']
categories = pd.cut(creditpd['AGE'], bins, labels = group_names)
creditpd['categories']= pd.cut(creditpd['AGE'], bins, labels = group_names)
categories
pd.value_counts(creditpd['categories'])
creditpd

credit.groupBy('SEX','BGI').count().show()


x = sqlContext.createDataFrame(creditpd)
x.select(max(x.AGE)).show()
credit.select(max(credit.AGE)).show()
#La diferencia en tiempo entre las dos sentencias anteriores es bastante
#El resultado es el mismo.

credit.select(sum(credit.AGE)).collect()
credit.select(sum(credit.AGE)).first()[0][0]
credit.groupby(credit.AGE).sum().show()
credit.agg(avg(col("AGE")))
#ODDS, para categoricas
x.sort("categories").groupBy('categories', 'AGE','BGI').count().show()
x.groupBy('categories', 'BGI').count().show()
y = x.groupBy('categories', 'BGI').count().collect()
y0 = y[0]
y1 = y[1]
county0 = y0["count"]
county1 = y1["count"]
print (county0/float(county1))

credit.groupBy('SEX','BGI').count().show()
y = credit.groupBy('SEX', 'BGI').count().collect()
y0 = y[0]
y1 = y[1]
county0 = y0["count"]
county1 = y1["count"]
print (county0/float(county1))

credit.sort(column).groupBy(column).count().show()
credit.groupBy('EDUCATION','BGI').count().show()
credit.groupBy('MARRIAGE','BGI').count().show()


#GINI
credit.sort(credit.AGE).select(credit.AGE, credit.BGI).show()
aja = x
for column in aja.columns:
    print ('======= NEW LOOP ======')
    if (column == "categories"):
        x = aja.sort(column).groupBy(column).count().collect()
        aja.sort(column).groupBy(column).count().show()
        wasum = 0
        for item in x:
            xi = item[column]
            xii = item['count']
            print(column, xi, xii)
            print(xii/float(total))
            y = aja.sort(column).groupBy(column, 'BGI').count().collect()
            aja.sort(column).groupBy(column, 'BGI').count().show()
            psum = 0
            for item in y:
                yi = item[column]
                yii = item['count']
                if xi == yi:
                    print(column, 'BGI', yi, yii)
                    print(yii/float(xii))
                    print((yii/float(xii))**2)
                    ysc = (yii/float(xii))**2
                    psum = psum + ysc
            gini = 1 - psum
            print ('summ', psum)
            print ('gini', gini)
            print ('Waveg', (xii/float(total))*gini)
            wasum = wasum + (xii/float(total))*gini
        print ('wasum', wasum)
        print ('difgini', ginit-wasum )

#Nota: David adjunto el archivo que realiza el algoritmo MDLP para las particiones, la función que define las particiones tiene el nombre de “cut_points”, las entradas deben ser arrays. No dude en comentarme cualquier pregunta.
#Para correr la función se debe el archivo (From MDP import) y para utilizar la función “MDLP().cut_points(x,y)”

from MDLP import *
MDLP().cut_points(x,y)



function = lambda a, b, c: a + b

items = [1, 2, 3, 4, 5]
squared = []
for i in items:
    squared.append(i**2)

items = [1, 2, 3, 4, 5]
squared = list(map(lambda x: x**2, items))

def sqr(x):
        return (x**2)

squared = map(sqr, items)


store1 = [10.00, 11.00, 12.34, 2.34]
store2 = [9.00, 11.10, 12.34, 2.01]
cheapest = map(min, store1, store2)
cheapest
