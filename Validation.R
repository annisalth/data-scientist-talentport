library(glmtoolbox)
library(dplyr)
library(ggplot2)
library(readr)

setwd("D:/Users/Fifi/Google Chrome Downloads/")
df <- read_csv("model_output.csv")

head(df)

# Buat model dummy untuk hltest
model <- glm(default ~ prob, data = df, family = binomial)

# Jalankan hltest dari glmtoolbox
hltest(model, g = 10)

# Siapkan data per bin decile
cal_data <- df %>%
  mutate(bin = ntile(prob, 10)) %>%
  group_by(bin) %>%
  summarise(
    predicted = mean(prob),
    actual = mean(default)
  )

# Buat plot kalibrasi
ggplot(cal_data, aes(x = predicted, y = actual)) +
  geom_line(color = "blue") +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed", color = "gray") +
  labs(
    title = "Calibration Curve",
    x = "Predicted Default Probability",
    y = "Observed Default Rate"
  ) +
  theme_minimal()

# Simpan sebagai file PNG
ggsave("calibration_curve.png", width = 6, height = 4)
##

cutoff <- df %>%
  mutate(score_group = floor(scorecard / 10) * 10) %>%
  group_by(score_group) %>%
  summarise(
    avg_prob = mean(prob),
    count = n()
  ) %>%
  filter(avg_prob <= 0.05) %>%
  arrange(desc(score_group))

print(cutoff)


