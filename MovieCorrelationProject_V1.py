import pandas as pd
import numpy as np
import seaborn as sns

import matplotlib.pyplot as plt
import matplotlib.mlab as mlab
import matplotlib
plt.style.use('ggplot')
from matplotlib.pyplot import figure
from scipy.stats import kendalltau

matplotlib.rcParams['figure.figsize'] = (12,8)

file_path = r'C:\Users\keung\Downloads\movies.csv'
df = pd.read_csv(file_path)
# print(df.head())

# Option to allow scrolling through all data
pd.set_option('display.max_rows', None)

# Drop missing data
df = df.dropna()

# Check that there are no empty values in each column
for col in df.columns:
    pct_missing = np.mean(df[col].isnull())
    # print('{} - {}%'.format(col, round(pct_missing*100)))

# Data types for columns
# print(df.dtypes)
df['budget'] = df['budget'].astype('int64')
df['gross'] = df['gross'].astype('int64')

# Create corrected year column using regex expression to extract 4 consecutive digits
df['CorrectedYear'] = df['released'].str.extract(pat='([0-9]{4})').astype(int)
# print(df['CorrectedYear'])

df = df.sort_values(by=['gross'], inplace=False, ascending=False)

# Drop any duplicates
df = df.drop_duplicates()

plt.scatter(x=df['budget'], y=df['gross'])
plt.title('Budget vs Gross Earnings')
plt.xlabel('Film Budget')
plt.ylabel('Gross')
# Plot budget vs gross using seaborn
# sns.regplot(x='budget', y='gross', data=df, scatter_kws={"color": "red"}, line_kws={"color": "blue"})
# plt.show()

# Budget Correlation to Gross
numeric_columns = df.select_dtypes(include=[np.number]).columns
correlation_matrix = df[numeric_columns].corr(method='spearman')
# print(correlation_matrix)

sns.heatmap(correlation_matrix, annot=True)
plt.title('Correlation Matrix')
plt.xlabel('Movie Feature')
plt.ylabel('Movie Feature')
plt.show()

# High correlation between budget/votes and gross as seen in the heatmap




