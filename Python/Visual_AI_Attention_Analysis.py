# @title # **COMPLETE CODE: Linked Creativity Experiment & Analysis**
# @markdown This code runs a full, linked simulation (IDG -> IDE -> IDR) and generates clear attention maps.

# Install and import necessary libraries
!pip install transformers numpy matplotlib --quiet
from transformers import GPT2Tokenizer, GPT2Model
import torch
import matplotlib.pyplot as plt
import numpy as np

# Load the AI model
tokenizer = GPT2Tokenizer.from_pretrained('gpt2')
model = GPT2Model.from_pretrained('gpt2', output_attentions=True)
print("✅ AI Model Loaded!")

# Define a function to plot a single task clearly
def plot_single_task_clear(prompt, task_name, vmin, vmax):
    inputs = tokenizer(prompt, return_tensors='pt', truncation=True, max_length=100)
    with torch.no_grad():
        outputs = model(**inputs)
    attentions = outputs.attentions[0]
    avg_attention = attentions.mean(dim=1).squeeze()
    tokens = tokenizer.convert_ids_to_tokens(inputs['input_ids'][0])
    clean_tokens = [t.replace('Ġ', ' ').replace('▁', ' ').replace('</s>', '').replace('<s>', '') for t in tokens]

    plt.figure(figsize=(11, 9))
    im = plt.imshow(avg_attention, cmap='viridis', interpolation='nearest', vmin=vmin, vmax=vmax)
    plt.xticks(range(len(clean_tokens)), clean_tokens, rotation=45, ha='right', fontsize=9)
    plt.yticks(range(len(clean_tokens)), clean_tokens, fontsize=9)
    plt.xlabel('Context Tokens', fontsize=12)
    plt.ylabel('Current Token', fontsize=12)
    plt.title(f'Attention Map: {task_name}', fontsize=14, pad=20)
    plt.colorbar(im, label='Attention Strength', shrink=0.8)
    plt.tight_layout()
    plt.show()

# Define a function to plot a difference map clearly
def plot_difference_map(att1, att2, prompts, task1_name, task2_name, tokens_to_highlight=None):
    min_length = min(att1.shape[0], att2.shape[0])
    att1 = att1[:min_length, :min_length]
    att2 = att2[:min_length, :min_length]
    attention_difference = att2 - att1 # task2 - task1

    tokens = tokenizer.convert_ids_to_tokens(prompts['input_ids'][0])[:min_length]
    clean_tokens = [t.replace('Ġ', ' ').replace('▁', ' ').replace('</s>', '').replace('<s>', '') for t in tokens]

    plt.figure(figsize=(16, 14))
    im = plt.imshow(attention_difference, cmap='RdBu_r', interpolation='nearest', vmin=-0.2, vmax=0.2)
    plt.xticks(range(len(clean_tokens)), clean_tokens, rotation=45, ha='right', fontsize=10)
    plt.yticks(range(len(clean_tokens)), clean_tokens, fontsize=10)
    plt.xlabel('Context Tokens', fontsize=12)
    plt.ylabel('Current Token', fontsize=12)
    plt.title(f'Attention Difference: {task2_name} - {task1_name}\nRed = More Attention in {task2_name} | Blue = More Attention in {task1_name}', fontsize=14, pad=20)
    cbar = plt.colorbar(im, label='Attention Strength Difference', shrink=0.8)
    cbar.ax.tick_params(labelsize=10)

    plt.grid(False)
    for i in range(len(clean_tokens)):
        plt.axhline(i-0.5, color='gray', linewidth=0.1)
        plt.axvline(i-0.5, color='gray', linewidth=0.1)

    if tokens_to_highlight:
        for i, token in enumerate(clean_tokens):
            if any(key_term in token for key_term in tokens_to_highlight):
                plt.gca().get_xticklabels()[i].set_color('red')
                plt.gca().get_xticklabels()[i].set_fontweight('bold')
                plt.gca().get_yticklabels()[i].set_color('red')
                plt.gca().get_yticklabels()[i].set_fontweight('bold')
    plt.tight_layout()
    plt.show()

# -------------------------------------------------------------------
# LINKED EXPERIMENT: IDG -> IDE -> IDR
# -------------------------------------------------------------------
print("🧠 Running Linked Creativity Experiment...")
initial_prompt = "a circle with a spiral inside it"
print(f"Initial Abstract Shape: '{initial_prompt}'")
print("-" * 50)

# Define the prompts for each stage, chaining the outputs
prompts_linked = {
    "IDG": f"Generate one highly creative interpretation of this abstract shape: '{initial_prompt}'. Describe it in one sentence.",
    "IDE": f"Improve and evolve this idea to be more creative and innovative: 'A distant galaxy viewed face-on, with its arms slowly spinning.'. Suggest a single, radically different variation.",
    "IDR": f"Critique this idea: 'A black hole's accretion disk, glowing with intense energy as it devours a star.'. Evaluate its originality on a scale of 1-5 and justify your rating."
}

# Get attention for all three linked tasks
attention_data = {}
tokenized_prompts = {}

for task, prompt in prompts_linked.items():
    print(f"\nProcessing: {task}")
    inputs = tokenizer(prompt, return_tensors='pt', truncation=True, max_length=100)
    tokenized_prompts[task] = inputs
    with torch.no_grad():
        outputs = model(**inputs)
    attentions = outputs.attentions[0]
    avg_attention = attentions.mean(dim=1).squeeze()
    attention_data[task] = avg_attention

# Calculate global color scale for individual maps
all_attention_values = list(attention_data.values())
all_values = torch.cat([t.flatten() for t in all_attention_values])
global_min = all_values.min().item()
global_max = all_values.max().item()

# -------------------------------------------------------------------
# Generate Individual Attention Maps
# -------------------------------------------------------------------
print("\n" + "="*70)
print("INDIVIDUAL ATTENTION MAPS")
print("="*70)

for task, prompt in prompts_linked.items():
    print(f"\n📊 {task} Attention Map:")
    plot_single_task_clear(prompt, task, vmin=global_min, vmax=global_max)

# -------------------------------------------------------------------
# Generate Difference Maps
# -------------------------------------------------------------------
print("\n" + "="*70)
print("ATTENTION DIFFERENCE MAPS")
print("="*70)

# Difference 1: IDG vs IDE
print("\n🔍 Difference: IDE - IDG")
plot_difference_map(attention_data["IDG"], attention_data["IDE"], tokenized_prompts["IDE"], "IDG", "IDE", [' improve', ' evolve', ' creative'])

# Difference 2: IDE vs IDR
print("\n🔍 Difference: IDR - IDE")
plot_difference_map(attention_data["IDE"], attention_data["IDR"], tokenized_prompts["IDR"], "IDE", "IDR", [' critique', ' original', ' justify', ' scale'])

# Difference 3: IDR vs IDG
print("\n🔍 Difference: IDR - IDG")
plot_difference_map(attention_data["IDG"], attention_data["IDR"], tokenized_prompts["IDR"], "IDG", "IDR", [' critique', ' original', ' justify', ' scale'])

print("\n✅ Analysis Complete!")
