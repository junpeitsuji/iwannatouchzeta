# zeta.rb

require 'complex'

LOWER_THRESHOLD = 1.0e-4
UPPER_BOUND = 1.0e+4
MAXNUM = 100

#include(Math)



# 複素指数関数
def cexp(s)
    Math::E ** s
end


# 複素三角関数
def csin(s)
	return ((cexp(Complex::I*s) - cexp(-Complex::I*s))) / (2.0)
	#Math::sin( s )
end



# 複素ガンマ関数
#   http://www.kurims.kyoto-u.ac.jp/~ooura/gamerf-j.html
# のコードを改変
def cdgamma(x)

    #long double xr, xi, wr, wi, ur, ui, vr, vi, yr, yi, t

    xr = x.real
    xi = x.imag
    if (xr < 0)
        wr = 1 - xr
        wi = -xi
    else
        wr = xr
        wi = xi
    end

    ur = wr + 6.00009857740312429
    vr = ur * (wr + 4.99999857982434025) - wi * wi
    vi = wi * (wr + 4.99999857982434025) + ur * wi
    yr = ur * 13.2280130755055088 + vr * 66.2756400966213521 + 
        0.293729529320536228
    yi = wi * 13.2280130755055088 + vi * 66.2756400966213521
    ur = vr * (wr + 4.00000003016801681) - vi * wi
    ui = vi * (wr + 4.00000003016801681) + vr * wi
    vr = ur * (wr + 2.99999999944915534) - ui * wi
    vi = ui * (wr + 2.99999999944915534) + ur * wi
    yr += ur * 91.1395751189899762 + vr * 47.3821439163096063
    yi += ui * 91.1395751189899762 + vi * 47.3821439163096063
    ur = vr * (wr + 2.00000000000603851) - vi * wi
    ui = vi * (wr + 2.00000000000603851) + vr * wi
    vr = ur * (wr + 0.999999999999975753) - ui * wi
    vi = ui * (wr + 0.999999999999975753) + ur * wi
    yr += ur * 10.5400280458730808 + vr
    yi += ui * 10.5400280458730808 + vi
    ur = vr * wr - vi * wi
    ui = vi * wr + vr * wi
    t = ur * ur + ui * ui
    vr = yr * ur + yi * ui + t * 0.0327673720261526849
    vi = yi * ur - yr * ui
    yr = wr + 7.31790632447016203
    ur = Math::log(yr * yr + wi * wi) * 0.5 - 1
    ui = Math::atan2(wi, yr)
    yr = Math::exp(ur * (wr - 0.5) - ui * wi - 3.48064577727581257) / t
    yi = ui * (wr - 0.5) + ur * wi
    ur = yr * Math::cos(yi)
    ui = yr * Math::sin(yi)
    yr = ur * vr - ui * vi
    yi = ui * vr + ur * vi

    if (xr < 0)
        wr = xr * 3.14159265358979324
        wi = Math::exp(xi * 3.14159265358979324)
        vi = 1 / wi
        ur = (vi + wi) * Math::sin(wr)
        ui = (vi - wi) * Math::cos(wr)
        vr = ur * yr + ui * yi
        vi = ui * yr - ur * yi
        ur = 6.2831853071795862 / (vr * vr + vi * vi)
        yr = ur * vr
        yi = ur * vi
    end

    return Complex(yr, yi)

end





# 解析接続された複素ゼータ関数
def zeta(s)

	a_arr = Array.new(MAXNUM+1)

	prev = 1.0e+20


	# a_0 = 0.5 / (1 - 2^(1-s)) で初期化
	a_arr[0] = 0.5 / (1.0 - (2.0**(1.0-s)))

	sum = a_arr[0]


	(1..MAXNUM).each do |n|

		(0..(n-1)).each do |k|
			a_arr[k] = 0.5 * a_arr[k] * (n/(n-k).to_f)
			sum = sum + a_arr[k]
		end

		a_arr[n] = (-a_arr[n-1] * ((n/(n+1).to_f) ** s) / n.to_f)
		sum = sum + a_arr[n]

		# 差が閾値以下であれば「収束した」と判断して計算を終了する
		if( (prev - sum).abs < LOWER_THRESHOLD )
			break			
		end

		# 大きな値は上記の収束判定がきかないため、UPPER_BOUND を超えると「打ち止め」して計算を終了する
		if( sum.abs > UPPER_BOUND )
			break
		end	

		prev = sum

	end

	return sum

end
 



# 関数等式を使って効率化した複素ゼータ関数
def complex_zeta(s)
  x = s.real
  y = s.imag

  if( x < 0.0 )
    inv_s = Complex(1-x, -y)

    return (2.0 ** s) * (Math::PI ** (-inv_s)) * csin(0.5*Math::PI*s) * cdgamma(inv_s) * zeta(inv_s)

  else
    return zeta(s)

  end

end



# ゼータ関数の絶対値
def abs_zeta2(x, y)
	s = Complex(x, y)
	return complex_zeta(s).abs
end






def test_run()
	(0..1000).each do |n|
		(0..1000).each do |k|
			x = 0.1*n - 50.0
			y = 0.1*k - 50.0
			z = abs_zeta2(x, y)
		end
		puts n
	end

end


def test_critical()
	(0..1000).each do |k|
		x = 0.5
		y = 0.1*k;
		puts abs_zeta2(x, y)
	end

end


# テスト実行
#test_run
#test_critical




