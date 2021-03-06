# sin 関数 用セッティング （3Dプリンタ用）

require './cpp/zeta'


$stlname = "sin-miniedition"
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



@zeta = Zeta.new
def zfunction(x, y)
   @zeta.abs_sin2(x, y)
end

