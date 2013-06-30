library("ggplot2")
library("reshape2")

data <- read.table("/Volumes//BI/benchmark/results/bench_DARNED.log", header=T)

Fm <- function(precision=p, recall=r) {
  if (is.numeric(precision) && is.numeric(recall)) {
    return (sort(2*precision*recall/(recall+precision), decreasing=T))
  } else {
    warning("Given data is not numetric")
  }
}

Fm <- Fm(p=data$Precision, r=data$Recall) # Calculate F-measure
mod_df <- cbind(data, Fmeasure=Fm) # Add F-measure to the data.frame
Fscore <- melt(mod_df)

g <- ggplot(
    data=mod_df,
    aes(y=Fmeasure, x=Label, group=1)) +
    geom_line(colour="red", size=1) +
    geom_point(color="red", size=3, shape=21, fill="red") +
    ylim(0, 1) +
    labs(title="Rank order of F-measure", y="F-measure", x="") +
    theme_bw(base_size=16, base_family="Helvetica")

plot(g)
