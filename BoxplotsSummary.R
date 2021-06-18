library(tidyverse)
library(rstatix)
library(ggpubr)
#::::::::::::::::::::::::::::::::::::::::::::::::
data("ToothGrowth")
df <- ToothGrowth
df$dose <- as.factor(df$dose)
# Add random QC column
set.seed(123)
qc <- rep(c("pass", "fail"), 30)
df$qc <- as.factor(sample(qc, 60))
# Inspect the data
head(df)


# Basic summary stats
#::::::::::::::::::::::::::::::::::::::::::::::::
# Compute summary statistics
summary.stats <- df %>%
        group_by(dose) %>%
        get_summary_stats(type = "common")
summary.stats

# Visualize summary table
ggsummarytable(
        summary.stats, x = "dose", y = c("n", "median", "iqr"),
        ggtheme = theme_bw()
)


# Create plots with summary table under the plot
#::::::::::::::::::::::::::::::::::::::::::::::::
# Basic plot
ggsummarystats(
        df, x = "dose", y = "len",
        ggfunc = ggboxplot, add = "jitter",summaries = c("n", "median", "iqr","min","max"),)
#theme(axis.title.x = element_text(size=15)))

# Color by groups
ggsummarystats(
        df, x = "dose", y = "len",
        ggfunc = ggboxplot, add = "jitter",
        color = "dose", palette = "npg"
)

# Create a barplot
ggsummarystats(
        df, x = "dose", y = "len",
        ggfunc = ggbarplot, add = c("jitter", "median_iqr"),
        color = "dose", palette = "npg")
        

# Facet
#::::::::::::::::::::::::::::::::::::::::::::::::
# Specify free.panels = TRUE for free panels
ggsummarystats(
        df, x = "dose", y = "len",
        ggfunc = ggboxplot, add = "jitter",
        color = "dose", palette = "npg",
        facet.by = c("supp", "qc"),
        labeller = "label_both"
)
