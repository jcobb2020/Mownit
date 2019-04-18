cd()
cd("Mownit/lab5")

import Pkg
Pkg.add("Polynomials")
Pkg.add("DataFrames")
using Plots
using Polynomials
using Interpolations
using DataFrames
import Statistics
using Statistics


# wylosowanie węzłów interpolacji
xs =  1:1:10
A = [rand() for x in xs]
xsf = 1:0.01:10

scatter(xs, A, label = "random points")

function create_lagrange_interpolation(x_values, y_values)

    function lagrange_interpolation(value)
        point_number = size(x_values)[1]
        polymonial = ones(point_number)
        for k in 1:point_number
            for i in 1:point_number
                if i != k
                    polymonial[k]=polymonial[k]*(value-x_values[i])/(x_values[k]-x_values[i])
                end
            end
        end
        sum=0
        for j in 1:point_number
            sum = sum + polymonial[j]*y_values[j]
        end
        return sum
    end
    return lagrange_interpolation
end



function create_newton_interpolation(x_values, y_values)
    diff_quotients = []                 #differential quotients
    point_number = size(x_values)[1]
    for i in 1:point_number
        push!(diff_quotients, [])
    end

    function count_differential_quontients(level, index)
        index_2 = point_number - index + 1
        if level == 1
            push!(diff_quotients[level], y_values[index])
        elseif level == 2
                val=(y_values[index+1] - y_values[index])/(x_values[index+1]-x_values[index])
                push!(diff_quotients[level], val)

        else
            num = diff_quotients[level-1][index+1]-diff_quotients[level-1][index]
            denom = x_values[index+level-1] - x_values[index]
            val=(num/denom)
            push!(diff_quotients[level], val)
        end
    end

    function count_differential_quontients()
        for level in 1:point_number
            for index in 1:(point_number-level+1)
                count_differential_quontients(level, index)
            end
        end
    end
    count_differential_quontients()

    function count_newton_interpolation(value)
        result = y_values[1]
        counter = 0
        for k in 2:point_number
            to_add = diff_quotients[k][1]
            for l in 1:k-1
                to_add = to_add * (value-x_values[l])
            end
            result = result + to_add
        end
        return result
    end

    return count_newton_interpolation

end



fit_1 = polyfit(xs, A)
lagr_1 = create_lagrange_interpolation(xs, A)
B_fit_1 = [fit_1(x) for x in xsf]
B_lagr_1 = [lagr_1(x) for x in xsf]
newton_1 = create_newton_interpolation(xs, A)
B_newton_1 =[newton_1(x) for x in xsf]


scatter(xs, A, label = "data points")
plot!(xsf,B_fit_1, label="polynomial interpolation")

scatter(xs, A, label = "data points")
plot!(xsf,B_lagr_1, label="lagrange interpolation")

scatter(xs, A, label = "data points")
plot!(xsf,B_newton_1, label="newton interpolation")

scatter(xs, A, label = "data points")
plot!(xsf,B_fit_1, label="polynomial interpolation")
plot!(xsf,B_lagr_1, label="lagrange interpolation")
plot!(xsf,B_newton_1, label="newton interpolation")

lagrange_ar=[]
newton_ar=[]
poly_ar=[]
size_ar=[]

function create_10rows(size)
    for i in 1:10
        x_vals = 1:1:size
        y_vals = [rand() for x in x_vals]
        y = rand()*size
        lagr_time = @elapsed create_lagrange_interpolation(x_vals, y_vals)
        lagr = create_lagrange_interpolation(x_vals, y_vals)
        lagr_time += @elapsed lagr(y)

        newton_time = @elapsed create_newton_interpolation(x_vals, y_vals)
        newton = create_newton_interpolation(x_vals, y_vals)
        newton_time += @elapsed lagr(y)

        poly_time = @elapsed polyfit(x_vals, y_vals)
        fit = polyfit(x_vals, y_vals)
        poly_time += @elapsed fit(y)
        push!(lagrange_ar, lagr_time)
        push!(newton_ar, newton_time)
        push!(poly_ar, poly_time)
        push!(size_ar, size)
    end
end

function generate_stats(max)
    for i in 5:5:max
        create_10rows(i)
    end
end

generate_stats(100)

results = DataFrame()
results[:size] = size_ar
results[:lagrange] = lagrange_ar
results[:newton] = newton_ar
results[:poly] = poly_ar

cleared = by(results, :size, :2=>mean, :3=>mean, :4=>mean, :2=>std, :3=>std, :4=>std)
plot(cleared[:2], cleared[:3], cleared[:4])
plot_lagrange = plot(cleared[:1], [cleared[:2]], yerr=cleared[:5], ylabel= "n_time", label = "lagrange")
plot_newton = plot(cleared[:1], [cleared[:3]], yerr=cleared[:6], ylabel= "n_time", label = "newton")
plot_poly = plot(cleared[:1], [cleared[:4]], yerr=cleared[:7], ylabel= "n_time", label = "poly")

plot_all = plot(cleared[:1], [cleared[:2]], yerr=cleared[:5], label = "lagrange")
plot!(cleared[:1], [cleared[:3]], yerr=cleared[:6], label = "newton")
plot!(cleared[:1], [cleared[:4]], yerr=cleared[:7], label = "poly")

function splajn_simple(x_vals, y_vals)

    function toReturn(value)
        len = length(x_vals)
        index_upper = 1
        #for i in 1:len
        #    if value>x_vals[i]
        #        break
        #    end
        #end

        while value >= x_vals[index_upper]
            index_upper = index_upper + 1
            if index_upper>len
                break
            end
        end
        x1 = x_vals[1]
        result =0
        if x1>value
            diff =x1-value
            ang=(y_vals[2]-y_vals[1])/(x_vals[2]-x_vals[1])
            result =  y_vals[1] + diff*ang
        elseif index_upper >= len
            diff = value - x_vals[len]
            ang = (y_vals[len]-y_vals[len-1])/(x_vals[len]-x_vals[len-1])
            result = y_vals[len] + diff*ang
        else diff =value - x_vals[index_upper-1]
            ang = (y_vals[index_upper]-y_vals[index_upper-1])/(x_vals[index_upper]-x_vals[index_upper-1])
            result =y_vals[index_upper-1] + ang*diff
        end
        return result
    end
    return toReturn
end


splajn1 = splajn_simple(xs, A)
B_splajn = [splajn1(x) for x in xsf]
scatter(xsf, B_splajn)
