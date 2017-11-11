#Analisis Univariado V3

packages
pyspark --packages com.databricks:spark-csv_2.10:1.2.0
import numpy as np
import pandas as pd
import plotly
import csv
import math
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
import plotly.plotly as py
import plotly.graph_objs as go
from pyspark.sql.functions import *


from pyspark import SparkContext

import pyspark.sql
from pyspark.sql import types
from pyspark.sql.types import *
from pyspark.sql.types import StringType
from pyspark.sql.types import DoubleType
from pyspark.sql.types import TimestampType
from pyspark.sql.types import NullType
from pyspark.sql.types import IntegerType
from pyspark.sql.types import StructType
from pyspark.sql.types import StructField
from pyspark.sql import functions as F
import pyspark.sql.functions
import pyspark.sql.dataframe

from pyspark.sql import Row
from pyspark.sql import SQLContext

sc = SparkContext()
sqlContext = SQLContext(sc)
credit = sqlContext.read.load('file:///Users/dospina/Documents/Nestor/credit.csv', format="com.databricks.spark.csv", header="true", inferSchema = "true")
credit = sqlContext.read.format("com.databricks.spark.csv").option("header", "true").option("inferSchema", "true").load("/Users/dospina/Documents/Nestor/credit.csv")

from pyspark.sql.functions import lit
creditnc = credit.withColumn("x4", lit(credit.BGI))
changedTypedf = creditnc.withColumn("x4", creditnc["x4"].cast("string"))
diz = {"1": "malo", "0": "bueno"}
df2 = changedTypedf.na.replace(diz,1,"x4")
df2.groupBy("x4").count().show()

credittext = sc.textFile("file:///Users/dospina/Documents/Nestor/credit.csv")
auction = credittext.map(lambda x: x.split(','))
auction.take(1)
ebay = ebayText.map(_.split(",")).map(p => Auction(p(0), p(1).toFloat, p(2).toFloat, p(3), p(4).toInt, p(5).toFloat, p(6).toFloat, p(7), p(8).toInt))


marriage_0 = people.filter(lambda x :(x[5]))


from pyspark.sql.types import StructType
from pyspark.sql.types import StructField
from pyspark.sql.types import StringType
from pyspark.sql import Row

rdd_of_rows = credittext.map(lambda x: Row(**x))

credit = sqlContext.createDataFrame(credittext, credit_schema)
credit_schema = StructType([
 StructField('ID', StringType(), True),
 StructField('LIMIT_BAl', StringType(), True),
 StructField('SEX', StringType(), True),
 StructField('EDUCATION', StringType(), True),
 StructField('MARRIAGE', StringType(), True),
 StructField('AGE', StringType(), True),
 StructField('PAY_0', StringType(), True),
 StructField('PAY_2', StringType(), True),
 StructField('PAY_3', StringType(), True),
 StructField('PAY_4', StringType(), True),
 StructField('PAY_5', StringType(), True),
 StructField('PAY_6', StringType(), True),
 StructField('BILL_AMT1', StringType(), True),
 StructField('BILL_AMT2', StringType(), True),
 StructField('BILL_AMT3', StringType(), True),
 StructField('BILL_AMT4', StringType(), True),
 StructField('BILL_AMT5', StringType(), True),
 StructField('BILL_AMT6', StringType(), True),
 StructField('PAY_AMT1', StringType(), True),
 StructField('PAY_AMT2', StringType(), True),
 StructField('PAY_AMT3', StringType(), True),
 StructField('PAY_AMT4', StringType(), True),
 StructField('PAY_AMT5', StringType(), True),
 StructField('PAY_AMT6', StringType(), True),
 StructField('BGI', StringType(), True),
])

#VARIABLES CATEGORICAS
credit.groupBy('SEX').count().show()
credit.groupBy('EDUCATION').count().show()
credit.groupBy('MARRIAGE').count().show()
credit.groupBy('BGI').count().show()

for column in credit.columns:
    credit.groupBy(column).count().show()

credit.filter(credit.PAY_AMT3 ==  1831).count()
credit.groupBy(credit.PAY_AMT3 ==  1831).count()
dir(credit.filter(credit.PAY_AMT3 ==  1831))
help(credit.filter(credit.PAY_AMT3 ==  1831).drop)
x = credit.filter(credit.PAY_AMT3 ==  1831).collect()
for val in x:
    print (val)


credit.registerTempTable("ok")
sqlContext.sql("SELECT SEX, COUNT(*) FROM ok GROUP BY SEX").withColumnRenamed('_c1', 'count').show()

plotly.tools.set_credentials_file(username='DavidOspinaPiedrahita', api_key='BpOE099qRC6U4gArE6Jv')
df = pd.read_csv("\Users\dospina\Documents\Nestor\credit.csv")
data = [go.Histogram(x= df['SEX'])]
url = py.plot(data, filename='SEX-frecuencies')
data = [go.Histogram(x= df['EDUCATION'])]
url = py.plot(data, filename='EDUCATION-frecuencies')
data = [go.Histogram(x= df['MARRIAGE'])]
url = py.plot(data, filename='MARRIAGE-frecuencies')
data = [go.Histogram(x= df['BGI'])]
url = py.plot(data, filename='BGI-frecuencies')


#SUMA, MAXIMOS, MINIMOS Y PERCENTILES
for column in credit.columns:
    credit.select(column).describe().show()

creditpd = credit.toPandas()
for column in credit.columns:
    lst = creditpd[column].tolist()
    print (column)
    print ((column),'percentile 10th, ', np.percentile(lst, 10))
    print ((column),'percentile 20th, ', np.percentile(lst, 20))
    print ((column),'percentile 30th, ', np.percentile(lst, 30))
    print ((column),'percentile 40th, ', np.percentile(lst, 40))
    print ((column),'percentile 50th, ', np.percentile(lst, 50))
    print ((column),'percentile 60th, ', np.percentile(lst, 60))
    print ((column),'percentile 70th, ', np.percentile(lst, 70))
    print ((column),'percentile 80th, ', np.percentile(lst, 80))
    print ((column),'percentile 90th, ', np.percentile(lst, 90))
    print ((column),'percentile 100th, ', np.percentile(lst, 100))

#MISSING VALUES
for column in credit.columns:
    print ((column), pd.isnull(creditpd[column]).sum())

pd.isnull(creditpd).sum()
credit.groupBy(credit.PAY_AMT3)
credit.select(credit.PAY_AMT3)
#FILLING MISSING VALUES WITH THE MEAN
credit = creditpd.fillna(creditpd.mean())

credit.select(credit.PAY_AMT3)
dir(credit.select(credit.PAY_AMT3))
credit.filter(credit.PAY_AMT3 != 1831)
credit.groupBy(credit.PAY_AMT3 == 1831).count().show()



x = credit.na.fill(None)
x.groupBy(x.PAY_AMT3 == 1234567).count().show()
y = x.filter(x.PAY_AMT3 == 1234567)

#VARIABILIDAD
#MAX == MIN
for column in credit.columns:
    credit.select(max(column)).show()
    credit.select(min(column)).show()
    print ('max == min', (column), credit.select(max(column)) == credit.select(min(column)))

#P1 == P99
for column in credit.columns:
    lst = creditpd[column].tolist()
    np.percentile(lst, 1)
    np.percentile(lst, 99)
    credit.drop(column)
    print('p1 == p99', (column), np.percentile(lst, 1) == np.percentile(lst, 99))

#P5 == P95
for column in credit.columns:
    lst = creditpd[column].tolist()
    np.percentile(lst, 5)
    np.percentile(lst, 95)
    print('p5 == p95', (column), np.percentile(lst, 5) == np.percentile(lst, 95))

#P10 == P90
for column in credit.columns:
    lst = creditpd[column].tolist()
    np.percentile(lst, 10)
    np.percentile(lst, 90)
    print('p10 == p90', (column), np.percentile(lst, 10) == np.percentile(lst, 90))

#P25 == P75
for column in credit.columns:
    lst = creditpd[column].tolist()
    np.percentile(lst, 25)
    np.percentile(lst, 75)
    print('p25 == p75', (column), np.percentile(lst, 25) == np.percentile(lst, 75))
#ACA TERMINA EN ANALISIS UNIVARIADO

#ANALISIS BIVARIADO
credit.select(credit.SEX, credit.BGI).groupBy('SEX','BGI').count().show()
credit.select(credit.SEX, credit.BGI).groupBy('EDUCATION','BGI').count().show()

credit.groupBy('SEX','BGI').count().show()
credit.groupBy('EDUCATION','BGI').count().show()
credit.groupBy('MARRIAGE','BGI').count().show()

#describe can be safely convert to pandas and manipulate as wish
credit.describe().dtypes
credit.filter((credit.SEX == 1) & (credit.BGI== 1)).count()
credit.filter((credit.SEX == 1) & (credit.BGI== 0)).count()

credit.filter(credit.SEX == 1).filter(credit.BGI == 1).count()
credit.filter(credit.SEX == 1).filter(credit.BGI == 0).count()
credit.filter(credit.SEX == 2).filter(credit.BGI == 1).count()
credit.filter(credit.SEX == 2).filter(credit.BGI == 0).count()


data = [go.Histogram(x= df['AGE'])]
url = py.plot(data, filename='AGE-frecuencies', bins = 100)

data = [go.Histogram(x= credit.SEX)]
import plotly.plotly as py
import plotly.graph_objs as go
import numpy as np

trace1 = go.Histogram(x = df['BILL_AMT1'], opacity=0.75)
trace2 = go.Histogram(x = df['BILL_AMT2'], opacity=0.75)
trace3 = go.Histogram(x = df['BILL_AMT3'], opacity=0.75)
trace4 = go.Histogram(x = df['BILL_AMT4'], opacity=0.75)
trace5 = go.Histogram(x = df['BILL_AMT5'], opacity=0.75)
trace6 = go.Histogram(x = df['BILL_AMT6'], opacity=0.75)

data = [trace1, trace2, trace3, trace4, trace5, trace6]
layout = go.Layout(barmode='stack')
fig = go.Figure(data=data, layout=layout)
url = py.plot(data, filename='AGE-frecuencies')

iplot(kind='histogram', barmode='stack', bins=100, histnorm='probability', filename='cufflinks/histogram-binning')



#filosofia
from pyspark.sql import Row

x = credit.select(credit.BGI, credit.AGE, credit.SEX, credit.EDUCATION)
x = x.collect()

rdd = sc.parallelize(x)

y = rdd.map(lambda z: tuple([str(x) for x in z]))
print (y.take(3))


b = rdd.map(lambda line: tuple([int(x) for x in line]))
print b.take(3)















y = credit.map(lambda row: [str(c) for c in row])
y1 = y.collect()
lst = list()
for lista in y1:
    lst1 = list()
    for value in lista[1:]:
        lst1.append(int(value))
    y2 = [lista[0], max(lst1)]
    lst.append(y2)
