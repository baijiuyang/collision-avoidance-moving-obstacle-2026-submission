# Collision avoidance with a moving obstacle: Anticipation without prediction

Analysis and modeling code for the article *Collision avoidance with a moving obstacle: Anticipation without prediction* (Bai, Cohen, Bruggeman & Warren), submitted to the *Journal of Experimental Psychology: General*.

The code fits and simulates behavioral-dynamics models of pedestrian collision avoidance with a moving obstacle:

* an **omniscient model** (Equation 1) whose avoidance response depends on obstacle distance (`cohen_avoid` in the code)
* a **visual model** (Equation 2) that replaces distance with the obstacle's rate of optical expansion (`cohen_avoid2`)

Each avoidance model is combined with a **goal model** (Equation 3, `fajen_approach`) whose parameters were fitted to Fajen and Warren's (2003) data and then held fixed. The code also analyzes the human trajectories (passing order, speed vs heading control, signed minimum predicted distance).

| Dataset name in the code | Manuscript |
|---|---|
| `Cohen_movObst1` | Experiment 1: obstacle speed and path angle (14 participants, 995 trials) |
| `Cohen_movObst2` | Experiment 2: collision point distance (15 participants, 875 trials) |
| `Fajen_steer1a` | Goal model data: Fajen & Warren (2003), Experiment 1a (8 participants, 640 trials) |

## Data

The data are **not** included in this repository. They are archived on Zenodo: **[DATA REPOSITORY LINK / DOI]**.

Download the three files (`Cohen_movObst1_rawData.csv`, `Cohen_movObst2_rawData.csv` and `F&W2003_Exp1a_rawData.zip`) into a folder named `data/` at the root of this repository, and unzip `F&W2003_Exp1a_rawData.zip` there. You should end up with:

```
data/
├── Cohen_movObst1_rawData.csv      # Experiment 1
├── Cohen_movObst2_rawData.csv      # Experiment 2
└── F&W2003_Exp1a_rawData/          # Fajen & Warren (2003), Exp. 1a: files sub0 ... sub7
```

To keep the data somewhere else, set the environment variable `MOVOBST_DATA_DIR` to that folder. All file locations are defined in [`config.py`](config.py).

## Requirements

* Python 3.6 with the packages in [`requirements.txt`](requirements.txt). The analyses were run with numpy 1.18.1, scipy 1.4.1, matplotlib 3.1.3, scikit-learn 0.24.2 and pandas 1.0.1. Later versions will probably work but have not been tested.
* R 4.2.0 with `lme4`, `car`, `dplyr`, `ggplot2`, `tidyverse` and `rstatix`.

```bash
conda create -n avoidance python=3.6
conda activate avoidance
pip install -r requirements.txt
```

Run all notebooks and scripts from the repository root.

## Workflow

| Step | File | What it does | Output |
|---|---|---|---|
| 1 | [`01_import_data.ipynb`](01_import_data.ipynb) | Reads the raw data. Filters trajectories (4th-order Butterworth, 0.6 Hz), computes velocities, preferred speed, obstacle onset and passing order, and excludes trials (tracking errors; slowest 1% of trials) | `data/processed/*.pickle` |
| 2 | [`run_fitting.bat`](run_fitting.bat) → [`fitting.py`](fitting.py) | Fits each avoidance model with differential evolution, to all participants and by leave-one-subject-out cross-validation. *Optional: the best-fit parameters are already in [`parameters.py`](parameters.py). Fitting takes many hours.* | `results/fitting/<run>/fitting_log_*.txt` |
| 3 | [`02_model_simulation.ipynb`](02_model_simulation.ipynb) | Simulates every trial with the best-fit models | distance error, passing-order accuracy, BIC, model passing order and SMPD; `results/Cohen_movObst*_CV_errors_obst_onset.csv` |
| 4 | [`simulate_pass_order_errors.py`](simulate_pass_order_errors.py) | Trial-by-trial model passing order and distance error for both models and both experiments | `results/Cohen_movObst*_simulation_pass_order_errors.csv` |
| 5 | [`03_human_data_analysis.ipynb`](03_human_data_analysis.ipynb) | Analyzes the human data: trajectories, speed vs heading control, passing order, SMPD | figures; `results/Cohen_movObst*_pass_order.csv`, `results/Cohen_movObst*_speed_heading_ctrl.csv` |
| 6 | [`stats/`](stats/) | Statistical tests in R, using the CSV files from steps 3 and 5 | test results; logistic-curve figures in `results/` |

`fitting.py` can also be run directly, for example:

```bash
python fitting.py --experiment_name Cohen_movObst1 --subject all --avoid_model cohen_avoid2 --training_model cohen_avoid2 \
  --approach_experiment Fajen_steer1a --approach_model fajen_approach --t_start obst_onset --t_end obst_out \
  --ps trial --method differential_evolution
```

`--subject -3` fits all participants except participant 3. That is one fold of the cross-validation.

## Where each result comes from

| Manuscript | Code |
|---|---|
| Goal model parameters (*Goal Model*) | `parameters.py`, `approaches['Fajen_steer1a']` |
| Data processing and trial exclusions | `01_import_data.ipynb` |
| Walking speed at obstacle onset; mean trajectories (Figs. 6, 14) | `03_human_data_analysis.ipynb` |
| Passing order by condition (Figs. 7a, 15a) | `03_human_data_analysis.ipynb` |
| Passing order: mixed-effects logistic regression, Type II Wald χ² | `stats/Exp1_logistic_switching_point.R` and `stats/Exp2_logistic_switching_point.R` (Section 1); the same models are in `stats/stats.R` |
| Switching points (continuous-predictor GLMM and logistic curves) | `stats/Exp*_logistic_switching_point.R` (Sections 2 and 2b); `stats/Exp*_continuous_centered.R` (same models with z-scored predictors) |
| Proportion and magnitude of speed vs heading control (Figs. 8, 9, 16, 17) | `03_human_data_analysis.ipynb` |
| Paired t-tests and LMEs on speed/heading control | `stats/stats.R` |
| Example model simulations (Figs. 10, 18) | `02_model_simulation.ipynb`, "Simulate one trial avoidance" |
| Best-fit parameters (Tables 1, 4) | `parameters.py`, `avoidances[...]['-1obst_onset']` |
| Distance error, passing-order accuracy, BIC (Tables 2, 5) | `02_model_simulation.ipynb`, "Simulate all trials"; `simulate_pass_order_errors.py` |
| Model passing order and switching points (Figs. 7b–c, 15b–c) | `02_model_simulation.ipynb`, passing-ratio heatmaps |
| Cross-validation errors (Tables A1, A2) and LME model comparison | `02_model_simulation.ipynb`, "Cross validation error"; `stats/stats.R`, "Model comparision lme" |
| Human SMPD (Fig. 11; Tables 3, 6) | `03_human_data_analysis.ipynb`, "Minimum Predicted Distance" |
| Model SMPD (Fig. 12; Tables 3, 6) | `02_model_simulation.ipynb`, "Minimum Passing Distance" |

## Repository structure

```
├── config.py                       # file locations (data, processed data, results)
├── 01_import_data.ipynb
├── 02_model_simulation.ipynb
├── 03_human_data_analysis.ipynb
├── fitting.py                      # model fitting (scipy.optimize.differential_evolution)
├── run_fitting.bat                 # launches all fits used in the manuscript (Windows)
├── parameters.py                   # best-fit model parameters and fitting bounds
├── simulate_pass_order_errors.py
├── packages/
│   ├── models.py                   # goal and avoidance models (fajen_approach, cohen_avoid, cohen_avoid2, ...)
│   ├── ode_simulator.py            # numerical integration of the models; error measures
│   ├── helper.py                   # optical/geometric variables, SMPD, plotting
│   └── data_container.py           # Data class; Butterworth filter
└── stats/
    ├── stats.R
    ├── Exp1_logistic_switching_point.R
    ├── Exp1_continuous_centered.R
    ├── Exp2_logistic_switching_point.R
    └── Exp2_continuous_centered.R
```

`packages/models.py` also contains model variants that were explored during development but are not reported in the manuscript. Only `fajen_approach`, `cohen_avoid` and `cohen_avoid2` are used here.

## Notes

* The notebooks use `%matplotlib qt` for interactive figures.
* The goal-model parameters were fitted with an earlier version of this code. `01_import_data.ipynb` prepares the `Fajen_steer1a` data, and the fitted values are stored in `parameters.py`.
* The *Control Strategy Comparisons* analysis (Figure 19) is not included in this repository.

## License

The code is released under the [MIT License](LICENSE). The data are not covered by this license; see the data repository for their terms.
