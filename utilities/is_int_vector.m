function bool = is_int_vector(a)
  if isnumeric(a) && isvector(a) && all(mod(a,1) == 0)
    bool = true;
  else
    bool = false;
  end