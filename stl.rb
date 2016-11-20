# coding: utf-8
# 「触れるゼータ関数」のSTLファイルを作るスクリプト
#  
#  実行：
#  $ ruby stl.rb config3d-zeta-miniedition.rb
# 
# 

require 'matrix'

# デフォルトパス（config3d-xxx.rb で書き換えれる）
$output_path = "./result/result.stl"


if ARGV.size == 0 
	puts "No argument error:" 
	puts "   ruby stl.rb {config3d-xxx.rb}"
	puts "   ex. ruby stl.rb config3d-zeta-miniedition.rb"
	exit
end

filename = "./"+ARGV[0]
if !File.exist?(filename)
	puts "No configuretion file error:" 
	puts "   ruby stl.rb {config3d-xxx.rb}"
	exit
end




# config3d-xxx.rb を呼び出す
require filename




class Vector

  # 外積計算のメソッドを追加
  def outer_product(o)
    raise 'size#{self.size}' unless size == 3
    Vector[
      self[1] * o[2] - self[2] * o[1],
      self[2] * o[0] - self[0] * o[2],
      self[0] * o[1] - self[1] * o[0],
    ]
  end

  # 単位ベクトルを求める
  def unit 
  	prod = 1.0/self.r
  	return (self * prod)
  end

end

# 法線ベクトルを表すクラス
class Normal < Vector
	def to_s
		"normal  #{self[0]}  #{self[1]}  #{self[2]}"
	end
end


# 頂点座標を表すクラス
class Vertex < Vector
	def to_s
		"vertex  #{self[0]}  #{self[1]}  #{self[2]}"
	end
  
end

#=begin
# 面を与えるクラス
class Facet
	def initialize(vertex1, vertex2, vertex3)
		@vertex1 = vertex1
		@vertex2 = vertex2
		@vertex3 = vertex3

		n_vector = ( vertex2 - vertex1 ).outer_product( vertex3 - vertex1 ).unit
		@normal = Normal[n_vector[0], n_vector[1], n_vector[2]]
	end

	def to_s
		"facet #{@normal.to_s}\n" + 
		"\touter loop\n" + 
		"\t\t#{@vertex1.to_s}\n" + 
		"\t\t#{@vertex2.to_s}\n" + 
		"\t\t#{@vertex3.to_s}\n" + 
		"\tendloop\n" + 
		"endfacet"
	end
end
#=end





dx = ($max_x - $min_x) / $x_resolution.to_f
dy = ($max_y - $min_y) / $y_resolution.to_f


def tx(x,y)
	#(x-$min_x)*$scale
	(y-$min_y)*$scale
end

def ty(x,y)
	#(y-$min_y)*$scale
	($max_x-x)*$scale
end

def tz z
	(z-$min_z)*$scale*$z_scale + $z_offset
end


# 二変数関数
def function x, y

	if ((x-1)*(x-1) + y*y) < 0.02 then
		return z = $max_z

	else
		# config で設定された zfunction をここで利用する
		 z = zfunction(x, y)
	end

	if z > $max_z then
		return $max_z
	else
		return z
	end
end




#=begin

File.open($output_path, "w") do |io|
	io.puts "solid #{$stlname}"


	# X 軸 を走査
	t = $min_x
	while t < $max_x
		puts "X-axis: #{t}"

		x = t
		y = $min_y

		x2= x + dx
		if x2 >= $max_x then
			x2 = $max_x
		end

		v0 = Vertex[tx(x, y), ty(x, y), 0]
		v1 = Vertex[tx(x2,y), ty(x2,y), 0]
		v2 = Vertex[tx(x, y), ty(x, y), tz( function(x,  y) )]
		v3 = Vertex[tx(x2,y), ty(x2,y), tz( function(x2, y) )]

		facet = Facet.new( v0, v1, v2 )
		io.puts "#{facet.to_s}"

		facet = Facet.new( v3, v2, v1 )
		io.puts "#{facet.to_s}"


		x = $max_x - t + $min_x
		y = $max_y

		x2= x - dx
		if x2 <= $min_x then
			x2 = $min_x
		end

		v0 = Vertex[tx(x, y), ty(x, y), 0]
		v1 = Vertex[tx(x2,y), ty(x2,y), 0]
		v2 = Vertex[tx(x, y), ty(x, y), tz( function(x,  y) )]
		v3 = Vertex[tx(x2,y), ty(x2,y), tz( function(x2, y) )]

		facet = Facet.new( v0, v1, v2 )
		io.puts "#{facet.to_s}"

		facet = Facet.new( v3, v2, v1 )
		io.puts "#{facet.to_s}"

		t += dx
	end


	# Y 軸 を走査
	t = $min_y
	while t < $max_y
		puts "Y-axis: #{t}"

		x = $min_x
		y = t

		y2= y + dy
		if $max_y <= y2 then
			y2 = $max_y
		end

		v0 = Vertex[tx(x,y),  ty(x,y),  0]
		v1 = Vertex[tx(x,y2), ty(x,y2), 0]
		v2 = Vertex[tx(x,y),  ty(x,y),  tz( function(x, y ) )]
		v3 = Vertex[tx(x,y2), ty(x,y2), tz( function(x, y2) )]

		facet = Facet.new( v0, v2, v1 )
		io.puts "#{facet.to_s}"

		facet = Facet.new( v3, v1, v2 )
		io.puts "#{facet.to_s}"

		x = $max_x
		y = $max_y - t + $min_y

		y2= y - dy
		if y2 <= $min_y then
			y2 = $min_y
		end

		v0 = Vertex[tx(x,y),  ty(x,y),  0]
		v1 = Vertex[tx(x,y2), ty(x,y2), 0]
		v2 = Vertex[tx(x,y),  ty(x,y),  tz( function(x, y) )]
		v3 = Vertex[tx(x,y2), ty(x,y2), tz( function(x, y2) )]

		facet = Facet.new( v0, v2, v1 )
		io.puts "#{facet.to_s}"

		facet = Facet.new( v3, v1, v2 )
		io.puts "#{facet.to_s}"

		t += dy
	end


	# XY 平面を走査
	y = $min_y
	while y < $max_y
		puts "XY-plain: #{y}"

		x = $min_x
		while x < $max_x

			x2 = x + dx
			if x2 >= $max_x then 
				x2 = $max_x 
			end
			y2 = y + dy
			if y2 >= $max_y then 
				y2 = $max_y 
			end

			v0 = Vertex[tx(x, y),  ty(x, y),  tz( function(x,  y ) )]
			v1 = Vertex[tx(x2,y),  ty(x2,y),  tz( function(x2, y ) )]
			v2 = Vertex[tx(x, y2), ty(x, y2), tz( function(x,  y2) )]
			v3 = Vertex[tx(x2,y2), ty(x2,y2), tz( function(x2, y2) )]

			facet = Facet.new( v0, v1, v2 )
			io.puts "#{facet.to_s}"

			facet = Facet.new( v3, v2, v1 )
			io.puts "#{facet.to_s}"

			# Z 平面の土台を作る
			v0 = Vertex[tx(x, y),  ty(x, y),  0]
			v1 = Vertex[tx(x2,y),  ty(x2,y),  0]
			v2 = Vertex[tx(x, y2), ty(x, y2), 0]
			v3 = Vertex[tx(x2,y2), ty(x2,y2), 0]
			facet = Facet.new( v0, v2, v1 )
			io.puts "#{facet.to_s}"
			facet = Facet.new( v3, v1, v2 )
			io.puts "#{facet.to_s}"

			x += dx
		end

		y += dy
	end

	io.puts "endsolid #{$stlname}"
end


print "\a"   # ビープ音
