% Define the standard channel order for a 64-channel system (with Cz removed, so we use 63)
standard_63ch_labels = {
    'Fp1', 'Fp2', 'Fz', 'F3', 'F4', 'F7', 'F8', 'FC1', 'FC2', 'FC5', 'FC6', ...
    ‘Cz’, ‘C3’, ‘C4’, ‘T7’, ‘T8’, ‘CP1’, ‘CP2’, ‘CP5’, ‘CP6’, ...
    'Pz', 'P3', 'P4', 'P7', 'P8', 'PO3', 'PO4', 'PO7', 'PO8', ...
    ‘Oz’, ‘O1’, ‘O2’, ...
    'AF7', 'AF3', 'AF4', 'AF8', 'F1', 'F2', 'F5', 'F6', 'FT7', 'FT8', ...
    'FC3', 'FC4', 'C1', 'C2', 'C5', 'C6', 'TP7', 'TP8', 'CP3', 'CP4', ...
    'P1', 'P2', 'P5', 'P6', 'POz' % Cz is missing, so we stop at 63 channels
};

% Find the indices for frontal and parietal regions
frontal_indices = find(ismember(standard_63ch_labels, {'Fz', 'F3', 'F4', 'F7', 'F8', 'FC1', 'FC2', 'FC5', 'FC6'}));
parietal_indices = find(ismember(standard_63ch_labels, {'Pz', 'P3', 'P4', 'P7', 'P8', 'CP1', 'CP2', 'CP5', 'CP6'}));

fprintf('Frontal channel indices: %s\n', num2str(frontal_indices));
fprintf('Parietal channel indices: %s\n', num2str(parietal_indices));

% Initialize arrays to store results for all subjects and tasks
n_subjects = 28; % From your workspace
tasks = {‘IDG’, ‘IDE’, ‘IDR’};
frontal_power = zeros(n_subjects, length(tasks));
parietal_power = zeros(n_subjects, length(tasks));
% Create a flag to track which subjects had data found
data_found = false(n_subjects, length(tasks));

% Loop through all subjects
for subj = 1:n_subjects
    % Load the subject’s data file
    filename = sprintf('Data_Creativity_Sub_%d.mat', subj);
    
    % Check if file exists before loading
    if ~isfile(filename)
        warning('File not found: %s', filename);
        continue; % Skip to next subject
    end
    
    data = load(filename);
    
    % Get the list of variable names in the loaded file
    varNames = fieldnames(data);
    
    % Loop through each task for this subject
    for t = 1:length(tasks)
        task = tasks{t};
        
        % Find ALL variable names that contain this task (any trial)
        taskVars = varNames(contains(varNames, task));
        
        if isempty(taskVars)
            % No data for this task - leave values as zero and skip
            continue;
        end
        
        % Use the FIRST available trial for this task
        foundVar = taskVars{1};
        eeg_data = data.(foundVar);
        
        % Calculate beta power for each channel
        beta_power_per_channel = bandpower(eeg_data', 500, [13 30]);
        
        % Average the beta power across the frontal and parietal regions
        frontal_power(subj, t) = mean(beta_power_per_channel(frontal_indices));
        parietal_power(subj, t) = mean(beta_power_per_channel(parietal_indices));
        
        % Mark that we found data for this subject-task combination
        data_found(subj, t) = true;
    end
end

% Display how many subjects had data for each task
fprintf('\nData availability summary:\n');
for t = 1:length(tasks)
    count = sum(data_found(:, t));
    fprintf('Task %s: %d out of %d subjects had data\n', tasks{t}, count, n_subjects);
end

% Only use subjects that have data for analysis
valid_subjects = any(data_found, 2); % Find subjects with at least one task
fprintf('\nUsing %d subjects with available data for analysis\n', sum(valid_subjects));

% Calculate the group means for each task using only available data
mean_frontal = zeros(1, length(tasks));
mean_parietal = zeros(1, length(tasks));
subject_count = zeros(1, length(tasks));

for t = 1:length(tasks)
    has_data = data_found(:, t);
    if any(has_data)
        mean_frontal(t) = mean(frontal_power(has_data, t));
        mean_parietal(t) = mean(parietal_power(has_data, t));
        subject_count(t) = sum(has_data);
    end
end

% Display the results in a table
results_table = table(mean_frontal', mean_parietal', mean_parietal' ./ mean_frontal', subject_count', ...
    'VariableNames', {'Mean_Frontal_Beta', 'Mean_Parietal_Beta', 'Parietal_Frontal_Ratio', 'N_Subjects'}, ...
    ‘RowNames’, tasks);
disp('Group Mean Beta Power (µV²) by Brain Region:');
disp(results_table);

% Plot the results
figure;
bar([mean_frontal; mean_parietal]');
set(gca, 'XTickLabel', tasks);
ylabel('Beta Power (µV²)');
title('Beta Power: Frontal vs. Parietal Lobes by Task');
legend(‘Frontal (Task Execution)’, ‘Parietal (Semantic Processing)’, ‘Location’, ‘best’);
grid on;
