%% MATLAB Script: Compute Alpha and Beta Power for All Subjects

% Parameters
n_subjects = 28;
fs = 500;  % Sampling rate in Hz
alpha_band = [8 12];
beta_band  = [13 30];

% Initialize result matrices
alpha_power = zeros(n_subjects, 3);  % Columns: IDG, IDE, IDR
beta_power  = zeros(n_subjects, 3);

tasks = {'IDG', 'IDE', 'IDR'};

% Loop through subjects
for subj = 1:n_subjects
    filename = sprintf('Data_Creativity_Sub_%d.mat', subj);
    
    if ~isfile(filename)
        warning('File not found: %s', filename);
        continue;
    end
    
    data = load(filename);
    vars = fieldnames(data);
    
    for t = 1:length(tasks)
        task = tasks{t};
        trial_data = [];
        
        % Find variable matching task
        for v = 1:length(vars)
            if contains(vars{v}, task)
                trial_data = data.(vars{v});
                break;
            end
        end
        
        if isempty(trial_data)
            warning('Subject %d missing task %s', subj, task);
            continue;
        end
        
        % Use channel Cz (index 31)
        cz_signal = double(trial_data(31, :));
        
        % Compute alpha and beta power
        alpha_power(subj, t) = bandpower(cz_signal, fs, alpha_band);
        beta_power(subj, t)  = bandpower(cz_signal, fs, beta_band);
    end
end

%% Display mean power across subjects
fprintf('\n--- Mean Alpha and Beta Power Across All Subjects ---\n');
for t = 1:3
    fprintf('%s - Alpha: %.8f, Beta: %.8f\n', tasks{t}, ...
        mean(alpha_power(:,t)), mean(beta_power(:,t)));
end

%% Standard deviation of beta power
fprintf('\nStandard Deviation of Beta Power:\n');
disp(std(beta_power));

%% Plot mean with error bars
means = mean(beta_power);
sds   = std(beta_power);

figure;
bar(means);
hold on;
errorbar(1:3, means, sds, 'k.', 'LineWidth', 1.5);
hold off;
xticklabels(tasks);
ylabel('Beta Power (\muV^2)');
title('Mean and SD of Beta Power Across Tasks');

%% Repeated-measures ANOVA
T = array2table(beta_power, 'VariableNames', tasks);
T.Subject = (1:n_subjects)';    

Within = table(tasks', 'VariableNames', {'Task'});
rm = fitrm(T, 'IDG-IDR ~ 1', 'WithinDesign', Within);
ranovatbl = ranova(rm);
disp(ranovatbl);

%% Paired t-tests and Cohen's d
comparisons = {'IDG vs IDE', 'IDE vs IDR', 'IDG vs IDR'};
pairs = [1 2; 2 3; 1 3];
results = cell(3,4);

for i = 1:3
    c1 = pairs(i,1);
    c2 = pairs(i,2);
    [p,~,stats] = ttest(beta_power(:,c1), beta_power(:,c2));
    diffVals = beta_power(:,c2) - beta_power(:,c1);
    d = mean(diffVals)/std(diffVals);
    results{i,1} = comparisons{i};
    results{i,2} = p;
    results{i,3} = stats.tstat;
    results{i,4} = d;
end

ResultsTable = cell2table(results, ...
    'VariableNames', {'Comparison','pValue','tStatistic','Cohens_d'});
disp(ResultsTable);

%% Frontal vs Parietal beta power
standard_63ch_labels = {
    'Fp1','Fp2','Fz','F3','F4','F7','F8','FC1','FC2','FC5','FC6',...
    'Cz','C3','C4','T7','T8','CP1','CP2','CP5','CP6',...
    'Pz','P3','P4','P7','P8','PO3','PO4','PO7','PO8',...
    'Oz','O1','O2','AF7','AF3','AF4','AF8','F1','F2','F5','F6','FT7','FT8',...
    'FC3','FC4','C1','C2','C5','C6','TP7','TP8','CP3','CP4','P1','P2','P5','P6','POz'};

frontal_indices = find(ismember(standard_63ch_labels, {'Fz','F3','F4','F7','F8','FC1','FC2','FC5','FC6'}));
parietal_indices = find(ismember(standard_63ch_labels, {'Pz','P3','P4','P7','P8','CP1','CP2','CP5','CP6'}));

frontal_power = zeros(n_subjects, length(tasks));
parietal_power = zeros(n_subjects, length(tasks));
data_found = false(n_subjects, length(tasks));

for subj = 1:n_subjects
    filename = sprintf('Data_Creativity_Sub_%d.mat', subj);
    if ~isfile(filename)
        continue;
    end
    data = load(filename);
    varNames = fieldnames(data);
    
    for t = 1:length(tasks)
        taskVars = varNames(contains(varNames, tasks{t}));
        if isempty(taskVars), continue; end
        eeg_data = data.(taskVars{1});
        beta_ch = bandpower(eeg_data', fs, beta_band);
        frontal_power(subj,t) = mean(beta_ch(frontal_indices));
        parietal_power(subj,t) = mean(beta_ch(parietal_indices));
        data_found(subj,t) = true;
    end
end

%% Group means
mean_frontal = zeros(1,length(tasks));
mean_parietal = zeros(1,length(tasks));
for t = 1:length(tasks)
    has_data = data_found(:,t);
    if any(has_data)
        mean_frontal(t) = mean(frontal_power(has_data,t));
        mean_parietal(t) = mean(parietal_power(has_data,t));
    end
end

results_table = table(mean_frontal', mean_parietal', mean_parietal'./mean_frontal', ...
    'VariableNames', {'Mean_Frontal_Beta','Mean_Parietal_Beta','Parietal_Frontal_Ratio'}, ...
    'RowNames', tasks);
disp('Group Mean Beta Power by Brain Region:');
disp(results_table);

%% Plot frontal vs parietal
figure;
bar([mean_frontal; mean_parietal]');
set(gca, 'XTickLabel', tasks);
ylabel('Beta Power (\muV^2)');
title('Beta Power: Frontal vs Parietal');
legend('Frontal','Parietal','Location','best');
grid on;
