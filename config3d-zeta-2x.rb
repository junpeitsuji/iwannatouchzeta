# zeta 用セッティング （鑑賞用）

require './cpp/zeta'


$stlname = "zeta-2x"
$output_path = "./result/#{$stlname}.stl"


$scale = 20.0*15.0/100.0
$z_scale = 1.0

$min_x = -40.0*2
$min_y = -50.0*2
$min_z = 0.0

$max_x = 40.0*2
$max_y = 50.0*2
$max_z = 30.0*2

$delta_x = 0.2
$delta_y = 0.2

$x_resolution = ($max_x - $min_x) / $delta_x
$y_resolution = ($max_y - $min_y) / $delta_y

$z_offset = 0.0 # mm



@zeta = Zeta.new
def zfunction(x, y)
   @zeta.abs_zeta2(x, y)
end

