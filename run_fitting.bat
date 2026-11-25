@echo off
REM Fit the two collision-avoidance models with differential evolution.
REM Run from the repository root with the Python environment activated.
REM Each fit opens in its own window and runs in parallel; fits take many hours.
REM Logs are written to results\fitting\<folder>; 02_model_simulation.ipynb reads
REM the cross-validation folders by these names.
REM   cohen_avoid  = omniscient model (Equation 1)
REM   cohen_avoid2 = visual model     (Equation 2)
REM The goal model (fajen_approach, fitted to Fajen_steer1a) is held fixed;
REM its parameters are in parameters.py.

set COMMON=--approach_experiment Fajen_steer1a --approach_model fajen_approach --t_start obst_onset --t_end obst_out --ps trial --method differential_evolution

REM ---- Fit to all subjects (Tables 1, 2, 4, 5) --------------------------------
FOR %%E IN (Cohen_movObst1 Cohen_movObst2) DO (
  FOR %%M IN (cohen_avoid cohen_avoid2) DO (
    start "%%E %%M all" cmd /k python fitting.py --experiment_name %%E --subject all --avoid_model %%M --training_model %%M %COMMON% --out_dir results\fitting\%%E_all_subjects_%%M_obst_onset
  )
)

REM ---- Leave-one-subject-out cross validation (Tables A1, A2) -----------------
REM A negative subject number means "fit to all subjects except this one".
REM Experiment 1 subject ids (no subject 9)
set SUBJS1=-1 -2 -3 -4 -5 -6 -7 -8 -10 -11 -12 -13 -14 -15
REM Experiment 2 subject ids
set SUBJS2=-1 -2 -3 -4 -5 -6 -7 -8 -9 -10 -11 -12 -13 -14 -15

FOR %%M IN (cohen_avoid cohen_avoid2) DO (
  FOR %%S IN (%SUBJS1%) DO (
    start "Exp1 %%M %%S" cmd /k python fitting.py --experiment_name Cohen_movObst1 --subject %%S --avoid_model %%M --training_model %%M %COMMON% --out_dir results\fitting\Cohen_movObst1_cross_validation_%%M_obst_onset
  )
  FOR %%S IN (%SUBJS2%) DO (
    start "Exp2 %%M %%S" cmd /k python fitting.py --experiment_name Cohen_movObst2 --subject %%S --avoid_model %%M --training_model %%M %COMMON% --out_dir results\fitting\Cohen_movObst2_cross_validation_%%M_obst_onset
  )
)
