# ==============================================================================
# Title: Demographic Impact on Academic Performance (Math & Language)
# Description: Parametric statistical analysis of standardized test scores
#              using Two-Way ANOVA and Tukey's HSD.
# Dataset: Scores(2).csv
# Author: Karthikeya Ramavittal Madhyanapu
# ==============================================================================

# 1. Install and Load Required Packages
# ------------------------------------------------------------------------------
# install.packages(c("dplyr", "tidyr", "ggplot2", "moments", "car"))
library(dplyr)
library(tidyr)
library(ggplot2)
library(moments) # Used for skewness and kurtosis calculations
library(car)     # Used for Levene's Test

# 2. Data Loading and Pre-Processing
# ------------------------------------------------------------------------------
# Load the dataset
df <- read.csv("Scores(2).csv", stringsAsFactors = FALSE)

# Fix comma-based decimals in the score column (e.g., "85,5" to "85.5")
# and convert the column to numeric format
df <- df %>%
  mutate(score = as.numeric(gsub(",", ".", score)))

# Convert independent variables to factors
df$gender <- as.factor(tolower(df$gender))
df$subject <- as.factor(tolower(df$subject))

# Define Parental Education as an Ordinal (Ranked) Factor
df$parental_education <- factor(tolower(df$parental_education), 
                                levels = c("high school", 
                                           "associate's degree", 
                                           "bachelor's degree", 
                                           "master's degree"), 
                                ordered = TRUE)

# Split the dataset by subject for independent testing
df_math <- df %>% filter(subject == "math")
df_lang <- df %>% filter(subject == "language")


# 3. Descriptive Statistics
# ------------------------------------------------------------------------------
# Create a custom function to generate all descriptive metrics
get_descriptives <- function(data) {
  data %>%
    summarise(
      N = n(),
      Mean = mean(score, na.rm = TRUE),
      Median = median(score, na.rm = TRUE),
      SD = sd(score, na.rm = TRUE),
      Variance = var(score, na.rm = TRUE),
      IQR = IQR(score, na.rm = TRUE),
      Skewness = skewness(score, na.rm = TRUE),
      Kurtosis = kurtosis(score, na.rm = TRUE)
    )
}

# Generate Descriptive Tables by Gender
math_desc_gender <- df_math %>% group_by(gender) %>% get_descriptives()
lang_desc_gender <- df_lang %>% group_by(gender) %>% get_descriptives()

# Generate Descriptive Tables by Parental Education
math_desc_edu <- df_math %>% group_by(parental_education) %>% get_descriptives()
lang_desc_edu <- df_lang %>% group_by(parental_education) %>% get_descriptives()

# Print Descriptive Tables to Console
print("--- Descriptive Statistics: Math by Gender ---")
print(math_desc_gender)
print("--- Descriptive Statistics: Language by Parental Education ---")
print(lang_desc_edu)


# 4. Data Visualization (Histograms & Boxplots)
# ------------------------------------------------------------------------------
# Histogram: Check overall distribution shapes
plot_hist <- ggplot(df, aes(x = score, fill = gender)) +
  geom_histogram(bins = 30, color = "black", alpha = 0.7, position = "identity") +
  facet_wrap(~ subject) +
  labs(title = "Frequency Distribution of Scores by Subject",
       x = "Standardized Score", y = "Frequency") +
  theme_minimal()

print(plot_hist)

# Boxplot: Visualize Medians, IQRs, and Outliers (Figure 1 from Report)
plot_box <- ggplot(df, aes(x = parental_education, y = score, fill = gender)) +
  geom_boxplot(alpha = 0.8) +
  facet_wrap(~ subject) +
  labs(title = "Mathematics and Language Scores by Gender and Parental Education",
       x = "Parental Education Level", 
       y = "Standardized Score") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

print(plot_box)


# 5. Assumption Testing (Normality & Homoscedasticity)
# ------------------------------------------------------------------------------
# Fit preliminary linear models to extract residuals
math_model <- lm(score ~ gender * parental_education, data = df_math)
lang_model <- lm(score ~ gender * parental_education, data = df_lang)

# A. Shapiro-Wilk Test on extracted residuals
print("--- Shapiro-Wilk Test: Math Residuals ---")
shapiro.test(resid(math_model))

print("--- Shapiro-Wilk Test: Language Residuals ---")
shapiro.test(resid(lang_model))

# B. Levene's Test for Homoscedasticity (Equal Variances)
print("--- Levene's Test: Math ---")
leveneTest(score ~ gender * parental_education, data = df_math)

print("--- Levene's Test: Language ---")
leveneTest(score ~ gender * parental_education, data = df_lang)


# 6. Inferential Statistics: Two-Way ANOVA
# ------------------------------------------------------------------------------
# Testing main effects (Gender & Education) and their interaction
print("--- Two-Way ANOVA: Math Scores ---")
math_anova <- aov(score ~ gender * parental_education, data = df_math)
summary(math_anova)

print("--- Two-Way ANOVA: Language Scores ---")
lang_anova <- aov(score ~ gender * parental_education, data = df_lang)
summary(lang_anova)


# 7. Post-Hoc Analysis: Tukey's Honest Significant Difference (HSD)
# ------------------------------------------------------------------------------
# Executed because the main effect for parental education was significant
print("--- Tukey's HSD: Math (Parental Education) ---")
TukeyHSD(math_anova, "parental_education")
print("--- Tukey's HSD: Language (Parental Education) ---")
TukeyHSD(lang_anova, "parental_education")

