# EEG-Creativity-Analysis

This repository contains the analysis code and results for a study exploring **human creativity and AI attention patterns** during divergent and evaluative creative tasks. The project includes EEG data analysis of brain activity and Python-based AI attention analysis.

---

## Project Overview

The study investigates three phases of creativity:
1. **IDG** – Idea Generation  
2. **IDE** – Idea Evolution  
3. **IDR** – Idea Evaluation  

We analyzed:
- **EEG recordings** to measure alpha and beta power across tasks.  
- **AI attention patterns** using GPT-2 to simulate creative interpretation and critique.

---

## Repository Structure

EEG-Creativity-Analysis/
├─ MATLAB/
│ └─ eeg_beta_analysis.m # MATLAB script for EEG alpha/beta analysis
├─ Python/
│ └─ ai_attention_analysis.py # Python script for AI attention mapping and statistics
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

The `eeg_beta_analysis.m` script performs:

- Computation of **alpha (8–12 Hz) and beta (13–30 Hz) power** for each subject across tasks.  
- Calculation of **mean and standard deviation** for each task.  
- Visualization of results with **bar plots** and **error bars**.  
- Repeated-measures ANOVA and **pairwise t-tests** for beta power to evaluate statistical differences between tasks.  
- Frontal vs. parietal regional comparisons to identify task-specific cortical engagement.

### Figures
- **Mean_alpha_power.png** – Mean alpha power across IDG, IDE, IDR tasks.  
- **Mean_beta_power.png** – Mean beta power across IDG, IDE, IDR tasks.  
- **Critical contrasts (optional)** – IDG vs IDR, IDE vs IDR highlighting significant beta differences.  

---

## Python Analysis (AI Attention)

The Python script `ai_attention_analysis.py` performs:

- Loading GPT-2 and generating attention maps for each creative task.  
- Visualizing **attention distribution** per task (IDG, IDE, IDR).  
- Calculating **difference maps** between tasks to highlight changes in AI focus.  
- Statistical analysis (Kruskal-Wallis and Dunn’s post-hoc tests) to determine significance in attention shifts.

### Figures
- **IDG.png, IDE.png, IDR.png** – Attention maps for each creative phase.  
- **Difference-IDE-IDG.png, Difference-IDR-IDE.png, Difference-IDR-IDG.png** – Attention difference maps showing task-to-task changes.  

---

## How to Use

1. **EEG Analysis (MATLAB)**
   - Place EEG `.mat` files for each subject in the MATLAB working directory.  
   - Run `eeg_beta_analysis.m` to reproduce alpha/beta power results, plots, and statistical analyses.  

2. **AI Attention Analysis (Python)**
   - Ensure Python 3.x with `transformers`, `torch`, `numpy`, `matplotlib`, and `scikit_posthocs` installed.  
   - Run `ai_attention_analysis.py` to generate attention maps, difference maps, and statistical summaries.  

---

## Notes

- EEG data used for analysis is not included in this repository to protect participant privacy.  
- Figures are provided to illustrate results.  
- The repository is structured to clearly separate MATLAB (EEG) and Python (AI) analyses, along with figures for visualization.

---

## References

- GPT-2: Radford et al., 2019, OpenAI  
- Bandpower analysis for EEG: MATLAB Documentation  
- Torrance Test of Creative Thinking (TTCT) paradigms 
