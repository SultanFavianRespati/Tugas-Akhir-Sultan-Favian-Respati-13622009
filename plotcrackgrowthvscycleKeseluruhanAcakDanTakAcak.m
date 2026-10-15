close all
load("C:\Users\Sultan F. Respati\Documents\00. TA\Datas\crackgrowthloop_results\crackgrowthloop_full_true.mat")
plot(N4plot, a2c*1000, "k")
grid on

hold on
load("C:\Users\Sultan F. Respati\Documents\00. TA\Datas\crackgrowthloop_results\crackgrowthloop_fulldata.mat")
plot(N4plot, a2c*1000, "k-.")
grid on

xlabel("Siklus Beban")
ylabel("Panjang Retak (milimeter)")
yline(a_max*1000, "--", sprintf("Panjang retak maksimum = %.2f mm", a_max*1000))
legend(["Keseluruhan" "Keseluruhan (Acak)"], "Location", "southeast")