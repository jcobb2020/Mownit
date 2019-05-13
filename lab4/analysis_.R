install.packages("ggplot2")

setwd("../Desktop/Studia/mownit/lab4")
library("ggplot2")
results_n_b_blas = read.csv("matrix_n_b_blas.csv")
results_v_m = read.csv("resultVVM.csv")

#matrix_avg_results <- results_v_m[, -3]
#matrix_avg_results <- matrix_avg_results[, -2]
#m_avg_results <- aggregate(time_M ~ size, data = matrix_avg_results, FUN = mean)


#plot_matrix<-qplot(size, time_M, data = m_avg_results)




#vector_avg_results <-results_v_m[,-4]
#vector_avg_results <- vector_avg_results[,-2]
#v_avg_results <- aggregate(time_V ~ size, data = vector_avg_results, FUN = mean)

#plot_vector <- qplot(size, time_V, data = v_avg_results)

#fit_v <- lm(time_V ~ poly(size, 2, raw = TRUE), data=vector_avg_results)
#plot(fit_v)
avg_results <- aggregate(cbind(time_V, time_M) ~ size, data=results_v_m, FUN = mean)
#qplot(size, time_M, data = avg_results)
avg_results$time_V_sd = aggregate(time_V ~ size, data = results_v_m, FUN = sd)$time_V
avg_results$time_M_sd = aggregate(time_M ~ size, data = results_v_m, FUN = sd)$time_M

fit_V=lm(time_V ~ poly(as.vector(avg_results[["size"]]), 2, raw=TRUE), data = avg_results)
fit_M=lm(time_M ~ poly(as.vector(avg_results[["size"]]), 2, raw=TRUE), data = avg_results)

poly_V = data.frame(x=avg_results["size"])
poly_M = data.frame(x=avg_results["size"])

poly_V$y=predict(fit_V, poly_V)
poly_M$y=predict(fit_M, poly_M)

ggplot()+
  geom_errorbar(data = avg_results, aes(x=size, y=time_V, ymin=time_V - time_V_sd, ymax=time_V + time_V_sd))+
  geom_errorbar(data = avg_results, aes(x=size, y=time_M, ymin=time_M - time_M_sd, ymax=time_M + time_M_sd))+
  geom_point(data = avg_results, aes(size, time_V), colour = "green", label_value("time_V"))+
  geom_point(data = avg_results, aes(size, time_M), colour = "yellow", label_value("time_M"))+
  geom_line(data = poly_V, aes(size, y), colour = "green" )+
  geom_line(data = poly_M, aes(size, y), colour = "blue" )+
  ggtitle("myPlot")+
  xlab("size")+
  ylab("time[s]")

p <- ggplot(avg_results, aes(size, time_M), aes(size, time_V))
p+ geom_point()


  

  



