#learning_mllib2.py
pyspark --packages com.databricks:spark-csv_2.10:1.2.0

from pyspark.sql import SQLContext
from pyspark.sql.types import *
from pyspark.ml.classification import LogisticRegression
from pyspark.ml import Pipeline
from pyspark.ml.feature import StringIndexer
from pyspark.ml.feature import VectorAssembler
from pyspark.ml.evaluation import BinaryClassificationEvaluator

sqlContext = SQLContext(sc)
credit = sqlContext.read.load('file:///Users/dospina/Documents/Nestor/credit.csv', format="com.databricks.spark.csv", header="true", inferSchema = "true")
credit = credit.dropna()
df = credit

x = df.collect()
y = credit.collect()

x[:10]
y[:10]

for line in x[:10]:
    print(line)
    print(" ")

for line in y[:10]:
    print(line)
    print(" ")

for line, item in zip(x[:10], y[:10]):
    print(line == item)

for rowc, rowdf in zip(x[:60], y[:60]):
    for item1, item2 in zip(rowc, rowdf):
        print(item1, item2)
        print(item1 == item2)
    print("Next row")

numeric_cols = ["ID", 'LIMIT_BAL', 'AGE',
            'PAY_0', 'PAY_2', 'PAY_3', 'PAY_4', 'PAY_5', 'PAY_6',
            'BILL_AMT1', 'BILL_AMT2', 'BILL_AMT3', 'BILL_AMT4', 'BILL_AMT5',
            'BILL_AMT6', 'PAY_AMT1', 'PAY_AMT2', 'PAY_AMT3', 'PAY_AMT4',
            'PAY_AMT5', 'PAY_AMT6']

numeric_cols = ["SEX", "EDUCATION",  "MARRIAGE",
                "LIMIT_BALC", "AGEC", "PAY_0C",
                "PAY_2C", "PAY_3C", "PAY_4C",
                "PAY_5C", "PAY_6C", "BILL_AMT1C",
                "BILL_AMT2C", "BILL_AMT3C",
                "BILL_AMT4C", "BILL_AMT5C",
                "BILL_AMT6C", "PAY_AMT1C",
                "PAY_AMT2C", "PAY_AMT3C",
                "PAY_AMT4C", "PAY_AMT5C", "PAY_AMT6C"]

label_indexer = StringIndexer(inputCol = 'BGI', outputCol = 'label')

assembler = VectorAssembler(
    inputCols = numeric_cols,
    outputCol = 'features')

classifier = LogisticRegression(labelCol = 'label', featuresCol = 'features')
pipeline = Pipeline(stages = [label_indexer,assembler, classifier])
(train, test) = credit.randomSplit([0.7, 0.3])
model = pipeline.fit(df)

#el modelo no va a correr si la base tiene missing values
#acontinuacion se hace la base sin missing

#evaluacion del modelo, si AURCO es mas 0.8 crack!
predictions = model.transform(credit)
evaluator = BinaryClassificationEvaluator()
auroc = evaluator.evaluate(predictions, {evaluator.metricName: 'areaUnderROC'})
aupr = evaluator.evaluate(predictions, {evaluator.metricName: 'areaUnderPR'})
"The AUROC is %s and the AUPR is %s." % (auroc, aupr)

#'The AUROC is 0.644637324339 and the AUPR is 0.337484991392.'


x = predictions.select(predictions.probability, predictions.ID).collect()
x0 = list()
x1 = list()
superx = list()
for index in range(len(x)):
    superx.append((float(x[index][0][0]), float(x[index][0][1]), int(x[index][1])))


rdd = sc.parallelize(superx)
schema = StructType([
    StructField("p0", FloatType(), True),
    StructField("p1", FloatType(), True),
    StructField("ID", IntegerType(), True)])
probs = sqlContext.createDataFrame(rdd, schema)
probs.show()

output = predictions.join(probs,['ID'],"outer")
output.select(output.probability, output.p0, output.p1).show()

output.select(output.prediction).groupBy(output.prediction).count().show()
