library("ggplot2")
library("reshape2")

t <- melt(read.table("/Volumes/BI/benchmark/results/AGenrichment.log", header=T))

g <- ggplot(
    t,
    aes(x=Label, y=value, fill=variable)) +
    geom_bar(stat="identity", width=0.8) +
    scale_fill_brewer() +
    ylim(0,1) +
    labs(title="Enrichment assesment of A-to-G editing", y="AG Enrichment", x="Samples", fill="") +
    theme_bw(base_size=16, base_family="Helvetica")

plot(g)
