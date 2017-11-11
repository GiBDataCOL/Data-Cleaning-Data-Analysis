#Learning plotly
import plotly
plotly.tools.set_credentials_file(username='DavidOspinaPiedrahita', api_key='YwV3iYGRXfsCGCOaVmiU')


import plotly.plotly as py
from plotly.graph_objs import *
trace0 = Scatter(
    x=[1, 2, 3, 4],
    y=[10, 15, 13, 17]
)
trace1 = Scatter(
    x=[1, 2, 3, 4],
    y=[16, 5, 11, 9]
)
data = Data([trace0, trace1])

py.plot(data, filename = 'basic-line')

df = cf.datagen.lines()

py.iplot([{
    'x': df.index,
    'y': df[col],
    'name': col
}  for col in df.columns], filename='cufflinks/simple-line')


#El siguiente sirve
import plotly.plotly as py
import plotly.graph_objs as go

import pandas as pd
import numpy as np
df = pd.read_csv("\Users\dospina\Documents\Nestor\credit.csv")
data = [go.Histogram(x= df['SEX'])]
url = py.plot(data, filename='pandas-bar-chart')

data = [go.Histogram(x= df['EDUCATION'])]
url = py.plot(data, filename='pandas-bar-chart')

data = [go.Histogram(x= df['LIMIT_BAL'])]
url = py.plot(data, filename='pandas-bar-chart')

data = [go.Histogram(x= df['AGE'])]
url = py.plot(data, filename='pandas-bar-chart')
