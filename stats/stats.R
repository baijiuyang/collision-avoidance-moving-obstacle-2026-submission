# ======================================================================
#  Statistical analyses for Experiments 1 and 2 (Cohen_movObst1/2)
#  Run from the repository root, section by section (e.g. in RStudio),
#  after the Python notebooks have written the input CSVs to results/.
#    - Model comparison: LME on cross-validation distance error
#    - Passing order: mixed-effects logistic regression (categorical factors)
#    - Speed vs heading control: paired t-test and LMEs
# ======================================================================

# -----------------Cohen_movObst1 Model comparision lme----------------
library(dplyr)
library(lme4)
library(car) # For Anova
library(ggplot2)
library(tidyverse)
library(rstatix)

set.seed(66)
# (run from the repository root)
DATA = read.csv("results/Cohen_movObst1_CV_errors_obst_onset.csv")
data = filter(DATA, model == "cohen_avoid" | model == "cohen_avoid2")


# Descriptives
by(data = data$error, INDICES = data$model, FUN = mean)
boxplot(error ~ model, data = data)

# Repeated measure anova
stats = data %>%
  group_by(subject, model) %>%
  summarise(error = mean(error), n = n())
stats = ungroup(stats)
aov_res <- anova_test(data = stats, dv = error, wid = subject, within = model)
get_anova_table(aov_res)

# Post-hoc
stats %>%
  pairwise_t_test(
    error ~ model, paired = TRUE,
    p.adjust.method = "bonferroni"
  )

# lme
m <- lmer(error ~ model + (1 | subject),
          data = stats, REML = FALSE)
Anova(m)


# -----------------Cohen_movObst1 passing order glmm----------------
library(dplyr)
library(lme4)
library(car) # For Anova
library(ggplot2)
library(rstatix)


set.seed(88)
# (run from the repository root)
DATA = read.csv("results/Cohen_movObst1_pass_order.csv")
data = DATA

# y can only range from 0 to 1 so recode -1 to 0 to represent behind pass
data$pass_order[data$pass_order == -1] <- 0

# Combine positive and negative angles
data$obst_angle <- abs(data$obst_angle)

# Turn angle and speed to categorical vars
data$obst_angle <- factor(data$obst_angle)
data$obst_speed <- factor(data$obst_speed)

m <- glmer(
  pass_order ~ obst_angle + obst_speed + obst_angle:obst_speed + (1 | subj_id),
  data = data,
  family = binomial(link = "logit")
)

Anova(m)


# -----------------Cohen_movObst1 speed vs heading control t-test----------------
library(dplyr)

set.seed(88)
# (run from the repository root)
DATA = read.csv("results/Cohen_movObst1_speed_heading_ctrl.csv")
df = DATA

# Compute subject means
subj_means <- df %>%
  group_by(subj_id) %>%
  summarize(
    speed = mean(speed_ctrl, na.rm = TRUE),
    heading = mean(heading_ctrl, na.rm = TRUE)
  )

# Check normality of paired differences. p > .05 means do not significantly deviate from normality
diff <- subj_means$speed - subj_means$heading
shapiro.test(diff)

# Run paired t-test
t.test(subj_means$speed, subj_means$heading, paired = TRUE)

# Compute Cohen's d effect size
mean_diff <- mean(diff)
sd_diff   <- sd(diff)
dz <- mean_diff / sd_diff

# -----------------Cohen_movObst1 speed and heading control LME----------------
library(dplyr)

set.seed(88)
# (run from the repository root)
DATA = read.csv("results/Cohen_movObst1_speed_heading_ctrl.csv")
data = DATA

# Combine positive and negative angles
data$obst_angle <- abs(data$obst_angle)

# Turn angle and speed to categorical vars
data$obst_angle <- factor(data$obst_angle)
data$obst_speed <- factor(data$obst_speed)

# Speed control 
m <- lmer(
  speed_ctrl ~ obst_angle + obst_speed + obst_angle:obst_speed + (1 | subj_id),
  data = data
)

Anova(m)

# Heading control 
m <- lmer(
  heading_ctrl ~ obst_angle + obst_speed + obst_angle:obst_speed + (1 | subj_id),
  data = data
)

Anova(m)

# Speed control ratio
data$speed_ratio <- data$speed_ctrl / (data$speed_ctrl + data$heading_ctrl)

m <- lmer(
  speed_ratio ~ obst_angle + obst_speed + obst_angle:obst_speed + (1 | subj_id),
  data = data
)

Anova(m)


# -----------------Cohen_movObst2 Model comparision lme----------------
library(dplyr)
library(lme4)
library(car) # For Anova
library(ggplot2)
library(tidyverse)
library(rstatix)

set.seed(66)
# (run from the repository root)
DATA = read.csv("results/Cohen_movObst2_CV_errors_obst_onset.csv")
data = filter(DATA, model == "cohen_avoid" | model == "cohen_avoid2")

# Descriptives
by(data = data$error, INDICES = data$model, FUN = mean)
boxplot(error ~ model, data = data)

# Repeated measure anova
stats = data %>%
  group_by(subject, model) %>%
  summarise(error = mean(error), n = n())
stats = ungroup(stats)
aov_res <- anova_test(data = stats, dv = error, wid = subject, within = model)
get_anova_table(aov_res)

# Post-hoc
stats %>%
  pairwise_t_test(
    error ~ model, paired = TRUE,
    p.adjust.method = "bonferroni"
  )

# lme
m <- lmer(error ~ model + (1 | subject),
          data = stats, REML = FALSE)
Anova(m)

# -----------------Cohen_movObst2 passing order glmm----------------
library(dplyr)
library(lme4)
library(car) # For Anova
library(ggplot2)
library(rstatix)


set.seed(88)
# (run from the repository root)
DATA = read.csv("results/Cohen_movObst2_pass_order.csv")
data = DATA

# y can only range from 0 to 1 so recode -1 to 0 to represent behind pass
data$pass_order[data$pass_order == -1] <- 0

# Combine positive and negative angles
data$obst_angle <- abs(data$obst_angle)

# Turn angle and speed to categorical vars
data$obst_angle <- factor(data$obst_angle)
data$obst_dist <- factor(data$obst_dist)

m <- glmer(
  pass_order ~ obst_angle + obst_dist + obst_angle:obst_dist + (1 | subj_id),
  data = data,
  family = binomial(link = "logit")
)

Anova(m)

# -----------------Cohen_movObst2 speed vs heading control t-test----------------
library(dplyr)

set.seed(88)
# (run from the repository root)
DATA = read.csv("results/Cohen_movObst2_speed_heading_ctrl.csv")
df = DATA

# Compute subject means
subj_means <- df %>%
  group_by(subj_id) %>%
  summarize(
    speed = mean(speed_ctrl, na.rm = TRUE),
    heading = mean(heading_ctrl, na.rm = TRUE)
  )

# Check normality of paired differences. p > .05 means do not significantly deviate from normality
diff <- subj_means$speed - subj_means$heading
shapiro.test(diff)

# Run paired t-test
t.test(subj_means$speed, subj_means$heading, paired = TRUE)

# Run Wilcoxon paired test when normality is violated
wilcox.test(subj_means$speed, subj_means$heading, paired = TRUE)

# Compute Cohen's d effect size
mean_diff <- mean(diff)
sd_diff   <- sd(diff)
dz <- mean_diff / sd_diff

# -----------------Cohen_movObst2 speed and heading control LME----------------
library(dplyr)

set.seed(88)
# (run from the repository root)
DATA = read.csv("results/Cohen_movObst2_speed_heading_ctrl.csv")
data = DATA

# Combine positive and negative angles
data$obst_angle <- abs(data$obst_angle)

# Turn angle and speed to categorical vars
data$obst_angle <- factor(data$obst_angle)
data$obst_dist <- factor(data$obst_dist)

# Speed control
m <- lmer(
  speed_ctrl ~ obst_angle + obst_dist + obst_angle:obst_dist + (1 | subj_id),
  data = data
)

Anova(m)

# Heading control 
m <- lmer(
  heading_ctrl ~ obst_angle + obst_dist + obst_angle:obst_dist + (1 | subj_id),
  data = data
)

Anova(m)


# Speed control ratio
data$speed_ratio <- data$speed_ctrl / (data$speed_ctrl + data$heading_ctrl)

m <- lmer(
  speed_ratio ~ obst_angle + obst_dist + obst_angle:obst_dist + (1 | subj_id),
  data = data
)

Anova(m)
