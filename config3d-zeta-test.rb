# zeta 用セッティング （3Dプリンタ用？）

require './cpp/zeta'


$stlname = "zeta-abs-4x-display"
$output_path = "./result/#{$stlname}.stl"


$scale = 20.0
$z_scale = 1.0

$min_x = -11.0
$min_y = -40.0
$min_z = 0.0

$max_x = 21.0
$max_y = 40.0
$max_z = 12.0

$z_offset = 20.0

$delta_x = 0.2
$delta_y = 0.2

$x_resolution = ($max_x - $min_x) / $delta_x
$y_resolution = ($max_y - $min_y) / $delta_y

$z_offset = 4.0 # mm




@zeta = Zeta.new
def zfunction(x, y)
   @zeta.abs_zeta2(x, y)
end

