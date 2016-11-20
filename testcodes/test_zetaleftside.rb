require '../cpp/zeta'

zeta = Zeta.new

#=begin
1000.times do |k|
   r = 0.1*k - 50

   puts "#{r}, #{zeta.real_zeta2(r, 0)}"
end
#=end

#puts zeta.real_zeta2(2,0)
#puts zeta.abs_zeta2(2,0)

