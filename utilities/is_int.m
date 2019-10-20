function bool = is_int(a)
  if isscalar(a) && mod(a,1) == 0
    bool = true;
  else
    bool = false;
  end