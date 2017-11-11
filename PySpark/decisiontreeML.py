pyspark --packages com.databricks:spark-csv_2.10:1.2.0

from pyspark.sql import SQLContext
from pyspark.sql.types import *
from pyspark.ml.classification import DecisionTreeClassifier
from pyspark.ml import Pipeline
from pyspark.ml.feature import StringIndexer
from pyspark.ml.feature import VectorAssembler
from pyspark.ml.evaluation import BinaryClassificationEvaluator
from pyspark.ml import Pipeline
from pyspark.ml.classification import DecisionTreeClassifier
from pyspark.ml.feature import StringIndexer, VectorIndexer
from pyspark.ml.evaluation import MulticlassClassificationEvaluator
from pyspark.mllib.util import MLUtils
from pyspark.sql.functions import when
from pyspark.sql.functions import sum
from pyspark.sql.functions import col
from pyspark.sql.functions import max
from pyspark.sql.functions import min
from pyspark.sql.functions import concat
from pyspark.sql.functions import lit
from functools import reduce
from pyspark.sql import DataFrame
import re

sqlContext = SQLContext(sc)
credit = sqlContext.read.load('file:///Users/dospina/Documents/Nestor/credit.csv', format="com.databricks.spark.csv", header="true", inferSchema = "true")
credit = credit.dropna()

numeric_cols = ["BILL_AMT6"]

label_indexer = StringIndexer(inputCol = 'BGI', outputCol = 'label')

assembler = VectorAssembler(
    inputCols = numeric_cols,
    outputCol = 'features')


classifier = DecisionTreeClassifier(maxDepth = 3, labelCol = 'label', featuresCol = 'features')
pipeline = Pipeline(stages = [label_indexer,assembler, classifier])
(train, test) = credit.randomSplit([0.7, 0.3])
model = pipeline.fit(train)

lst = list()
x = model.stages[2]._call_java('toDebugString')
y = x.split("\n")
for line in y:
    aja = re.findall(".+feature.+[<>].+?([0-9].+)", line)
    if len(aja) != 0:
        aja2 = str(aja[0][:len(aja[0])-1])
        if not float(aja2) in lst:
            lst.append(float(aja2))

lst1 = sorted(lst)
lst2 = list()
for index in range(len(lst1)):
    if index == 0:
        print("x <= " + str(lst1[index]))
        lst2.append("x <= " + str(lst1[index]))
    else:
        print((str(lst1[index - 1]) + " < x <= " + str(lst1[index])))
        lst2.append(str(lst1[index - 1]) + " < x <= " + str(lst1[index]))
    if index == len(lst1) - 1:
        print("x > " + str(lst1[index]))
        lst2.append("x > " + str(lst1[index]))

lst3 = list()
for index in range(len(lst2)):
    lst3.append("AGE"+str(index))

df = credit
for index in range(len(lst1)):
    print(index)
    if index == 0:
        df = df.withColumn(lst3[index], when(col("AGE") <= lst1[index], lst2[index]).otherwise(col("AGE")))
    else:
        df = df.withColumn(lst3[index], when(((lst1[index-1] < df["AGE"]) & (df["AGE"] <= lst1[index])), lst2[index]).otherwise(col(lst3[index-1])))
    if index == len(lst1)-1:
        df = df.withColumn(lst3[index+1], when(col("AGE") > lst1[index], lst2[index+1]).otherwise(col(lst3[index])))


df = df.withColumnRenamed(lst3[-1], "AGEC")
df = reduce(DataFrame.drop, lst3, df)

df.groupBy(df.AGEC).count().show()
df.select(df.AGE, df.AGEC).show()


lst = list()
x = model.stages[2]._call_java('toDebugString')
y = x.split("\n")
for line in y:
    aja = re.findall(".+feature\s[0-9].+\s(.+)", line)
    if len(aja) != 0:
        aja2 = str(aja[0][:len(aja[0])-1])
        if not float(aja2) in lst:
            lst.append(float(aja2))

lst1 = sorted(lst)
lst2 = list()
for index in range(len(lst1)):
    if index == 0:
        print("x <= " + str(lst1[index]))
        lst2.append("x <= " + str(lst1[index]))
    else:
        print((str(lst1[index - 1]) + " < x <= " + str(lst1[index])))
        lst2.append(str(lst1[index - 1]) + " < x <= " + str(lst1[index]))
    if index == len(lst1) - 1:
        print("x > " + str(lst1[index]))
        lst2.append("x > " + str(lst1[index]))
