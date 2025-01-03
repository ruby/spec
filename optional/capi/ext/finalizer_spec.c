#include "ruby.h"
#include "rubyspec.h"

#ifdef __cplusplus
extern "C" {
#endif

static VALUE define_finalizer(VALUE self, VALUE obj, VALUE finalizer) {
  return rb_define_finalizer(obj, finalizer);
}

void Init_finalizer_spec(void) {
  VALUE cls = rb_define_class("CApiFinalizerSpecs", rb_cObject);

  rb_define_method(cls, "rb_define_finalizer", define_finalizer, 2);
}

#ifdef __cplusplus
}
#endif
