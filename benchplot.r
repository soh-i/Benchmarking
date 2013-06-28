library('ggplot2')

# Add data as data.frame
Zhu2013 <- data.frame(precision=0.6178, recall=0.0042, Label="Zhu2013")
PooledSamplesAlu <- data.frame(precision=0.3227, recall=0.0635, Label="PooledSamplesAlu")
PooledSamplesRepetitiveNonAlu <- data.frame(precision=0.4168, recall=0.0032 , Label="PooledSamplesRepetitiveNonAlu")
PooledSamplesNonRepetitive <- data.frame(precision=0.2701, recall=0.0020, Label="PooledSamplesNonRepetitive")
data <- rbind(Zhu2013, PooledSamplesAlu,PooledSamplesRepetitiveNonAlu,PooledSamplesNonRepetitive)

g <- ggplot(
  data,
  aes(x = precision, y = recall) ) +
  geom_point(aes(colour = Label), shape = 19, size = 7) +
  ylim(0,1) +
  xlim(0,1) +
  labs(title = "Benchmarking test for humna data, answer set is DARNED hg19",
       x = "Precision",
       y = "Recall"
       ) +
  theme_bw(base_size=16, base_family="Helvetica")

plot(g)
