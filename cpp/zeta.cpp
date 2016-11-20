#include <iostream>
#include <complex>
#include <math.h>


// http://na-inet.jp/fft/chap03.pdf

const long double LOWER_THRESHOLD = 1.0e-4;
const long double UPPER_BOUND = 1.0e+4;
const int MAXNUM = 100;



// 複素三角関数
std::complex<long double> sin(std::complex<long double> s)
{
	std::complex<long double> i_c(0, 1.0);
	std::complex<long double> mi_c(0, -1.0);
	std::complex<long double> two(2.0, 0.0);

	return (std::exp(i_c*s) - std::exp(mi_c*s)) / (two*i_c);
}


// http://www.kurims.kyoto-u.ac.jp/~ooura/gamerf-j.html
// のコードを改変
std::complex<long double> cdgamma(std::complex<long double> x)
{
    std::complex<long double> y;
    long double xr, xi, wr, wi, ur, ui, vr, vi, yr, yi, t;

    xr = x.real();
    xi = x.imag();
    if (xr < 0) {
        wr = 1 - xr;
        wi = -xi;
    } else {
        wr = xr;
        wi = xi;
    }
    ur = wr + 6.00009857740312429;
    vr = ur * (wr + 4.99999857982434025) - wi * wi;
    vi = wi * (wr + 4.99999857982434025) + ur * wi;
    yr = ur * 13.2280130755055088 + vr * 66.2756400966213521 + 
        0.293729529320536228;
    yi = wi * 13.2280130755055088 + vi * 66.2756400966213521;
    ur = vr * (wr + 4.00000003016801681) - vi * wi;
    ui = vi * (wr + 4.00000003016801681) + vr * wi;
    vr = ur * (wr + 2.99999999944915534) - ui * wi;
    vi = ui * (wr + 2.99999999944915534) + ur * wi;
    yr += ur * 91.1395751189899762 + vr * 47.3821439163096063;
    yi += ui * 91.1395751189899762 + vi * 47.3821439163096063;
    ur = vr * (wr + 2.00000000000603851) - vi * wi;
    ui = vi * (wr + 2.00000000000603851) + vr * wi;
    vr = ur * (wr + 0.999999999999975753) - ui * wi;
    vi = ui * (wr + 0.999999999999975753) + ur * wi;
    yr += ur * 10.5400280458730808 + vr;
    yi += ui * 10.5400280458730808 + vi;
    ur = vr * wr - vi * wi;
    ui = vi * wr + vr * wi;
    t = ur * ur + ui * ui;
    vr = yr * ur + yi * ui + t * 0.0327673720261526849;
    vi = yi * ur - yr * ui;
    yr = wr + 7.31790632447016203;
    ur = std::log(yr * yr + wi * wi) * 0.5 - 1;
    ui = std::atan2(wi, yr);
    yr = std::exp(ur * (wr - 0.5) - ui * wi - 3.48064577727581257) / t;
    yi = ui * (wr - 0.5) + ur * wi;
    ur = yr * std::cos(yi);
    ui = yr * std::sin(yi);
    yr = ur * vr - ui * vi;
    yi = ui * vr + ur * vi;
    if (xr < 0) {
        wr = xr * 3.14159265358979324;
        wi = std::exp(xi * 3.14159265358979324);
        vi = 1 / wi;
        ur = (vi + wi) * std::sin(wr);
        ui = (vi - wi) * std::cos(wr);
        vr = ur * yr + ui * yi;
        vi = ui * yr - ur * yi;
        ur = 6.2831853071795862 / (vr * vr + vi * vi);
        yr = ur * vr;
        yi = ur * vi;
    }

    return std::complex<long double>(yr, yi);
}



// 解析接続された複素ゼータ関数
std::complex<long double> zeta(const std::complex<long double> &s)
{
	std::complex<long double> a_arr[MAXNUM+1];

  // あとで使う定数
	std::complex<long double> half(0.5, 0.0);
	std::complex<long double> one(1.0, 0.0);
	std::complex<long double> two(2.0, 0.0);
	std::complex<long double> rev(-1.0, 0.0);


  std::complex<long double> prev(1.0e+20, 0.0);


  // a_0 = 0.5 / (1 - 2^(1-s)) で初期化
  a_arr[0] = half / (one - std::pow( two, (one-s) ));

  std::complex<long double> sum(0.0, 0.0);
  sum = sum + a_arr[0];


	for( int n=1; n<=MAXNUM; n++ )
	{
		std::complex<long double> n_c(n, 0.0);

		for( int k=0; k<n; k++ )
		{
			std::complex<long double> k_c(k, 0.0);

			a_arr[k] = half * a_arr[k] * (n_c/(n_c-k_c));
			sum = sum + a_arr[k];
		}

		a_arr[n] = (rev*a_arr[n-1] * std::pow((n_c/(n_c+one)), s) / n_c);
		sum = sum + a_arr[n];

		// 差が閾値以下であれば「収束した」と判断して計算を終了する
		//if( (std::abs(prev - sum) / std::abs( sum )) < LOWER_THRESHOLD )
		if( std::abs(prev - sum) < LOWER_THRESHOLD )
		{
			break;			
		}
// /*
		// 大きな値は上記の収束判定がきかないため、UPPER_BOUND を超えると「打ち止め」して計算を終了する
		if( std::abs(sum) > UPPER_BOUND )
		{			
			break;
		}
// */

		prev = sum;

	}

	return sum;
}
 

/*
void test_run()
{
	for(int n=0; n<1000; n++)
	{
		for(int k=0; k<1000; k++)
		{
			long double x = 0.1*n - 50.0;
			long double y = 0.1*k - 50.0;
			//std::cout << std::norm(zeta(std::complex<long double>(x, y))) << std::endl;
			std::complex<long double> z = std::abs(zeta(std::complex<long double>(x, y)));
		}
		std::cout << n << std::endl;
	}

}


void test_critical()
{
	for(int k=0; k<1000; k++)
	{
		long double x = 0.5;
		long double y = 0.1*k;
		std::cout << std::abs(zeta(std::complex<long double>(x, y))) << std::endl;
	}

}
*/



// 関数等式を使って効率化した複素ゼータ関数
std::complex<long double> complex_zeta( std::complex<long double> s)
{
  long double x = s.real();
  long double y = s.imag();

  if( x < 0.0 )
  {
    // 関数等式で左右をひっくり返す
    std::complex<long double> inv_s(1-x, -y);
    std::complex<long double> inv_one(-1, 0);
    std::complex<long double> two(2.0, 0.0);
    std::complex<long double> pi_c(3.141592653589793238462643383279, 0.0);

    return std::pow(two, s) * std::pow(pi_c, inv_one*inv_s) * sin(pi_c*s/two) * cdgamma(inv_s) * zeta(inv_s);
  }
  else
  {
    return zeta(s);
  }

}


// ゼータ関数の絶対値
double abs_zeta2(double x, double y)
{
	std::complex<long double> s(x, y);
	
	return std::abs(complex_zeta(s));
}



// ゼータ関数の実部
double real_zeta2(double x, double y)
{
  std::complex<long double> s(x, y);
  
  return complex_zeta(s).real();
}



// ゼータ関数の虚部
double imag_zeta2(double x, double y)
{
  std::complex<long double> s(x, y);
  
  return complex_zeta(s).imag();
}




// ガンマ関数の絶対値
double abs_gamma2(double x, double y)
{
	std::complex<long double> s(x, y);
	return std::abs( cdgamma(s) );
}



// sin関数の絶対値
double abs_sin2(double x, double y)
{
  std::complex<long double> s(x, y);
  return std::abs( sin(s) );
}


/*
int main(int argc, char *argv[])
{

	
	if(argc > 1)
	{
		test_run();
	}
	else
	{
		test_critical();
	}

	return 0;
}
*/


/*
float pi()
{
  return 3.141593f;
}

int main()
{
  // 実部1.0f、虚部2.0fの複素数オブジェクトを作る
  std::complex<float> c(1.0f, 2.0f);

  // ストリーム出力
  std::cout << "output : " << c << std::endl;

  // 各要素の取得
  float real = c.real(); // 実部
  float imag = c.imag(); // 虚部
  std::cout << "real : " << real << std::endl;
  std::cout << "imag : " << imag << std::endl;

  // 演算
  std::complex<float> a(1.0f, 2.0f);
  std::complex<float> b(2.0f, 3.0f);
  std::cout << "a + b : " << a + b << std::endl;
  std::cout << "a - b : " << a - b << std::endl;
  std::cout << "a * b : " << a * b << std::endl;
  std::cout << "a / b : " << a / b << std::endl;

  // 各複素数の値を取得する
  std::cout << "abs : " << std::abs(c) << std::endl;   // 絶対値
  std::cout << "arg : " << std::arg(c) << std::endl;   // 偏角
  std::cout << "norm : " << std::norm(c) << std::endl; // ノルム
  std::cout << "conj : " << std::conj(c) << std::endl; // 共役複素数
  std::cout << "proj : " << std::proj(c) << std::endl; // リーマン球面への射影
  std::cout << "polar : " << std::polar(1.0f, pi() / 2.0f); // 極座標(絶対値：1.0、偏角：円周率÷2.0)から複素数を作る
}

*/


