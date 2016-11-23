require '../../ruby/zeta'
require 'complex'
require 'benchmark'


# ジーゲルのシータ関数
def siegelTheta t
	theta = 0.5*t*Math.log(t/(2*Math::PI)) - 0.5*t - Math::PI/8.0
	theta += 1.0/(48.0*t)
	theta += 7.0/(5760.0*(t**3))
	theta += 31.0/(80640.0*(t**5)) 
	theta += 127.0/(430080.0*(t**7))
	theta += 511.0/(1216512.0*(t**9))

	return theta
end


=begin
# ジーゲルのZ関数 (近似バージョン)
#  http://tsujimotter.hatenablog.com/entry/2014/07/01/201007
def siegelZ t
	sum = 0.0
	th = (t/(2.0*Math::PI))

	n = 1
	while n*n < th do
		sum += 2.0*Math.cos(siegelTheta(t) - t*Math.log(n.to_f))/Math.sqrt(n.to_f)
		n += 1
	end	
	
	return sum
end
=end


# ジーゲルのZ関数 (定義どおり)
def siegelZ t
	if t > 0 
		z = (Math::E ** (Complex::I * siegelTheta(t))) * Zeta.complex_zeta(Complex(0.5, t))
		return z.real
	else
		z = Zeta.complex_zeta(Complex(0.5, t))
		return z.real
	end
end



# 0.01 刻みで [0, 100) の範囲を出力
intervals = 0.01

result = Benchmark.realtime do
	File.open("siegel-log.csv", "w") do |io|
		10000.times do |i|
			t = i*intervals + 0
			io.puts "#{t}, #{siegelZ(t)}"
			puts "#{t}, #{siegelZ(t)}"

			#x = 0.5
			#y = t
			#puts "#{t} #{Zeta.abs_zeta2(x, y)}"
		end
	end
end
puts ""
puts "Processing time: #{result}s"
