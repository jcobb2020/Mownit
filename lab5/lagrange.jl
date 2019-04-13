cd()
cd("Mownit/lab5")

using Plots
using Polymonial
using Interpolations

# wylosowanie węzłów interpolacji
xs =  1:1:10
xd = 0:2:20
A = [rand() for x in xs]

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


fit1 = polyfit(xs, A)
