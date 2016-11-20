# zeta 用セッティング （Mathematica 出力データ利用）

# 
# Mathematica で以下のコマンドで out.csv を出力
# 
# Export["out.csv",
# Table[ N[Abs[Zeta[s + I t]]], {s, -40, 40, 0.1}, {t, -50, 50, 0.1} ]
# 
# out.csv を ./mathematica-data/out.csv 
# に配置して以下を実行
# 
# ruby stl.rb config3d-zeta-mathematica.rb
# 
#]


$stlname = "zeta-mathematica"
$output_path = "./result/#{$stlname}.stl"


$scale = 20.0*15.0/100.0
$z_scale = 1.0

$min_x = -40.0
$min_y = -50.0
$min_z = 0.0

$max_x = 40.0
$max_y = 50.0
$max_z = 30.0

$delta_x = 0.2
$delta_y = 0.2

$x_resolution = ($max_x - $min_x) / $delta_x
$y_resolution = ($max_y - $min_y) / $delta_y

$z_offset = 0.0 # mm





$zeta_array = Array.new

File.open("./mathematica-data/out.csv") do |io|
	io.each do |line|
		column = line.split(",").map(&:to_f)

		$zeta_array.push column
	end
end
#p $zeta_array



def zfunction(x, y)
	ix = ((x-$min_x) / $delta_x).to_i
	iy = ((y-$min_y) / $delta_y).to_i

	#puts "#{ix}, #{iy}"

	ix = (ix < 0) ? 0 : ix
	iy = (iy < 0) ? 0 : iy

	return $zeta_array[ix][iy]
end

