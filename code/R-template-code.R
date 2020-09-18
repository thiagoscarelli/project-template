################
#   Preamble   #
################

# What does this code do?
# Set a layout and style guide for a generic R code file

################
#   Packages   #
################

# General use
library(here)
library(fst)
library(tidyr)
library(dplyr)
library(beepr)

# Dates
library(lubridate)

# Tables
library(stargazer)
library(kableExtra)

# Colors
library(RColorBrewer)

############################
#   Graphical parameters   #
############################

# Colors
palette(brewer.pal(n = 8, name = "Set1"))

# Standard parameters for single plot
par(mfrow = c(1, 1),            # Grid for multiple plots
    oma = c(0, 0, 0, 0),        # Outside margins
    mar = c(4, 4, 0, 1) + 0.1,  # Margins around the plot area (for title, axis labels)
    mgp = c(2.5, 1, 0),         # Distance of axis labels to the plot area
    xpd = FALSE,                # Plot legend outside the plot area? NA for yes
    lwd = 1)                    # Line weight

# Standard pdf parameters for single plot, page width
pdf.options(pointsize = 10,
            height = 3,
            width = 5.9)

#######################
#   Import the data   #
#######################

data_0 <- read.fst(path = here::here("data", "data_0.fst"))

data_1 <- data.frame(rnorm(n = 1000))

write.fst(x = data_1, path = here::here("data", "data_1.fst"))

######################
#   Clean the data   #
######################

data_1 <- read.fst(path = here::here("data", "data_1.fst"))

##############
#   Tables   #
##############

stargazer(
  data_1,
  header = F,
  type = "latex",
  summary.stat = c("mean", "sd")) %>% writeLines(con = here::here("exhibits", "summary.tex"))

stargazer(cox_i, cox_we, cox_se,
          title = "Estimation results for cause-specific Cox models",
          column.labels = c("Inactive", "Employee", "Self-Employed"),
          no.space = TRUE,
          single.row = TRUE,
          header = FALSE,
          p.auto = FALSE,
          t.auto = FALSE,
          colnames = FALSE,
          keep = 1:25) %>% writeLines(con = here::here("exhibits", "stargazer.tex"))

cbind(coxtest_i$table[1:25, c(1,3)],
      coxtest_we$table[1:25, c(1,3)],
      coxtest_se$table[1:25, c(1,3)]) %>%
  kable(format = "latex",
        digits = 2,
        longtable = T, booktabs = TRUE,
        caption = "Testing the proportionality assumption with Schoenfeld residuals for the 3 cause-specific hazard models with fixed covariates",
        align = c('c', 'c', 'c', 'c', 'c', 'c')) %>%
  add_header_above(c(" ", "Inactive" = 2, "Employee" = 2, "Self-employed" = 2), bold = TRUE) %>%
  kable_styling(latex_options = c("hold_position", "repeat_header"),
                font_size = 10) %>%
  column_spec(1, width = "5cm") %>%
  column_spec(2:6, width = "1cm") %>%
  group_rows(bold = F,  italic = T,
             index =
               c(" " = 7,
                 "Relative family position (reference category is Head)" = 4,
                 "Race (reference category is White)" = 4,
                 "Education (reference category is High School)" = 5,
                 "City (reference category is Sao Paulo)" = 5)) %>%
  footnote(general = "Source: Author's calculations.",
           footnote_as_chunk = T,
           threeparttable = T,
           general_title = "") %>%
  writeLines(con = here::here("exhibits", "kable.tex"))

#############
#   Plots   #
#############

pdf(file = here::here("exhibits", "plot-1.pdf"))
par(oma = c(0, 0, 0, 0),
    mar = c(4, 4, 0, 1) + 0.1,
    mgp = c(2.5, 1, 0))
plot(x = rnorm(100),
     y = rnorm(100),
     col = 1,
     lwd = 2,
     xlim = c(-5, 5),
     ylim = c(-5, 5),
     xlab = "Months of unemployment",
     ylab = "Survival probability")
legend("bottomleft",
       c("Recession at start = 1",
         "Recession at start = 0"),
       col = c("black", "darkgray"),
       lwd = 2,
       bty = 'n',
       inset = c(0.01, 0))
dev.off()

###################
#   End of code   #
###################
