from model import Situation, Model
import numpy as np
import math
import matplotlib.pyplot as plt
from scipy.optimize import linear_sum_assignment


c = [[0.7, 0.1, 0.1, 0.7, 0.4, 0.7, 0.6, 0.7, 0.8, 0.5],
        [0.9, 0.9, 0.8, 0.9, 0.8, 0.9, 0.6, 0.4, 0.3, 0.3],
		[0.3, 0.7, 0, 0.9, 0.1, 0.3, 0.6, 0.5, 0.4, 0.8],
        [0.1, 0.2, 0.9, 0.7, 0.6, 0.3, 0.6, 0.7, 0.5, 0.5],
        [ 0.8, 0.1, 0.6, 0.7, 0.4, 0.9, 0.4, 0.5, 0.7, 0.8],
        [0.2, 0.6, 0.1, 0.7, 0.5, 0.8, 0.9, 0.9, 0.5, 0.4],
        [0.4, 0.6, 0.7, 1, 0.4, 0.9, 1, 0.3, 0.4, 0.7],
        [0.7, 1, 0.4, 0, 0.5, 0.7, 0.4, 0.1, 0.3, 0.4],
        [0.1, 0.4, 0.3, 0.7, 0.5, 0, 0.5, 0.9, 0.8, 0.7],
        [0.6, 0.1, 0.3, 0.1, 0.7, 0.3, 0.5, 1, 0.9, 0]
     ]
superiority = np.array(c)
cost = np.max(superiority)-superiority
(row_ind, col_ind) = linear_sum_assignment(cost)
best_val = superiority[row_ind, col_ind].sum()
print(col_ind+1)
print(best_val)
print(superiority[row_ind, col_ind])

