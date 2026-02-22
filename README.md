# EEG-Creativity-Analysis

This repository contains the analysis code and results for a study exploring **human creativity and AI attention patterns** during divergent and evaluative creative tasks. The project includes EEG data analysis and Python-based AI attention analysis.

---

## Project Overview

The study investigates three phases of creativity:

1. **IDG** – Idea Generation  
2. **IDE** – Idea Evolution  
3. **IDR** – Idea Evaluation  

We analyzed:

- **EEG recordings** to measure alpha and beta power across tasks, including regional analyses (frontal vs parietal).  
- **AI attention patterns** using GPT-2 to simulate creative interpretation and critique.

---

## Repository Structure


EEG-Creativity-Analysis/
├─ MATLAB/
│ ├─ eeg_beta_analysis.m # EEG alpha/beta power computation and statistical analysis
│ └─ Frontal_Parietal_Analysis.m # Regional analysis (frontal vs parietal) of EEG data
├─ Python/
│ ├─ Visual_AI_Attention_Analysis.py # Generates attention maps and difference maps for AI tasks
│ └─ Quantitative_AI_Attention_Analysis.py # Performs statistical analysis on AI attention matrices
├─ Figures/
│ ├─ Mean_alpha_power.png
│ ├─ Mean_beta_power.png
│ ├─ IDG.png
│ ├─ IDE.png
│ ├─ IDR.png
│ ├─ Difference-IDE-IDG.png
│ ├─ Difference-IDR-IDE.png
│ └─ Difference-IDR-IDG.png
└─ README.md


---

## MATLAB Analysis (EEG)

**Scripts:**

- `eeg_beta_analysis.m`  
  - Computes alpha (8–12 Hz) and beta (13–30 Hz) power for each subject across tasks.  
  - Calculates mean, standard deviation, and standard error for each task.  
  - Performs repeated-measures ANOVA and pairwise t-tests to evaluate task differences.  
  - Visualizes results with bar plots and error bars.  

- `Frontal_Parietal_Analysis.m`  
  - Compares frontal and parietal beta power across tasks.  
  - Generates regional bar plots to highlight task-specific cortical engagement.  

**Figures:**

- `Mean_alpha_power.png` – Mean alpha power across IDG, IDE, IDR tasks.  
- `Mean_beta_power.png` – Mean beta power across IDG, IDE, IDR tasks.

---

## Python Analysis (AI Attention)

**Scripts:**

- `Visual_AI_Attention_Analysis.py`  
  - Generates attention maps for each AI task (IDG, IDE, IDR).  
  - Produces difference maps highlighting attention shifts between tasks.  

- `Quantitative_AI_Attention_Analysis.py`  
  - Performs Kruskal-Wallis non-parametric ANOVA on attention matrices.  
  - Conducts post-hoc Dunn’s test to identify significant pairwise differences.  

**Figures:**

- `IDG.png, IDE.png, IDR.png` – Individual attention maps for each creative phase.  
- `Difference-IDE-IDG.png, Difference-IDR-IDE.png, Difference-IDR-IDG.png` – Difference maps highlighting AI attention changes between tasks.

---

## How to Use

1. **EEG Analysis (MATLAB)**  
   - Place EEG `.mat` files for each subject in the MATLAB working directory.  
   - Run `eeg_beta_analysis.m` and/or `Frontal_Parietal_Analysis.m` to reproduce analysis and plots.  

2. **AI Attention Analysis (Python)**  
   - Install Python 3.x and required libraries:  
     ```bash
     pip install transformers torch numpy matplotlib scikit_posthocs
     ```  
   - Run `Visual_AI_Attention_Analysis.py` to generate attention maps.  
   - Run `Quantitative_AI_Attention_Analysis.py` to perform statistical analyses on AI attention matrices.

---

## Notes

- EEG raw data is **not included** to protect participant privacy.  
- Figures are provided to illustrate results.  
- Repository structure separates MATLAB (EEG) and Python (AI) analyses for clarity.

---

## References

- GPT-2: Radford et al., 2019, OpenAI  
- MATLAB bandpower and EEG analysis documentation  
- Torrance Test of Creative Thinking (TTCT) paradigms
