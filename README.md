# EEG-AI-Creativity-Analysis

This repository contains analysis code and visualizations for a study examining the relationship between **human neural activity (EEG)** and **AI attention dynamics** across different stages of creative cognition.

The project integrates:

- EEG alpha and beta power analysis
- Frontal vs. parietal regional comparisons
- Transformer-based AI attention visualization
- Quantitative statistical testing
- Cross-domain EEG–AI correlation analysis

---

## Creative Task Conditions

The study investigates three cognitive phases of creativity:

- **IDG** – Idea Generation  
- **IDE** – Idea Evolution  
- **IDR** – Idea Evaluation  

These phases are analyzed in both human EEG data and AI attention responses.

---

## Repository Structure


EEG-Creativity-Analysis/
├── MATLAB/
│ ├── EEG_Beta_Analysis.m
│ └── Frontal_Parietal_Analysis.m
├── Python/
│ ├── Visual_AI_Attention_Analysis.py
│ └── Quantitative_AI_Attention_Analysis.py
├── Figures/
│ ├── AI-IDG.png
│ ├── AI-IDE.png
│ ├── AI-IDR.png
│ ├── Difference-IDE-IDG.png
│ ├── Difference-IDR-IDE.png
│ ├── Difference-IDR-IDG.png
│ ├── Mean_alpha_power.png
│ ├── Mean_beta_power.png
│ └── EEG-AI-Correlation.png
└── README.md


---

# MATLAB Analysis (Human EEG)

### 1. `EEG_Beta_Analysis.m`

This script:

- Computes **alpha (8–12 Hz)** and **beta (13–30 Hz)** power across tasks
- Calculates mean and variability measures
- Performs repeated-measures statistical testing
- Generates power comparison plots

### Generated Figures

- **Mean_alpha_power.png**  
  Mean alpha power across IDG, IDE, and IDR.

- **Mean_beta_power.png**  
  Mean beta power across IDG, IDE, and IDR.

---

### 2. `Frontal_Parietal_Analysis.m`

This script:

- Separates electrodes into frontal and parietal regions
- Compares beta power across cortical regions
- Identifies task-specific regional activation patterns

---

# Python Analysis (AI Attention)

The AI analysis uses transformer attention matrices to examine how a language model distributes attention during creative task prompts.

---

### 1. `Visual_AI_Attention_Analysis.py`

This script:

- Generates attention heatmaps for:
  - **AI-IDG.png**
  - **AI-IDE.png**
  - **AI-IDR.png**
- Computes attention difference maps:
  - **Difference-IDE-IDG.png**
  - **Difference-IDR-IDE.png**
  - **Difference-IDR-IDG.png**

These visualizations highlight shifts in token-level attention across creative phases.

---

### 2. `Quantitative_AI_Attention_Analysis.py`

This script:

- Performs non-parametric statistical testing (e.g., Kruskal-Wallis)
- Conducts post-hoc pairwise comparisons
- Quantifies attention differences between creative stages

---

# EEG–AI Integration

### EEG-AI-Correlation.png

This figure illustrates the relationship between:

- Human beta-band modulation across creative tasks
- AI attention shifts across corresponding prompts

It represents a cross-domain comparison between biological neural dynamics and artificial attention mechanisms.

---

# How to Reproduce

## MATLAB

1. Open MATLAB.
2. Ensure EEG `.mat` data files are in the working directory.
3. Run:
   - `EEG_Beta_Analysis.m`
   - `Frontal_Parietal_Analysis.m`

---

## Python

Install dependencies:

```bash
pip install transformers torch numpy matplotlib scipy scikit_posthocs

Run:

python Visual_AI_Attention_Analysis.py
python Quantitative_AI_Attention_Analysis.py
