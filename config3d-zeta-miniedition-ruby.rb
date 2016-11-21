# zeta 用セッティング （ミニエディション, 3Dプリンタ用）

require './ruby/zeta'


$stlname = "zeta-miniedition"
$output_path = "./result/#{$stlname}.stl"

$scale = 20.0*15.0/100.0
$z_scale = 5.0

$min_x = -11.0
$min_y = -25 
$min_z = 0.0

$max_x = 14.0
$max_y = 25 
$max_z = 4.0

$delta_x = 0.1
$delta_y = 0.1

$x_resolution = ($max_x - $min_x) / $delta_x
$y_resolution = ($max_y - $min_y) / $delta_y

$z_offset = 4.0 # mm



def zfunction(x, y)
   Zeta.abs_zeta2(x, y)
end

