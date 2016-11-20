#include <new>
#include <ruby.h>
#include "zeta.h"


static VALUE wrap_Zeta_real_zeta2(VALUE self, VALUE x_value, VALUE y_value)
{
  double x = NUM2DBL(x_value);
  double y = NUM2DBL(y_value);
  double retval = real_zeta2(x, y);

  return rb_float_new(retval);
}


static VALUE wrap_Zeta_imag_zeta2(VALUE self, VALUE x_value, VALUE y_value)
{
  double x = NUM2DBL(x_value);
  double y = NUM2DBL(y_value);
  double retval = imag_zeta2(x, y);

  return rb_float_new(retval);
}



static VALUE wrap_Zeta_sin(VALUE self, VALUE x_value, VALUE y_value)
{
  double x = NUM2DBL(x_value);
  double y = NUM2DBL(y_value);
  double retval = abs_sin2(x, y);

  return rb_float_new(retval);
}


static VALUE wrap_Zeta_zeta(VALUE self, VALUE x_value, VALUE y_value)
{
  double x = NUM2DBL(x_value);
  double y = NUM2DBL(y_value);
  double retval = abs_zeta2(x, y);

  return rb_float_new(retval);
}


static VALUE wrap_Zeta_gamma(VALUE self, VALUE x_value, VALUE y_value)
{
  double x = NUM2DBL(x_value);
  double y = NUM2DBL(y_value);
  double retval = abs_gamma2(x, y);

  return rb_float_new(retval);
}


extern "C" void Init_zeta()
{
  VALUE c = rb_define_class("Zeta", rb_cObject);

  rb_define_method(c, "real_zeta2", RUBY_METHOD_FUNC(wrap_Zeta_real_zeta2), 2); 
  rb_define_method(c, "imag_zeta2", RUBY_METHOD_FUNC(wrap_Zeta_imag_zeta2), 2); 

  rb_define_method(c, "abs_zeta2", RUBY_METHOD_FUNC(wrap_Zeta_zeta), 2); 
  rb_define_method(c, "abs_gamma2", RUBY_METHOD_FUNC(wrap_Zeta_gamma), 2); 
  rb_define_method(c, "abs_sin2", RUBY_METHOD_FUNC(wrap_Zeta_sin), 2); 
}

