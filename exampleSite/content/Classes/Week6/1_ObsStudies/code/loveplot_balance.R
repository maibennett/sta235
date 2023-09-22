loveplot_balance <-
function (X_mat, t_id, c_id, v_line, col="#BF3984", format = FALSE) {
	X_mat_t = X_mat[t_id, ]
	X_mat_c_before = X_mat[-t_id, ]
	X_mat_c_before_mean = apply(X_mat_c_before, 2, mean)
	X_mat_t_mean = apply(X_mat_t, 2, mean)
	X_mat_t_var = apply(X_mat_t, 2, var)
	X_mat_c_before_var = apply(X_mat_c_before, 2, var)
	std_dif_before = (X_mat_t_mean - X_mat_c_before_mean)/sqrt((X_mat_t_var + X_mat_c_before_var)/2)
	#library("lattice")
	abs_std_dif_before = abs(std_dif_before)
	n_aux = length(abs_std_dif_before)
	
	library(ggplot2)
	
	d = data.frame("diff" = abs_std_dif_before[n_aux:1], 
	               "vars" = factor(colnames(X_mat)[n_aux:1], levels = colnames(X_mat)[n_aux:1]))

	gg <- ggplot(d,aes(y = vars, x = diff)) +
	  geom_point(pch = 21, color = col, fill = alpha(col, 0.4), size = 5, lwd=1.5)+
	  geom_vline(aes(xintercept = v_line), lty = 2, lwd = 1.2, color = "dark grey") +
	  theme_bw() +
	  ylab("") + xlab("Absolute std. differences in means") 
	
	if(format == TRUE){
	  library(hrbrthemes)
	  library(firasans)
	  
	  gg <- gg +   theme_ipsum_fsc(plot_title_face = "bold",plot_title_size = 24) + #plain 
	    theme(panel.grid.minor.x = element_blank(),
	          panel.grid.minor.y = element_blank(),
	          axis.line = element_line(colour = "dark grey"))+
	    theme(axis.title.x = element_text(size=18),#margin = margin(t = 10, r = 0, b = 0, l = 0)),
	          axis.text.x = element_text(size=14),
	          axis.title.y = element_text(size=18),#margin = margin(t = 0, r = 10, b = 0, l = 0)),
	          axis.text.y = element_text(size=14),legend.position="none",
	          legend.title = element_blank(),
	          legend.text = element_text(size=15),
	          legend.background = element_rect(fill="white",colour ="white"),
	          title = element_text(size=14))
	}

	gg
}
