# ==============================================================================
# Title: Student Performance Demographics Analysis
# Author: Karthikeya Madhyanapu
# Description: R script for the descriptive and inferential statistical analysis 
#              evaluating the impact of gender and parental education on test scores.
# ==============================================================================

# ==========================================
# SECTION 1: SETUP & LIBRARIES
# ==========================================
# Install required packages if not already installed:
# install.packages(c("readr", "dplyr", "ggplot2", "tidyr", "e1071", "openxlsx"))

library(readr)     # For reading the CSV
library(dplyr)     # For data manipulation
library(ggplot2)   # For advanced data visualization
library(tidyr)     # For data tidying
library(e1071)     # For calculating skewness and kurtosis
library(openxlsx)  # For exporting clean Excel tables

# ==========================================
# SECTION 2: DATA IMPORT & PREPROCESSING
# ==========================================
# Read the dataset (Ensure your file is named 'Scores(2).csv' in the working directory)
df <- read_csv2("Scores(2).csv") %>%
  rename(parental_education = `parental.level.of.education`) %>%
  select(-`...1`) # Drop the unnamed index column

# Convert independent variables to factors and set logical ordinal levels
df$gender <- as.factor(df$gender)
df$subject <- as.factor(df$subject)
df$parental_education <- factor(df$parental_education, 
                                levels = c("high school", "associate's degree", 
                                           "bachelor's degree", "master's degree"))

# ==========================================
# SECTION 3: DESCRIPTIVE STATISTICS
# ==========================================
# Calculate the master summary statistics table
final_stats <- df %>%
  group_by(subject, gender, parental_education) %>%
  summarise(
    N = n(),
    Mean = round(mean(score), 2),
    SD = round(sd(score), 2),
    Q1 = round(quantile(score, 0.25), 2),
    Median = round(median(score), 2),
    Q3 = round(quantile(score, 0.75), 2),
    IQR = round(IQR(score), 2),
    Skewness = round(skewness(score, type = 2), 2),
    Kurtosis = round(kurtosis(score, type = 2), 2),
    .groups = 'drop'
  )

print(final_stats)

# (Optional) Export descriptive stats to an Excel workbook for the Appendix
wb <- createWorkbook()
addWorksheet(wb, "Descriptive Stats")
writeData(wb, "Descriptive Stats", final_stats)
headerStyle <- createStyle(fontColour = "#FFFFFF", fgFill = "#4F81BD", halign = "center", textDecoration = "bold")
addStyle(wb, "Descriptive Stats", style = headerStyle, rows = 1, cols = 1:ncol(final_stats), gridExpand = TRUE)
setColWidths(wb, "Descriptive Stats", cols = 1:ncol(final_stats), widths = "auto")
saveWorkbook(wb, "Descriptive_Statistics_Export.xlsx", overwrite = TRUE)

# ==========================================
# SECTION 4: EXPLORATORY DATA ANALYSIS (EDA)
# ==========================================

# FIGURE 1: Density Plots (Normality Visual Check)
plot_density <- ggplot(df, aes(x = score, fill = gender)) +
  geom_density(alpha = 0.5) + 
  facet_grid(subject ~ parental_education) + 
  labs(
    title = "Score Distributions (Density) by Subject and Education",
    x = "Test Score (0-100)",
    y = "Density",
    fill = "Gender"
  ) +
  theme_bw() +
  theme(plot.title = element_text(face = "bold", hjust = 0.5)) +
  scale_fill_manual(values = c("female" = "#F8766D", "male" = "#00BFC4"))

print(plot_density)
ggsave("Figure_1_Density_Plot.png", plot = plot_density, width = 10, height = 6, dpi = 300)

# FIGURE 2: Grouped Boxplots (Dispersion & Outliers)
plot_boxplot <- ggplot(df, aes(x = parental_education, y = score, fill = gender)) +
  geom_boxplot(alpha = 0.8, outlier.color = "red", outlier.shape = 16, outlier.size = 2) +
  facet_wrap(~ subject) +
  labs(
    title = "Distribution of Student Scores by Education and Gender",
    x = "Parental Level of Education",
    y = "Test Score (0-100)",
    fill = "Gender"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, face = "bold"),
    plot.title = element_text(face = "bold", hjust = 0.5),
    strip.text = element_text(face = "bold", size = 12),
    panel.border = element_rect(color = "black", fill = NA, size = 0.5)
  ) +
  scale_fill_manual(values = c("female" = "#F8766D", "male" = "#00BFC4"))

print(plot_boxplot)
ggsave("Figure_2_Boxplot.png", plot = plot_boxplot, width = 10, height = 6, dpi = 300)

# ==========================================
# SECTION 5: INFERENTIAL STATISTICS
# ==========================================
# Separate the data by subject for isolated hypothesis testing
math_data <- subset(df, subject == "math")
language_data <- subset(df, subject == "language")

cat("\n==========================================")
cat("\n   TASK 1: T-TESTS (GENDER DIFFERENCES)")
cat("\n==========================================\n")
# Note: Welch's T-Test handles potential heteroscedasticity between groups
cat("\n--- MATH: Male vs Female ---\n")
print(t.test(score ~ gender, data = math_data))

cat("\n--- LANGUAGE: Male vs Female ---\n")
print(t.test(score ~ gender, data = language_data))

cat("\n==========================================")
cat("\n   TASK 2: ONE-WAY ANOVAS (EDUCATION)")
cat("\n==========================================\n")
anova_math <- aov(score ~ parental_education, data = math_data)
cat("\n--- ANOVA: MATH ---\n")
print(summary(anova_math))

anova_language <- aov(score ~ parental_education, data = language_data)
cat("\n--- ANOVA: LANGUAGE ---\n")
print(summary(anova_language))

cat("\n==========================================")
cat("\n   TASK 3: POST-HOC TESTING (TUKEY HSD)")
cat("\n==========================================\n")
cat("\n--- TUKEY POST-HOC TEST (Math) ---\n")
print(TukeyHSD(anova_math))

cat("\n--- TUKEY POST-HOC TEST (Language) ---\n")
print(TukeyHSD(anova_language))

# ==========================================
# SECTION 6: INTERACTION EFFECTS (TWO-WAY ANOVA)
# ==========================================
cat("\n==========================================")
cat("\n   TWO-WAY ANOVAS (GENDER * EDUCATION)")
cat("\n==========================================\n")

two_way_math <- aov(score ~ gender * parental_education, data = math_data)
cat("\n--- TWO-WAY ANOVA: MATH ---\n")
print(summary(two_way_math))

two_way_language <- aov(score ~ gender * parental_education, data = language_data)
cat("\n--- TWO-WAY ANOVA: LANGUAGE ---\n")
print(summary(two_way_language))

# FIGURE 3: Combined Interaction Plot
# Calculate mean scores for the plot
plot_data <- df %>%
  group_by(subject, parental_education, gender) %>%
  summarise(mean_score = mean(score), .groups = 'drop')

# Generate the faceted plot
plot_interaction <- ggplot(plot_data, aes(x = parental_education, y = mean_score, group = gender, color = gender)) +
  geom_line(linewidth = 1) +
  geom_point(size = 3) +
  facet_wrap(~ subject) +  
  theme_bw() +             
  labs(
    title = "Interaction Plot: Main Effects and Lack of Interaction",
    x = "Parental Education Level",
    y = "Mean Test Score",
    color = "Gender"
  ) +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1), 
    strip.background = element_rect(fill = "lightgray"), 
    strip.text = element_text(face = "bold", size = 11),
    legend.position = "bottom",
    plot.title = element_text(face = "bold", hjust = 0.5)
  )

print(plot_interaction)
ggsave("Figure_3_Interaction_Plot.png", plot = plot_interaction, width = 10, height = 6, dpi = 300)

# --- END OF SCRIPT ---
