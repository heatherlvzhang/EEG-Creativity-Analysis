from scipy.stats import kruskal
import scikit_posthocs as sp  # You need to install this library first

# Prepare data: flatten the attention matrices
idg_att_flat = attention_data['IDG'].flatten().numpy()
ide_att_flat = attention_data['IDE'].flatten().numpy()
idr_att_flat = attention_data['IDR'].flatten().numpy()

# Kruskal-Wallis H-test (non-parametric ANOVA)
h_stat, p_value = kruskal(idg_att_flat, ide_att_flat, idr_att_flat)

print(f"Kruskal-Wallis H-statistic: {h_stat:.3f}")
print(f"P-value: {p_value:.5f}")

if p_value < 0.05:
    print("✅ There is a statistically significant difference in attention patterns between at least two tasks.")
    
    # Prepare data for Dunn's test - needs to be in a specific format
    data = [idg_att_flat, ide_att_flat, idr_att_flat]
    group_labels = ['IDG'] * len(idg_att_flat) + ['IDE'] * len(ide_att_flat) + ['IDR'] * len(idr_att_flat)
    all_data = np.concatenate(data)
    
    # Perform Dunn's test
    dunn_result = sp.posthoc_dunn([idg_att_flat, ide_att_flat, idr_att_flat], p_adjust='holm')
    
    print("\nPost-hoc Dunn's Test Results:")
    print("Matrix shows p-values between each pair of tasks:")
    print(dunn_result)
    
    # Print a simpler interpretation
    print("\nSimplified Interpretation:")
    for i, task1 in enumerate(['IDG', 'IDE', 'IDR']):
        for j, task2 in enumerate(['IDG', 'IDE', 'IDR']):
            if i < j:  # Only show each pair once
                p_val = dunn_result.iloc[i, j]
                sig = "✓" if p_val < 0.05 else "✗"
                print(f"{task1} vs {task2}: p = {p_val:.4f} {sig}")

else:
    print("❌ No significant difference found.")
