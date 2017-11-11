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

total = credit.count()
print(total)

#Gini JUST BGI
credit.sort(credit.BGI).groupBy('BGI').count().show()
x = credit.sort(credit.BGI).groupBy('BGI').count().collect()
summ = 0
for item in x:
    xi = item['BGI']
    xii = item['count']
    print('BGI', xi, xii)
    print(xii/float(total))
    print((xii/float(total))**2)
    summ = summ + (xii/float(total))**2
print(summ)
ginit = 1 - summ
print(ginit)

#Gini BGI/columns
for column in credit.columns:
    print ('======= NEW LOOP ======')
    print (column)
    if not (column == "EDUCATION" or column == "SEX" or column == "MARRIAGE"):  continue
    x = credit.sort(column).groupBy(column).count().collect()
    wasum = 0
    for item in x:
        xi = item[column]
        xii = item['count']
        y = credit.sort(column).groupBy(column, 'BGI').count().collect()
        psum = 0
        for item in y:
            yi = item[column]
            yii = item['count']
            if not xi == yi: continue
            ysc = (yii/float(xii))**2
            psum = psum + ysc
        gini = 1 - psum
        wasum = wasum + (xii/float(total))*gini
    print ('wasum', wasum)
    print ('difgini', ginit-wasum )

#The attribute with the lower wasum is the best to describe BGI
#Or the one with the greater difgini
for column in credit.columns:
    print ('======= NEW LOOP ======')
    print (column)
    x = credit.sort(column).groupBy(column).count().collect()
    wasum = 0
    for item in x:
        xi = item[column]
        xii = item['count']
        y = credit.sort(column).groupBy(column, 'BGI').count().collect()
        psum = 0
        for item in y:
            yi = item[column]
            yii = item['count']
            if not xi == yi: continue
            ysc = (yii/float(xii))**2
            psum = psum + ysc
        gini = 1 - psum
        wasum = wasum + (xii/float(total))*gini
    print ('wasum', wasum)
    print ('difgini', ginit-wasum )
