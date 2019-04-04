import Pkg;
Pkg.add("Polynomials")
Pkg.add("DataFrames")
import Statistics
using Statistics
using Polynomials
using Plots
using DataFrames
Pkg.add("CSV")
using CSV

mydata = CSV.read("result.csv")
data = mydata[[:2, :3, :4, :5]]
cleared = by(data, :1, :2=>mean, :3=>mean, :4=>mean, :2=>std, :3=>std, :4=>std)


naive_plot = plot(cleared[:1], [cleared[:2]], yerr=cleared[:5], xlabel="size", ylabel="time(s)", label="naive")
better_plot = plot(cleared[:1], [cleared[:3]], yerr=cleared[:6], xlabel="size", ylabel="time(s)")
blas_plot = plot(cleared[:1], [cleared[:4]], yerr=cleared[:7], xlabel="size", ylabel="time(s)")
sum_plot = naive_plot
plot!(sum_plot, cleared[:1], [cleared[:3]], yerr=cleared[:6], xlabel="size", ylabel="time(s)", label="better")
plot!(sum_plot, cleared[:1], [cleared[:4]], yerr=cleared[:7], xlabel="size", ylabel="time(s)", label = "blas")

fit1=polyfit(cleared[:1], cleared[:2], 2)
plot(cleared[:1], polyval(fit1, cleared[:1]))
fit2=polyfit(cleared[:1], cleared[:3], 2)

fit3=polyfit(cleared[:1], cleared[:4], 2)
plot!(sum_plot, cleared[:1], polyval(fit1, cleared[:1]), label="naive_poly")
plot!(sum_plot, cleared[:1], polyval(fit2, cleared[:1]), label="better_poly")
plot!(sum_plot, cleared[:1], polyval(fit3, cleared[:1]), label="blas_poly")
