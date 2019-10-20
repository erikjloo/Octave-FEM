function bool = is_cell(a)
  if iscell(a) && isvector(a)
    bool = true;
  else
    bool = false;
  end