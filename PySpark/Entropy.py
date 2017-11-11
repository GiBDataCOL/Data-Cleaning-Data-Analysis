#Entropy V2
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

credit.sort(credit.BGI).groupBy('BGI').count().show()
x = credit.sort(credit.BGI).groupBy('BGI').count().collect()
ebgi = 0
for item in x:
    xi = item['BGI']
    xii = item['count']
    print('BGI', xi, xii)
    print(xii/float(total))
    pBGI = xii/float(total)
    print(-pBGI*(math.log(pBGI, 2)))
    ebgi = ebgi + (-pBGI*(math.log(pBGI, 2)))
print('ENTROPY','BGI', ebgi)

#ENTROPY
for column in credit.columns:
    print ('======= NEW LOOP ======')
    if not (column == "EDUCATION" or column == "SEX" or column == "MARRIAGE"): continue
    x = credit.sort(column).groupBy(column).count().collect()
    credit.sort(column).groupBy(column).count().show()
    wasum = 0
    for item in x:
        xi = item[column]
        xii = item['count']
        print(column, xi, xii)
        print(xii/float(total))
        y = credit.sort(column).groupBy(column, 'BGI').count().collect()
        credit.sort(column).groupBy(column, 'BGI').count().show()
        esum = 0
        for item in y:
            yi = item[column]
            yii = item['count']
            if not xi == yi: continue
            print(column, 'BGI', yi, yii)
            print(yii/float(xii))
            pi = yii/float(xii)
            print(-pi*(math.log(pi, 2)))
            pilog2 = (-pi*(math.log(pi, 2)))
            esum = esum + pilog2
        print ('esum', esum)
        print ('Waveg', (xii/float(total))*esum)
        wasum = wasum + (xii/float(total))*esum
    print ('wasum', wasum)
    print ('difentropy', ebgi-wasum )

#Best =  higher difentropy = lower wasum
