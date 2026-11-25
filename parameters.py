'''
Model parameters used in the manuscript.

approaches  : goal (approach) model fitted to Fajen & Warren (2003) Exp 1a
              (Fajen_steer1a); held fixed for all avoidance simulations.
avoidances  : collision-avoidance models fitted to all participants of
              Experiment 1 (Cohen_movObst1) and Experiment 2 (Cohen_movObst2).
              cohen_avoid  = omniscient model (Equation 1, obstacle distance)
              cohen_avoid2 = visual model     (Equation 2, optical expansion)
              Key -1obst_onset = fit to all subjects, simulated from obstacle onset.
              Comment above each entry: mean distance error (m) and passing-order accuracy.
model_bounds: parameter bounds used by fitting.py (differential evolution).
'''

# Goal (approach) model
approaches = {}
approaches['Fajen_steer1a'] = {'fajen_approach': {}}
approaches['Fajen_steer1a']['fajen_approach']['differential_evolution'] = {}
approaches['Fajen_steer1a']['fajen_approach']['differential_evolution'][-1] = {'name': 'fajen_approach', 'b1':2.01938384, 'k1':4.90527274, 'c1':2.96094879, 'c2':0.50896525, 'k2':1.61216734}


# Parameter boundaries for fitting
model_bounds = {}
model_bounds['fajen_approach'] = [(0, 10), (0, 20), (0, 5), (0, 5), (0, 5)]
model_bounds['cohen_avoid'] = [(0, 50), (0, 800), (0.1, 20), (0.1, 10), (0, 50), (0, 800), (0.1, 10), (0.1, 10)]
model_bounds['cohen_avoid2'] = [(0, 50), (0, 800), (0.1, 10), (1, 30), (0, 50), (0, 800), (0.1, 10), (1, 30)]


# Fitted avoidance models
avoidances = {}
avoidances['Cohen_movObst1'] = {'cohen_avoid': {}, 'cohen_avoid2': {}}
avoidances['Cohen_movObst2'] = {'cohen_avoid': {}, 'cohen_avoid2': {}}

avoidances['Cohen_movObst1']['cohen_avoid']['differential_evolution'] = {}
# 0.19077652321401395 order_accuracy 0.84321608040201
avoidances['Cohen_movObst1']['cohen_avoid']['differential_evolution']['-1obst_onset'] = {'name': 'cohen_avoid', 'b1': 0.8093007767780838, 'k1': 374.53835960146876, 'c5': 11.763605885702065, 'c6': 1.0266683672796317, 'b2': 0.0, 'k2': 593.7861081468136, 'c7': 9.55544925847897, 'c8': 2.05798599654717}

avoidances['Cohen_movObst1']['cohen_avoid2']['differential_evolution'] = {}
# 0.1901285989843772 order_accuracy 0.8412060301507538
avoidances['Cohen_movObst1']['cohen_avoid2']['differential_evolution']['-1obst_onset'] = {'name': 'cohen_avoid2', 'b1': 1.2349633158265405, 'k1': 128.80418613005364, 'c5': 9.75076347435121, 'c6': 8.160165995185125, 'b2': 0.0, 'k2': 9.751939026529449, 'c7': 10.0, 'c8': 20.31149333769062}

avoidances['Cohen_movObst2']['cohen_avoid']['differential_evolution'] = {}
# 0.2492772784952851 order_accuracy 0.7897142857142857
avoidances['Cohen_movObst2']['cohen_avoid']['differential_evolution']['-1obst_onset'] = {'name': 'cohen_avoid', 'b1': 3.363638816353943, 'k1': 95.09517044816117, 'c5': 11.400136527121575, 'c6': 0.48808376780737783, 'b2': 0.0, 'k2': 594.7235062798342, 'c7': 4.535696669262642, 'c8': 3.777451780362486}

avoidances['Cohen_movObst2']['cohen_avoid2']['differential_evolution'] = {}
# 0.24663529940417053 order_accuracy 0.7851428571428571
avoidances['Cohen_movObst2']['cohen_avoid2']['differential_evolution']['-1obst_onset'] = {'name': 'cohen_avoid2', 'b1': 3.3485438586491, 'k1': 119.59655224362285, 'c5': 8.320041684111693, 'c6': 9.59390592684502, 'b2': 0.0, 'k2': 16.022521094515888, 'c7': 3.714647768807139, 'c8': 3.971298762659632}
