pyspark --packages com.databricks:spark-csv_2.10:1.2.0

sqlContext = SQLContext(sc)
credit = sqlContext.read.load('file:///Users/dospina/Documents/Nestor/credit.csv', format="com.databricks.spark.csv", header="true", inferSchema = "true")

from pyspark.sql.functions import min

lst = list()
for column in credit.columns:
    print(column)
    x = credit.select(min(column)).collect()
    credit.select(min(column)).show()
    if x[0][0] < 0:
        lst.append(column)

for column in lst:
    x = credit.filter((credit[column] < 0)).count()
    print("la columna " + str(column) + " tiene " + str(x) + " valores negativos")

#CREAR UN DATAFRAME
from pyspark.sql import Row
from pyspark.sql.types import *


l = list()
for column in lst:
    x = credit.filter((credit[column] < 0)).count()
    print("la columna " + str(column) + " tiene " + str(x) + " valores negativos")
    x = (str(column), int(x))
    l.append(x)

sqlContext.createDataFrame(l).show()
rdd = sc.parallelize(l)
schema = StructType([
    StructField("campo", StringType(), True),
    StructField("cantidad_missing", IntegerType(), True)])
df3 = sqlContext.createDataFrame(rdd, schema)
df3.show()





#CREAR UN DATAFRAME
l = [('Alice', 1)]
sqlContext.createDataFrame(l).show()
sqlContext.createDataFrame(l, ['name', 'age']).show()
#d = [{'name': 'Alice', 'age': 1}]
#sqlContext.createDataFrame(d).show()
rdd = sc.parallelize(l)
#sqlContext.createDataFrame(rdd).show()
#df = sqlContext.createDataFrame(rdd, ['name', 'age'])
#df.show()

from pyspark.sql import Row
Person = Row('name', 'age')
person = rdd.map(lambda r: Person(*r))
#df2 = sqlContext.createDataFrame(person)
#df2.show()

from pyspark.sql.types import *
schema = StructType([
    StructField("campo", StringType(), True),
    StructField("cantidad_missing", IntegerType(), True)])
df3 = sqlContext.createDataFrame(rdd, schema)
df3.show()


sqlContext.createDataFrame(df.toPandas()).collect()
sqlContext.createDataFrame(pandas.DataFrame([[1, 2]])).collect()
