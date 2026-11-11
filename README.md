# Taxation, Automation and Structural Change — Quantitative Macroeconomics in MATLAB

> Master's degree group project — *N.F. and co-authors*
> All rights reserved. See `LICENSE` for details.

---

## Overview

Two exercises, solved in MATLAB:

1. **Tax labor, or tax the robots?** A steady-state growth model with endogenous labor and a productive public good financed by taxes on capital and labor. We look for the welfare-maximizing tax rates, compare a worker and a capitalist, and redo everything after automation raises the capital share (θ from 0.33 to 0.40).
2. **Richer, or pricier?** A two-sector model (goods and services) with a subsistence term on goods, calibrated jointly on **India (1980–2019)** and **Sri Lanka (1983–2001)**: four moments pin down four parameters, the years in between are used as a test, and the rise of services is split into an income effect and a relative-price effect.

The full write-up is in [`report/problem_set_2_report.pdf`](report/problem_set_2_report.pdf).

---

## Project Structure

```
.
├── ex1/
│   ├── ex1_steady_state_ps.m   # Function: steady state for given theta and tax rates
│   ├── ex1d_ps.m               # One tax at a time
│   ├── ex1e_ps.m               # Both taxes together
│   ├── ex1g_ps.m               # Preferred capital tax: worker vs capitalist
│   ├── ex1i_ps.m               # Which tax does the worker prefer?
│   ├── ex1j_ps.m               # Automation: before vs after
│   └── ex1k_ps.m               # Worker's labor tax with a capital tax in the background
├── ex2/
│   ├── ex2_ps.m                # Main script for Exercise 2
│   ├── share_model.m           # Function: services share in the model
│   ├── calib2.m                # Function: calibration equations for fsolve
│   └── PS2_Ex2_data.csv        # Data
├── report/problem_set_2_report.pdf
└── figures/
```

---

## Exercise 1 — Tax labor, or tax the robots?

![One tax at a time](figures/one_tax_at_a_time.png)

Each tax is chosen on a grid from 0.1% to 90% to maximize steady-state welfare, with hours free to respond.

| | θ = 0.33 | θ = 0.40 (automation) |
|---|---|---|
| Household: optimal capital tax | 26.3% | 20.9% |
| Household: optimal labor tax | 22.3% | 22.9% |
| Worker: preferred capital tax | 28.9% | 23.1% |
| Worker: preferred labor tax | 20.0% | 20.0% |

- With both taxes available, the best pair is **no capital tax and a 22.3% labor tax**: taxing labor gives higher welfare.
- The capitalist prefers a much lower capital tax than the worker (13.4% against 28.9%).
- After automation the capital share grows, and the capital tax the worker wants falls.

Every script has `theta = 0.33` at the top; set it to `0.40` and run again to see the economy after automation.

## Exercise 2 — Richer, or pricier?

The share of services in spending depends on income w and on the relative price of services p. The four parameters (two weights, the substitution parameter ρ and the subsistence level on goods m̄) are pinned down by the first and last year of each country:

| Parameter | b (India) | b (Sri Lanka) | ρ | ε | m̄ |
|---|---|---|---|---|---|
| Value | 0.096 | 0.313 | −2.674 | 0.272 | 0.694 (≈ 1.90 $ per person per day) |

![Services share: model vs data](figures/services_share_model_vs_data.png)

The years in between are a test: the error is 2.2 points for India and 1.0 for Sri Lanka, with the model a bit above the data in almost every year.

**Richer, or pricier?** Splitting the rise in the services share (log change × 100):

| | Change | Price effect | Income effect |
|---|---|---|---|
| India 1980–2019 | 41.6 | −7.4 | 49.0 |
| Sri Lanka 1983–2001 | 16.6 | 7.7 | 8.9 |

In India the rise of services is all about income: services became relatively cheaper, which on its own would have pushed their share down. In Sri Lanka the two forces count about the same.

---

## Requirements

- MATLAB R2020a or later, with the Optimization Toolbox (`fsolve`)

## Usage

Open the `ex1` or `ex2` folder in MATLAB and run any script. Figures stay on screen; results are printed in the Command Window.

---

## License

This project is protected by copyright. See the [`LICENSE`](LICENSE) file for full terms.
**Reusing, copying, modifying, or redistributing** the code without explicit written permission from the authors is not permitted.
