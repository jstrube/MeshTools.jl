
using MeshTools
using Base.Test

#creates a spherical density volume
function genData(minPt, maxPt, resx, resy, resz, fun)
  data = zeros(resx, resy, resz)
  for i=1:resx
    for j=1:resy
      for k=1:resz
        disp = maxPt - minPt
        pos = minPt + Array{Float64}([i-1, j-1, k-1]) ./ [resx, resy, resz] .* disp
        data[i, j, k] = fun(pos...)
      end
    end
  end
  return data
end

data = genData([-1, -1, -1], [1, 1, 1], 5, 5, 5, (x, y, z)->exp(-x*x-y*y-z*z))
pos, ind = createMesh(data, 10, 10, 10, -5, -5, -5, 0.5, 1, 0.1)
println("points in raw mesh: $(size(pos)[2])")
pos, ind = removeDoubles(pos, ind, 1e-9, true)

saveObj(pos, ind, "../output/temptest3.obj")

p = countParts(size(pos)[2], ind)
@test p == 1

ind2 = [1, 2, 3, 1, 4, 5, 1, 6, 7]
@test countParts(7, ind2) == 1

ind3 = [1, 2, 3, 1, 4, 5, 6, 7, 8]
@test countParts(8, ind3) == 2

println(separate(8, ind3))
