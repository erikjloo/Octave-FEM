function bool = is_vector(a)
  if isnumeric(a) && isvector(a)
    bool = true;
  else
    bool = false;
  end