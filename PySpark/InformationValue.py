#Information Value and Weight of Evidence V4
pyspark --packages com.databricks:spark-csv_2.10:1.2.0
import numpy as np
import pandas as pd
import plotly
import csv
import matplotlib
import math
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
import plotly.plotly as py
import plotly.graph_objs as go
from pyspark.sql.functions import *

sqlContext = SQLContext(sc)
credit = sqlContext.read.load('file:///Users/dospina/Documents/Nestor/credit.csv', format="com.databricks.spark.csv", header="true", inferSchema = "true")

total = credit.count()
print(total)

#Gini JUST BGI
credit.sort(credit.BGI).groupBy('BGI').count().show()
x = credit.sort(credit.BGI).groupBy('BGI').count().collect()
summ = 0
dic = dict()
for item in x:
    xi = item['BGI']
    xii = item['count']
    print('BGI', xi, xii)
    print(xii/float(total))
    dic[xi] = dic.get(xi, xii)


for column in credit.columns:
    print ('======= NEW LOOP ======')
    if not (column == "EDUCATION" or column == "SEX" or column == "MARRIAGE"): continue
    y = credit.sort(column).groupBy(column, 'BGI').count().collect()
    credit.sort(column).groupBy(column, 'BGI').count().show()
    psum = 0
    dic0 = dict()
    dic1 = dict()
    for item in y:
        yi = item['BGI']
        zi = item[column]
        yii = item['count']
        if yi == 0:
            print(column, 'BGI', yi, yii)
            print(yii/float(dic[0]))
            dic0[zi] = dic0.get(zi, yii/float(dic[0]))
        if yi == 1:
            print(column, 'BGI', yi, yii)
            print(yii/float(dic[1]))
            dic1[zi] = dic1.get(zi, yii/float(dic[1]))
        for ky0 in dic0:
            for ky1 in dic1:
                print(ky0, ky1)
                if ky0 == ky1:
                    print('resta', dic0[ky0] - dic1[ky1])
                    print('ln', math.log(dic0[ky0]/dic1[ky1]))
                    print('resta - ln', (dic0[ky0] - dic1[ky1])*math.log(dic0[ky0]/dic1[ky1]))
                    psum = psum + (dic0[ky0] - dic1[ky1])*math.log(dic0[ky0]/dic1[ky1])
    print('psum', psum)
